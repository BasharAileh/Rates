const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");

initializeApp();

const db = getFirestore();


async function updateBayesianAndCategory(collectionName, entityID, categoryID, incomingRating, averageField, bayesianField) {
  const batch = db.batch();

  const entity = await db.collection(collectionName).doc(entityID.toString()).get();
  let entityAverageRating = entity.data()[averageField] || 0;
  let numberOfRatings = entity.data().number_of_ratings || 0;

  entityAverageRating = ((entityAverageRating * numberOfRatings) + incomingRating) / (numberOfRatings + 1);
  numberOfRatings++;

  const bayesianQuery = await db.collection("bayesian").where("category_id", "==", categoryID).get();
  if (bayesianQuery.empty) throw new Error(`Bayesian document not found for category_id: ${categoryID}`);

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

async function updateShop(shopID, newRating) {
  const shopQuery = await db.collection("shop").doc(shopID.toString()).get();
  if (!shopQuery.empty) {
    const shopDocRef = shopQuery.docs[0].ref;
    const shopData = shopQuery.docs[0].data();

    let shopRating = shopData.bayesian_average || 3; 
    let shopNumberOfRatings = shopData.number_of_ratings || 0;
    shopRating = ((shopRating * shopNumberOfRatings) + newRating) / (shopNumberOfRatings + 1);
    shopNumberOfRatings++;

    await shopDocRef.update({
      bayesian_average: shopRating,
      number_of_ratings: shopNumberOfRatings,
    });

  } else {
    console.error("Shop document not found for shop_id:", shopID);
  }
}

exports.onProductUpdateOrModified = onDocumentCreated(
  { document: "product_rating/{docId}" },
  async (event) => {
    const ratingDoc = await db.collection("product_rating").doc(event.params.docId).get();
    const { product_id, product_category_id, rating_value } = ratingDoc.data();
    
    if(typeof rating_value === "number" && rating_value >= 0 && rating_value <= 5) {
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

exports.onSurviceUpdateOrModified = onDocumentCreated(
  { document: "service_rating/{docId}" },
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











/* const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { onDocumentWritten, onDocumentCreated } = require("firebase-functions/v2/firestore");

initializeApp();

const db = getFirestore();

exports.onProductUpdateOrModified = onDocumentCreated(
  { document: "product_rating/{docId}" },
  async (event) => {
    try {
      const data = await db.collection("product_rating").doc(event.params.docId).get();
      const productID = data.data().product_id;
      const productCategoryID = data.data().product_category_id;
      const inccomingRating = data.data().rating_value;



      let bayesian = await db.collection("bayesian")
        .where("category_id", "==", productCategoryID)
        .get();

        bayesian = bayesian.docs[0];
        let categoryBayesianAverage = bayesian.data().bayesian_average;
        const minimumRatingsRequired = bayesian.data().minimum_ratings_required;
        let categoryNumberOfRatings = bayesian.data().number_of_ratings;
      

      const product = await db.collection("product")
        .doc(productID.toString())
        .get();
        let productAverageRating = product.data().product_average_rating
        let numberOfRatings = product.data().number_of_ratings;

      productAverageRating = ((productAverageRating * numberOfRatings) + inccomingRating) / (numberOfRatings + 1);
      numberOfRatings = numberOfRatings + 1;

      const productBayesianAverage = ((minimumRatingsRequired * categoryBayesianAverage) + (productAverageRating * numberOfRatings)) / (minimumRatingsRequired + numberOfRatings);

      await db.collection("product")
        .doc(productID.toString())
        .update(
          {
            bayesian_average : productBayesianAverage,
            number_of_ratings : numberOfRatings,
            product_average_rating : productAverageRating
          },
        );
      
      categoryBayesianAverage = (((categoryBayesianAverage * categoryNumberOfRatings) + inccomingRating) / (categoryNumberOfRatings + 1));
      categoryNumberOfRatings = categoryNumberOfRatings + 1;
        
      const docRef = bayesian.ref;
      await docRef.update(
          {
            bayesian_average : categoryBayesianAverage,
            number_of_ratings : categoryNumberOfRatings,
            minimum_ratings_required : minimumRatingsRequired
          },
          { merge: true }
        );  

        const shop = await db.collection("shop")
        .doc(product.data().shop_id.toString())
        .get();

        let shopRating = shop.data().shop_rating;
        let shopNumberOfRatings = shop.data().number_of_ratings;
        shopRating = ((shopRating * shopNumberOfRatings) + productBayesianAverage) / (shopNumberOfRatings + 1);
        shopNumberOfRatings = shopNumberOfRatings + 1;

      console.log("Target collection updated successfully.");
    } catch (error) {
      console.error("Error updating target collection:", error);
    }
  }
);




exports.onSurviceUpdateOrModified = onDocumentCreated(
  { document: "service_rating/{docId}" },
  async (event) => {
    try {
      const data = await db.collection("service_rating").doc(event.params.docId).get();
      const serviceID = data.data().service_id;
      const serviceCategoryID = data.data().service_category_id;
      const inccomingRating = data.data().rating_value;



      let bayesian = await db.collection("bayesian")
        .where("category_id", "==", serviceCategoryID)
        .get();
        bayesian = bayesian.docs[0];
        let categoryBayesianAverage = bayesian.data().bayesian_average;
        const minimumRatingsRequired = bayesian.data().minimum_ratings_required;
        let categoryNumberOfRatings = bayesian.data().number_of_ratings;
      

      const service = await db.collection("service")
        .doc(serviceID.toString())
        .get();
        let serviceAverageRating = service.data().service_average_rating
        let numberOfRatings = service.data().number_of_ratings;

        serviceAverageRating = ((serviceAverageRating * numberOfRatings) + inccomingRating) / (numberOfRatings + 1);
      numberOfRatings = numberOfRatings + 1;

      const serviceBayesianAverage = ((minimumRatingsRequired * categoryBayesianAverage) + (serviceAverageRating * numberOfRatings)) / (minimumRatingsRequired + numberOfRatings);

      await db.collection("service")
        .doc(serviceID.toString())
        .update(
          {
            bayesian_average : serviceBayesianAverage,
            number_of_ratings : numberOfRatings,
            service_average_rating : serviceAverageRating
          },
        );
      
      categoryBayesianAverage = (((categoryBayesianAverage * categoryNumberOfRatings) + inccomingRating) / (categoryNumberOfRatings + 1));
      categoryNumberOfRatings = categoryNumberOfRatings + 1;
      
      const docRef = bayesian.ref;

      await docRef.update(
          {
            bayesian_average : categoryBayesianAverage,
            number_of_ratings : categoryNumberOfRatings,
            minimum_ratings_required : minimumRatingsRequired
          },
          { merge: true }
        );

        const shop = await db.collection("shop")
        .doc(product.data().shop_id.toString())
        .get();

        let shopRating = shop.data().shop_rating;
        let shopNumberOfRatings = shop.data().number_of_ratings;
        shopRating = ((shopRating * shopNumberOfRatings) + productBayesianAverage) / (shopNumberOfRatings + 1);
        shopNumberOfRatings = shopNumberOfRatings + 1;

      console.log("Target collection updated successfully.");
    } catch (error) {
      console.error("Error updating target collection:", error);
    }
  }
) */