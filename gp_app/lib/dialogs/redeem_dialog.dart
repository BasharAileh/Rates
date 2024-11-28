import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rates/constants/aspect_ratio.dart'; 
import 'package:rates/Pages/rating/rate_res_page.dart';

class VerificationDialogPage extends StatelessWidget {
  const VerificationDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Map of valid codes to restaurants and meals
    final Map<String, Map<String, dynamic>> validCodes = {
      "CODE123": {
        "restaurant": "BurgarMaker",
        "meals": [
          "2X Shewarma with extra sauce",
          "Honey mustard boneless wings",
          "Kenwa salad"
        ],
        "rating":"4.5",
        "logo":"assets/images/BurgarMaker_Logo.jpeg"
      },
      "CODE456": {
        "restaurant": "Another Restaurant",
        "meals": ["Meal A", "Meal B", "Meal C"],
        "rating":"3.5"
      },
    };

    final TextEditingController codeController = TextEditingController();

    return Dialog(
      backgroundColor: const Color.fromARGB(0, 0, 0, 0), // Transparent background
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur effect
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          height: AspectRatios.height*0.43, // Adjusted height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logos/black_logo.svg',
                height: AspectRatios.height * 0.06,
              ),
               SizedBox(height: AspectRatios.height*0.02),
              const Text(
                "Redeem Your Meal Code",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AspectRatios.height*0.02),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: "Enter Code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: AspectRatios.height*0.01),
              const Text(
                "Codes are found at the end or top of your bill.",
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 158, 158, 158),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AspectRatios.height*0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Redeem Button
                  ElevatedButton(
                    onPressed: () {
                      String enteredCode = codeController.text.trim();
                      if (validCodes.containsKey(enteredCode)) {
                        Map<String, dynamic> restaurantData =
                            validCodes[enteredCode]!;
                        Get.back(); // Close the dialog
                        Get.to(() => RateMealPage(
                              restaurant: restaurantData['restaurant'],
                              meals: restaurantData['meals'],
                              rating: restaurantData['rating'],
                              logo: restaurantData['logo'],
                            ));
                      } else {
                        Get.snackbar(
                          "Invalid Code",
                          "The code you entered is not valid.",
                          backgroundColor: const Color.fromARGB(255, 244, 67, 54),
                          colorText: const Color.fromARGB(255, 255, 255, 255),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 255, 196, 45), // Yellow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Redeem",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  // Cancel Button
                  ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 158, 158, 158),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
