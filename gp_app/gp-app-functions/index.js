const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Function to add a rating
exports.addRating = functions.https.onCall(async (data, context) => {
  const { restaurantId, userId, rating } = data;

  // Reference to the restaurant's document
  const restaurantRef = admin.firestore().collection('restaurants').doc(restaurantId);
  const userRef = admin.firestore().collection('users').doc(userId);

  // Fetch current restaurant data
  const restaurantDoc = await restaurantRef.get();
  let newRatingArray = [];

  if (restaurantDoc.exists) {
    // Get the existing ratings
    const ratings = restaurantDoc.data().ratings || [];
    ratings.push(rating);  // Add the new rating to the list
    newRatingArray = ratings;
  }

  // Calculate the new average rating
  const sum = newRatingArray.reduce((acc, curr) => acc + curr, 0);
  const averageRating = sum / newRatingArray.length;

  // Update restaurant document with the new rating array and the average
  await restaurantRef.update({
    ratings: newRatingArray,
    averageRating: averageRating,
  });

  // Optionally, store user's rating for tracking purposes
  await userRef.set({
    ratings: {
      [restaurantId]: rating,
    },
  }, { merge: true });

  return { message: "Rating added successfully!" };
});
