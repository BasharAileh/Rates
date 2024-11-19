import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';

class RatingPage extends StatefulWidget {
  final String restaurantName;
  final String restaurantLogo;
  final List<Map<String, String>> meals;

  const RatingPage({
    required this.restaurantName,
    required this.restaurantLogo,
    required this.meals,
    super.key,
  });

  @override
  RatingPageState createState() => RatingPageState();
}

class RatingPageState extends State<RatingPage> {
  // Ratings for the restaurant
  double foodRating = 0.0;
  double serviceRating = 0.0;
  double priceRating = 0.0;

  // Customer's opinion
  final TextEditingController opinionController = TextEditingController();

  // Ratings for meals
  Map<String, double> mealRatings = {};

  @override
  void initState() {
    super.initState();
    // Initialize meal ratings
    for (var meal in widget.meals) {
      mealRatings[meal['name']!] = 0.0;
    }
  }

  void submitRatings() {
    if (mealRatings.values.every((rating) => rating > 0) &&
        foodRating > 0 &&
        serviceRating > 0 &&
        priceRating > 0) {
      // Display a thank-you message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for submitting your ratings!'),
        ),
      );
    } else {
      // Display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all ratings before submitting.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Your Experience'),
        centerTitle: true,
        backgroundColor: AppColors.appBarColor, // Use your home page AppBar color
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Horizontal_background.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Restaurant Logo and Name
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.restaurantLogo),
                    radius: 50,
                  ),
                  Text(
                    widget.restaurantName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Ratings Section Container with Opacity
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackgroundOpacity, // Semi-transparent background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Rate the Restaurant',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Food Rating
                        const Text('Food'),
                        RatingBar.builder(
                          initialRating: foodRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              foodRating = rating;
                            });
                          },
                        ),
                        const SizedBox(height: 6),

                        // Service Rating
                        const Text('Service'),
                        RatingBar.builder(
                          initialRating: serviceRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              serviceRating = rating;
                            });
                          },
                        ),
                        const SizedBox(height: 6),

                        // Prices Rating
                        const Text('Prices'),
                        RatingBar.builder(
                          initialRating: priceRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              priceRating = rating;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Opinion Section
                  const Text(
                    'Your Opinion',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: opinionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Share your experience...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meal Ratings Section
                  const Text(
                    'Rate the Meals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...widget.meals.map((meal) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Meal Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    meal['image']!,
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Meal Name
                                Expanded(
                                  child: Text(
                                    meal['name']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Meal Rating
                            RatingBar.builder(
                              initialRating: mealRatings[meal['name']]!,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  mealRatings[meal['name']!] = rating;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Submit Button
                  Center(
                    child: ElevatedButton(
                      onPressed: submitRatings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:const Color.fromARGB(255, 244, 143, 66),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Submit Ratings'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
