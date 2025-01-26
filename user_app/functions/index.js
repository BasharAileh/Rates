const { getFirestore } = require("firebase-admin/firestore");
const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { Client } = require('square');  
const admin = require('firebase-admin');
const functions = require('firebase-functions');
const express = require('express');


// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp();
} else {
  admin.app();  // Use the existing app if already initialized
}

// Initialize Firestore
const db = getFirestore();



// Helper function to update Bayesian and category averages
async function updateBayesianAndCategory(collectionName, entityID, categoryID, incomingRating, averageField, bayesianField) {
  const batch = db.batch();

  const entity = await db.collection(collectionName).doc(entityID.toString()).get();
  let entityAverageRating = entity.data()[averageField] || 0;
  let numberOfRatings = entity.data().number_of_ratings || 0;

  entityAverageRating = ((entityAverageRating * numberOfRatings) + incomingRating) / (numberOfRatings + 1);
  numberOfRatings++;

  const bayesianQuery = await db.collection("bayesian").where("category_id", "==", categoryID).get();


  const bayesian = bayesianQuery.docs[0];
  let categoryBayesianAverage = bayesian.data().bayesian_average;
  const minimumRatingsRequired = bayesian.data().minimum_ratings_required;
  let categoryNumberOfRatings = bayesian.data().number_of_ratings;

  const entityBayesianAverage = ((minimumRatingsRequired * categoryBayesianAverage) + (entityAverageRating * numberOfRatings)) / (minimumRatingsRequired + numberOfRatings);

  batch.update(entity.ref, {
    [bayesianField]: entityBayesianAverage,
    number_of_ratings: numberOfRatings,
    [averageField]: entityAverageRating,
  });

  categoryBayesianAverage = ((categoryBayesianAverage * categoryNumberOfRatings) + incomingRating) / (categoryNumberOfRatings + 1);
  categoryNumberOfRatings++;

  batch.update(bayesian.ref, {
    bayesian_average: categoryBayesianAverage,
    number_of_ratings: categoryNumberOfRatings,
  });

  await batch.commit();
}

// Helper function to update the shop rating
async function updateShop(shopID, newRating) {
  const shopQuery = await db.collection("shop").doc(shopID.toString()).get();
  if (!shopQuery.empty) {
    const shopDocRef = shopQuery.ref;
    const shopData = shopQuery.data();

    let shopRating = shopData.bayesian_average || 3;
    let shopNumberOfRatings = shopData.number_of_ratings || 0;
    shopRating = ((shopRating * shopNumberOfRatings) + newRating) / (shopNumberOfRatings + 1);
    shopNumberOfRatings++;

    await shopDocRef.update({
      annual_bayesian_average : shopRating,
      bayesian_average: shopRating,
      number_of_ratings: shopNumberOfRatings,
    });

  } else {
    console.error("Shop document not found for shop_id:", shopID);
  }
}

// Firestore trigger for document creation in product_rating
exports.onProductUpdateOrModified = onDocumentCreated(
  { document: 'product_rating/{docId}' },
  async (event) => {
    const ratingDoc = await db.collection("product_rating").doc(event.params.docId).get();
    const { product_id, product_category_id, rating_value } = ratingDoc.data();
    
    if (typeof rating_value === "number" && rating_value >= 0 && rating_value <= 5) {
      try {
        console.log("Product rating data:", ratingDoc.data());
        
        await updateBayesianAndCategory(
          "product",
          product_id,
          product_category_id,
          rating_value,
          "product_average_rating",
          "bayesian_average"
        );

        const product = await db.collection("product").doc(product_id.toString()).get();
        const shopID = product.data().shop_id;
        await updateShop(shopID, product.data().bayesian_average);

        console.log("Product and related data updated successfully.");
      } catch (error) {
        console.error("Error updating product data:", error);
      }
    }
  }
);

// Firestore trigger for document creation in service_rating
exports.onServiceUpdateOrModified = onDocumentCreated(
  { document: 'service_rating/{docId}' },
  async (event) => {
    try {
      const ratingDoc = await db.collection("service_rating").doc(event.params.docId).get();
      const { service_id, service_category_id, rating_value } = ratingDoc.data();

      await updateBayesianAndCategory(
        "service",
        service_id,
        service_category_id,
        rating_value,
        "service_average_rating",
        "bayesian_average"
      );

      const service = await db.collection("service").doc(service_id.toString()).get();
      const shopID = service.data().shop_id;
      await updateShop(shopID, service.data().bayesian_average);

      console.log("Service and related data updated successfully.");
    } catch (error) {
      console.error("Error updating service data:", error);
    }
  }
);



const accessToken ='EAAAltBLwKm9E3W-kAGx8DW5Jaevx1bCFU7Lh3mpt0fMVPmaa3IhErSyMvfA7VSw';

const squareClient = new Client({
  accessToken: accessToken,
  environment: 'production',
});

async function getShopName(accessToken) {
  try {
    const response = await axios.get('https://connect.squareup.com/v2/locations', {
      headers: {
        'Authorization': 'Bearer ${accessToken}',
      }
    });
    
    const shopName = response.data.locations[0].business_name;
    return shopName;
  } catch (error) {
    console.error('Error fetching shop name: ', error);
  }
}



exports.handleSquareWebhook = functions.https.onRequest(async (req, res) => {
  try {
    console.log('Received webhook:', req.body);

    const eventType = req.body.type;

    if (eventType === 'payment.created') {
      const paymentData = req.body.data.object.payment;

      // Extract order ID
      const orderId = paymentData.order_id;

      if (orderId) {
        // Fetch order details
        const { ordersApi } = squareClient;
        const response = await ordersApi.retrieveOrder(orderId);

        if (response.result && response.result.order) {
          const order = response.result.order;

          console.log('Order Details:', order);
          let receipt = {}; // Initializing receipt as an object

          // Directly setting properties on the object
          receipt.shop_id = req.body.merchant_id;

          // Loop through order line items and add them to the receipt
          for (const lineItem of order.lineItems) {
            const product_name = lineItem.name;
            const product_quantity = parseInt(lineItem.quantity);
            const product_price = lineItem.basePriceMoney.amount;
          
            const productData = {
              product_quantity,
              product_price,
            };
          
            // Initialize 'products' as a map (object) if it doesn't exist
            if (!receipt.products) {
              receipt.products = {};
            }
          
            // Check if the product already exists in the map
            if (receipt.products[product_name]) {
              // Update the quantity if the product exists
              receipt.products[product_name].product_quantity += product_quantity;
            } else {
              // Add a new product to the map
              receipt.products[product_name] = productData;
            }
          }
          

          // Store the receipt in the database
          await db.collection('receipt').doc(orderId).set(receipt);

          // Log details
          console.log('Order Items:', order.lineItems);
          console.log('Order Total:', order.totalMoney);

        } else {
          console.log('Order not found');
        }
      } else {
        console.log('No order ID associated with this payment');
      }
    } else {
      console.log('Unhandled event type:', eventType);
    }

    res.status(200).send('Webhook received successfully');
  } catch (error) {
    console.error('Error processing webhook:', error);
    res.status(500).send('Internal Server Error');
  }
});
