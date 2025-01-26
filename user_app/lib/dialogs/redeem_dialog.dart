import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/Pages/rating/rate_shop_page.dart';
import 'package:rates/services/auth/auth_service.dart';
import 'package:rates/services/cloud/cloud_storage_exception.dart';
import 'package:rates/services/cloud/firebase_cloud_storage.dart';

class VerificationDialogPage extends StatelessWidget {
  const VerificationDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    final FirebaseCloudStorage cloudService = FirebaseCloudStorage();

    // Get the current theme
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final userInfo = AuthService.firebase().currentUser;
    return Dialog(
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color.fromARGB(255, 33, 33, 33)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          height: userInfo!.isAnonymous
              ? AspectRatios.height * 0.325
              : AspectRatios.height * 0.395,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logos/black_logo.svg',
                height: AspectRatios.height * 0.06,
                colorFilter: ColorFilter.mode(
                  isDarkMode ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: AspectRatios.height * 0.02),
              Text(
                userInfo.isAnonymous
                    ? "You can't rate right now because you are logged in as a guest."
                    : "Redeem Your Meal Code.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              if (userInfo.isAnonymous == false) ...[
                SizedBox(height: AspectRatios.height * 0.02),
                SizedBox(
                  height: AspectRatios.height * 0.055,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: const TextSelectionThemeData(
                        cursorColor: Color.fromARGB(255, 255, 196, 45),
                        selectionHandleColor: Color.fromARGB(255, 255, 196, 45),
                      ),
                    ),
                    child: TextField(
                      cursorColor: const Color.fromARGB(255, 255, 196, 45),
                      controller: codeController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        labelText: "Enter Code",
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 196, 45),
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
              if (userInfo.isAnonymous == false) ...[
                SizedBox(height: AspectRatios.height * 0.01),
                Text(
                  "Codes are found at the end or top of your bill.",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              SizedBox(height: AspectRatios.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Cancel Button
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? const Color(0xFF616161)
                          : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  // Redeem Button
                  ElevatedButton(
                    onPressed: userInfo.isAnonymous
                        ? () {
                          Get.offAllNamed('/login/');
                        }
                        : () async {
                            String enteredCode = codeController.text;
                            try {
                              await cloudService.getReceiptInfo(enteredCode);
                              print('object');
                              Get.to(
                                  () => const RateProductPage(
                                        restaurant: '',
                                        meals: [],
                                        rating: '',
                                        logo: '',
                                      ),
                                  arguments: {
                                    'order_id': enteredCode,
                                  });
                            } on CodeDoesNotExist {
                              Get.snackbar(
                                "Invalid Code",
                                "The code you entered is not valid.",
                                titleText: const Text(
                                  "Invalid Code",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                messageText: const Text(
                                  "The code you entered is not valid.",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 191, 191, 191),
                                colorText: Colors.white,
                                margin: const EdgeInsets.only(
                                    top: 10, left: 7, right: 7),
                                padding: const EdgeInsets.all(5),
                                boxShadows: [
                                  const BoxShadow(
                                    color: Color.fromARGB(255, 56, 56, 56),
                                    offset: Offset(0, 2),
                                    blurRadius: 5,
                                    spreadRadius: 0.5,
                                  )
                                ],
                              );
                            } catch (_) {
                              Get.snackbar(
                                "Invalid Code",
                                "The code you entered is not valid.",
                                titleText: const Text(
                                  "Invalid Code",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                messageText: const Text(
                                  "The code you entered is not valid.",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 191, 191, 191),
                                colorText: Colors.white,
                                margin: const EdgeInsets.only(
                                    top: 10, left: 7, right: 7),
                                padding: const EdgeInsets.all(5),
                                boxShadows: [
                                  const BoxShadow(
                                    color: Color.fromARGB(255, 56, 56, 56),
                                    offset: Offset(0, 2),
                                    blurRadius: 5,
                                    spreadRadius: 0.5,
                                  )
                                ],
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 196, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      userInfo.isAnonymous ? "Login" : "Redeem",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? Colors.black
                            : Colors.white, // Adjust button text color
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
