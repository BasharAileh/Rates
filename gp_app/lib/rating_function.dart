Map<String, double> calculateRestaurantBayesianAverage({
  required double delivery,
  required double cleanliness,
  required double pricing,
  required List mealsRatings,
  required double globalRestaurantRating, // Global average rating
  required int minimumRatings, // Minimum number of ratings for Bayesian calculation
  required double
      currentRestaurantRating, // Current average rating of the product
  required int
      restaurantRatingsnum, // Current number of ratings for the product
}) {
  double avergeServiceRatings =
      (((delivery + cleanliness + pricing) / 3) * 0.4);
  double averagemealsRatings =
      ((mealsRatings.fold(0.0, (double sum, rating) => sum + rating)) /
              mealsRatings.length) *
          0.6;
  double restRating = (avergeServiceRatings + averagemealsRatings);
  // Bayesian average calculation
  double numerator = (globalRestaurantRating * minimumRatings) +
      (currentRestaurantRating * restaurantRatingsnum) +
      restRating;
  int denominator = minimumRatings + restaurantRatingsnum + 1;
  double updatedRestaurantRate = numerator / denominator;

  return {
    'updatedRestaurantRate': updatedRestaurantRate,
    'restRating': restRating,
  };
}

Map<String, double> calculateMealBayesianAverage({
  required List<double> mealsRatings,
  required List<double> mealsGlobalRating, // Global average rating
  required int minimumRatings, // Minimum number of ratings for Bayesian calculation
  required List<double>
      mealsCurrentRating, // Current average rating of the product
  required List<int>
      mealsRatingsnum, // Current number of ratings for the product
}) {
  // double averagemealsRatings =
  //     ((mealsRatings.fold(0.0, (double sum, rating) => sum + rating)) /
  //             mealsRatings.length) * 0.6;
  // Bayesian average calculation
  Map<String, double> updatedMealRates = {};

  // Loop through each meal and calculate its updated rating
  for (int i = 0; i < mealsRatings.length; i++) {
    double globalRating =
        mealsGlobalRating[i]; // Global average rating for the meal
    double currentRating =
        mealsCurrentRating[i]; // Current average rating for the meal
    int numRatings = mealsRatingsnum[i]; // Number of ratings for the meal

    // Bayesian average calculation
    double numerator = (globalRating * minimumRatings) + (currentRating * numRatings);
    int denominator = minimumRatings + numRatings + 1;
    double updatedMealRate = numerator / denominator;

    // Store the updated rating for the meal
    updatedMealRates['meal_${i+1}\n'] = updatedMealRate;
  }

  return updatedMealRates;
}

void main() {
  double delivery = 4.8; // Example delivery rating
  double cleanliness = 4.7; // Example cleanliness rating
  double pricing = 4.9; // Example pricing rating
  List<double> mealsRatings = [4.5, 4.7, 4.9, 4.3, 4.8]; // Example meal ratings
  double currentRestaurantRating = 3.5; // Example current average rating
  int restaurantRatingsnum = 50; // Example number of ratings
  double globalRestaurantRating = 2.5; // Global average rating
  int minimumRatings = 5; // Minimum ratings for Bayesian calculation
  List<double> mealsGlobalRating = [4.0, 3.8, 4.2,4.5,3.2];
  List<double> mealsCurrentRating = [4.4, 4.1, 4.3,2.3,3.6];
  List<int> mealsRatingsnum = [30, 20, 25,64,48];

  Map<String, double> updatedRestaurantRates =
      calculateRestaurantBayesianAverage(
    delivery: delivery,
    cleanliness: cleanliness,
    pricing: pricing,
    mealsRatings: mealsRatings,
    currentRestaurantRating: currentRestaurantRating,
    restaurantRatingsnum: restaurantRatingsnum,
    globalRestaurantRating: globalRestaurantRating,
    minimumRatings: minimumRatings,
  );
  Map<String, double> updatedMealRate = calculateMealBayesianAverage(
      mealsRatings: mealsRatings,
      mealsGlobalRating: mealsGlobalRating,
      minimumRatings: minimumRatings,
      mealsCurrentRating: mealsCurrentRating,
      mealsRatingsnum: mealsRatingsnum);
      
  print('Updated Meal Ratings: $updatedMealRate');
  print('user restuarant Rating: ${updatedRestaurantRates['restRating']}');
  print('Updated restuarant Rating: ${updatedRestaurantRates['updatedRestaurantRate']}');
}
