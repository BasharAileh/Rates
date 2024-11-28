import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/constants/aspect_ratio.dart';

class RateMealPage extends StatefulWidget {
  final String restaurant;
  final List<String> meals;
  final String rating;
  final String logo;

  const RateMealPage({
    super.key,
    required this.restaurant,
    required this.meals,
    required this.rating,
    required this.logo,
  });

  @override
  State<RateMealPage> createState() => RateMealPageState();
}

class RateMealPageState extends State<RateMealPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rate your meals',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () => Navigator.pop(context), // Navigate back
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(15, 30, 15, 100),
        children: [
          // Restaurant Header
          buildRestaurantHeader(),
          RestaurantRatingCard(restaurantName: widget.restaurant),
          // Meals List
          const Text(
            "Rate the meals you enjoyed:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.meals.length,
            itemBuilder: (context, index) => MealRatingCard(mealName: widget.meals[index]),
          ),
          buildFooterButtons(context),
        ],
      ),
    );
  }

  // Reusable widget to build the restaurant header
  Widget buildRestaurantHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to ${widget.restaurant}!",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
         SizedBox(height: AspectRatios.height*0.025),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.logo, height: AspectRatios.height*0.08, width: AspectRatios.width*0.2),
             SizedBox(width: AspectRatios.width*0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.restaurant,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rating of ${widget.rating} stars!",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Reusable footer buttons for submission and feedback
  Widget buildFooterButtons(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text("Thank You!"),
                  content: Text("Your ratings have been submitted."),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 196, 45),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              "Submit Ratings",
              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text("We’re Sorry!"),
                  content: Text("Please let us know what went wrong."),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 33, 150, 243)),
            child: const Text(
              "This wasn’t what I ordered",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Rating Slider Widget
class RatingSlider extends StatelessWidget {
  final String? label;
  final double currentRating;
  final ValueChanged<double> onChanged;

  const RatingSlider({
    super.key,
     this.label,
    required this.currentRating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label??"",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: currentRating,
                onChanged: onChanged,
                min: 0,
                max: 5,
                divisions: 10,
                label: currentRating.toStringAsFixed(1),
                activeColor: const Color.fromARGB(255, 255, 196, 45),
              ),
            ),
            Text(
              "${currentRating.toStringAsFixed(1)} / 5",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

// Restaurant Rating Card using RatingSlider
class RestaurantRatingCard extends StatefulWidget {
  final String restaurantName;

  const RestaurantRatingCard({super.key, required this.restaurantName});

  @override
  RestaurantRatingCardState createState() => RestaurantRatingCardState();
}

class RestaurantRatingCardState extends State<RestaurantRatingCard> {
  double deliveryRating = 0;
  double cleanlinessRating = 0;
  double pricingRating = 0;

  bool isRatingVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Restaurant Services",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              isRatingVisible
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isRatingVisible = false; // Collapse the slider
                        });
                      },
                      icon:  Icon(
                        Icons.keyboard_arrow_up,
                        size: AspectRatios.height*0.055,
                        color: const Color.fromARGB(255, 255, 196, 45),
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          isRatingVisible = true; // Expand the slider
                        });
                      },
                      child: const Text(
                        "Rate",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 255, 196, 45),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
          if (isRatingVisible) ...[
            RatingSlider(
              label: "Delivery",
              currentRating: deliveryRating,
              onChanged: (value) {
                setState(() {
                  deliveryRating = value;
                });
              },
            ),
            RatingSlider(
              label: "Cleanliness",
              currentRating: cleanlinessRating,
              onChanged: (value) {
                setState(() {
                  cleanlinessRating = value;
                });
              },
            ),
            RatingSlider(
              label: "Pricing",
              currentRating: pricingRating,
              onChanged: (value) {
                setState(() {
                  pricingRating = value;
                });
              },
            ),
          ],
        ],
      ),
    );
  }
}

// Meal Rating Card using RatingSlider
class MealRatingCard extends StatefulWidget {
  final String mealName;

  const MealRatingCard({super.key, required this.mealName});

  @override
  MealRatingCardState createState() => MealRatingCardState();
}

class MealRatingCardState extends State<MealRatingCard> {
  double mealRating = 0;
  bool isRatingVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.mealName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              isRatingVisible
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isRatingVisible = false; // Collapse the slider
                        });
                      },
                      icon:  Icon(
                        Icons.keyboard_arrow_up,
                        size: AspectRatios.height*0.055,
                        color: const Color.fromARGB(255, 255, 196, 45),
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          isRatingVisible = true; // Expand the slider
                        });
                      },
                      child: const Text(
                        "Rate",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 255, 196, 45),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
          if (isRatingVisible)
            RatingSlider(
              currentRating: mealRating,
              onChanged: (value) {
                setState(() {
                  mealRating = value;
                });
              },
            ),
        ],
      ),
    );
  }
}
