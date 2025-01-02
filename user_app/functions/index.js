const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { onDocumentWritten } = require("firebase-functions/v2/firestore");

initializeApp();

const db = getFirestore();

exports.onProductUpdateOrModified = onDocumentWritten(
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

      console.log("Target collection updated successfully.");
    } catch (error) {
      console.error("Error updating target collection:", error);
    }
  }
);




exports.onSurviceUpdateOrModified = onDocumentWritten(
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


      console.log("Target collection updated successfully.");
    } catch (error) {
      console.error("Error updating target collection:", error);
    }
  }
)