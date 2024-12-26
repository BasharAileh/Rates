import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rates/Pages/shop/rest_info_page.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/dialogs/nav_bar.dart';

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
  double mealRating = 0;
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
          icon:
              const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  // Restaurant Header
                  buildRestaurantHeader(),
                  SizedBox(height: AspectRatios.height * 0.035),
                  // Meals List
                  const Row(
                    children: [
                      Text(
                        "Rate the meals you enjoyed:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  for (String meal in widget.meals)
                    MealRatingCard(
                      mealName: meal,
                      currentRating: mealRating,
                      onChanged: (value) {
                        setState(() {
                          mealRating = value;
                        });
                      },
                    ),
                  SizedBox(height: AspectRatios.height * 0.01),
                  const Row(
                    children: [
                      Text(
                        "Rate the restuarant services:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  RestaurantRatingCard(restaurantName: widget.restaurant),
                   SizedBox(height: AspectRatios.height*0.178),
                  buildFooterButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }

  // Reusable widget to build the restaurant header
  Widget buildRestaurantHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => RestaurantInformationPage());
          },
          child: Image.asset(widget.logo,
              height: AspectRatios.height * 0.08,
              width: AspectRatios.width * 0.2),
        ),
        SizedBox(width: AspectRatios.width * 0.02),
        Text(
          widget.restaurant,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Reusable footer buttons for submission and problem
  Widget buildFooterButtons(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/verfication_success.svg',
                            width: AspectRatios.width*0.2,
                            height: AspectRatios.height*0.2,
                          ),
                           SizedBox(height: AspectRatios.height*0.01),
                          const Text(
                            'Your ratings have been submitted!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 196, 45),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              Future.delayed(const Duration(seconds: 4), () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 196, 45),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              "Submit Ratings",
              style:
                  TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
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
            style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 33, 150, 243)),
            child: const Text(
              "This wasn’t what I ordered",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
          label ?? "",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SliderTheme(
                data: const SliderThemeData(
                  valueIndicatorTextStyle:
                      TextStyle(fontSize: 10, color: Colors.black),
                ),
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
            ),
            Text(
              "${currentRating.toStringAsFixed(1)} / 5",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
  Map<String, double> ratings = {
    "Delivery": 0,
    "Cleanliness": 0,
    "Pricing": 0,
  };
  bool isRatingVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AspectRatios.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Restaurant Services",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              isRatingVisible
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isRatingVisible = false; // Collapse the slider
                        });
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_up,
                        size: AspectRatios.height * 0.045,
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
                          fontSize: 16,
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
              currentRating: ratings["Delivery"]!,
              onChanged: (value) {
                setState(() {
                  ratings["Delivery"] = value;
                });
              },
            ),
            RatingSlider(
              label: "Cleanliness",
              currentRating: ratings["Cleanliness"]!,
              onChanged: (value) {
                setState(() {
                  ratings["Cleanliness"] = value;
                });
              },
            ),
            RatingSlider(
              label: "Pricing",
              currentRating: ratings["Pricing"]!,
              onChanged: (value) {
                setState(() {
                  ratings["Pricing"] = value;
                });
              },
            ),
            OpinionTextBox(
              hintText: "How was the overall service at the restaurant?",
            )
          ],
        ],
      ),
    );
  }
}

// Meal Rating Card using RatingSlider
class MealRatingCard extends StatefulWidget {
  final String mealName;
  final double currentRating;
  final ValueChanged<double> onChanged;

  const MealRatingCard(
      {super.key,
      required this.mealName,
      required this.currentRating,
      required this.onChanged});

  @override
  MealRatingCardState createState() => MealRatingCardState();
}

class MealRatingCardState extends State<MealRatingCard> {
  bool isRatingVisible = false;
  double currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AspectRatios.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.mealName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              isRatingVisible
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isRatingVisible = false; // Collapse the slider
                        });
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_up,
                        size: AspectRatios.height * 0.040,
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
                          fontSize: 14,
                          color: Color.fromARGB(255, 255, 196, 45),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
          if (isRatingVisible)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SliderTheme(
                        data: const SliderThemeData(
                          valueIndicatorTextStyle:
                              TextStyle(fontSize: 10, color: Colors.black),
                        ),
                        child: Slider(
                          value: currentRating,
                          onChanged: (value) {
                            setState(() {
                              currentRating = value; // Update local state
                            });
                            widget.onChanged(
                                value); // Call onChanged from parent to update external state
                          },
                          min: 0,
                          max: 5,
                          divisions: 10,
                          label: currentRating.toStringAsFixed(1),
                          activeColor: const Color.fromARGB(255, 255, 196, 45),
                        ),
                      ),
                    ),
                    Text(
                      "${currentRating.toStringAsFixed(1)} / 5",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                OpinionTextBox(
                  hintText: "Share your thoughts about the meal...",
                )
              ],
            ),
        ],
      ),
    );
  }
}

class OpinionTextBox extends StatelessWidget {
  final String hintText;

  const OpinionTextBox({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.only(left: 13, right: 13),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: TextField(
        maxLength: 200,
        cursorColor: const Color.fromARGB(255, 255, 196, 45),
        maxLines: 2, // Allow multi-line input
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }
}
