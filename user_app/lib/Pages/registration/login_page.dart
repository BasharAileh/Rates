import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/constants/widgets.dart';
import 'package:rates/services/auth/auth_exception.dart';
import 'package:rates/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final List<TextEditingController> _controllers;
  bool _bottomEnabled = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(2, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var element in _controllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: AspectRatios.height * 0.150379146919,
          left: AspectRatios.width * 0.07051282051,
          right: AspectRatios.width * 0.07051282051,
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/logos/black_logo.svg',
                      width: 80,
                      color: isDarkMode ? AppColors.primaryColor : Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: AspectRatios.height * 0.04909953,
                  ),
                  Row(
                    children: [
                      Text(
                        'Login to Rates',
                        style: TextStyle(
                          fontSize: AspectRatios.width * 0.05641025641,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AspectRatios.height * 0.03554502369),
                  ...List.generate(2, (index) {
                    final List<String> titles = [
                      'Email or Phone Number',
                      'Password',
                    ];
                    return Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            SizedBox(
                              height: (AspectRatios.height * 0.01895734597),
                              child: Text(
                                index == 0 ? titles[0] : titles[1],
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        customTextField(
                          controller: _controllers[index],
                          onChanged: (_) {
                            if (_controllers
                                .every((element) => element.text.isNotEmpty)) {
                              setState(() {
                                _bottomEnabled = true;
                              });
                            } else {
                              setState(() {
                                _bottomEnabled = false;
                              });
                            }
                          },
                          height: AspectRatios.height * 0.054,
                        ),
                        if (index == 0)
                          SizedBox(
                            height: AspectRatios.height * 0.03554502369,
                          ),
                      ],
                    );
                  }),
                  SizedBox(
                    height: AspectRatios.height * 0.01777251,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        fixedSize: Size(AspectRatios.width * 0.58717948717,
                            AspectRatios.height * 0.05450236966),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(37.5),
                        ),
                      ),
                      onPressed: _bottomEnabled
                          ? () async {
                              final email = _controllers[0].text;
                              final password = _controllers[1].text;
                              try {
                                await AuthService.firebase().logIn(
                                  email: email,
                                  password: password,
                                );
                                Get.offNamed(homeRoute);
                              } on UserNotFoundAuthException catch (e) {
                                Get.snackbar(
                                  'User not found',
                                  e.toString(),
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } on InvalidEmailAuthException catch (e) {
                                Get.snackbar(
                                  'Invalid credentials',
                                  e.toString(),
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } on GenericAuthException catch (e) {
                                Get.snackbar(
                                  'Error',
                                  e.toString(),
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  e.toString(),
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            }
                          : null,
                      child: const SizedBox(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AspectRatios.height * 0.01421801,
                  ),
                  SizedBox(
                    height: AspectRatios.height * 0.02251185,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(),
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: textColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offNamed(
                              signupRoute,
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AspectRatios.height * 0.03406398,
                  ),
                  Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: textColor,
                            thickness: 1,
                          ),
                        ),
                        Text('or sign in with email',
                            style: TextStyle(color: textColor)),
                        Expanded(
                          child: Divider(
                            color: textColor,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AspectRatios.height * 0.01421801,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        fixedSize: Size(AspectRatios.width,
                            AspectRatios.height * 0.05450236966),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(37.5),
                        ),
                        side: BorderSide(
                          color: textColor,
                          width: 1,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await AuthService.google().logIn();
                          Get.offNamed(homeRoute);
                        } catch (e) {
                          devtools.log(e.toString());
                        }
                      },
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/google.svg',
                              width: 20,
                              height: 20,
                            
                            ),
                            SizedBox(
                              width: AspectRatios.width * 0.02564102564,
                            ),
                            Text(
                              'Continue with Google',
                              style: TextStyle(color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AspectRatios.height * 0.03406398,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        await AuthService.firebase().logInAnonymously();
                        devtools.log(
                            'User: ${AuthService.firebase().currentUser}');
                        Get.offNamed(homeRoute);
                      },
                      child: const Text(
                        'Continue as Guest',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
