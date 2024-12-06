import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/constants/widgets.dart';
import 'dart:developer' as devtools show log;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

bool _isEmailSelected = true;

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  late final List<TextEditingController> _controllers;
  late AnimationController _animationController;
  late Animation<Offset> _emailSlideAnimation;
  late Animation<Offset> _phoneSlideAnimation;

  List<DropdownMenuItem<String>> countryItems = [
    const DropdownMenuItem(
      value: '00962',
      child: Text('Jordan'),
    ),
    const DropdownMenuItem(
      value: '01',
      child: Text('United States'),
    ),
    const DropdownMenuItem(
      value: '02',
      child: Text('India'),
    ),
    const DropdownMenuItem(
      value: '03',
      child: Text('United Kingdom'),
    ),
  ];

  @override
  void initState() {
    _controllers = List.generate(4, (_) => TextEditingController());
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _emailSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _phoneSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.07,
              vertical: height * 0.1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign Up to Rates',
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.03),
                const Text(
                  'Choose your sign-up method',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: height * 0.02),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment: _isEmailSelected
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        width: width * 0.4,
                        height: height * 0.04,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!_isEmailSelected) {
                              setState(() {
                                _isEmailSelected = true;
                                _animationController.forward(from: 0);
                              });
                            }
                          },
                          child: Container(
                            width: width * 0.4,
                            height: height * 0.04,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                style: TextStyle(
                                  color: _isEmailSelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                duration: const Duration(milliseconds: 300),
                                child: const Text('Email'),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_isEmailSelected) {
                              setState(() {
                                _isEmailSelected = false;
                                _animationController.forward(from: 0);
                              });
                            }
                          },
                          child: Container(
                            width: width * 0.4,
                            height: height * 0.04,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                style: TextStyle(
                                  color: !_isEmailSelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                duration: const Duration(milliseconds: 300),
                                child: const Text('Phone'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                ...List.generate(
                  4,
                  (index) {
                    if (index == 1) {
                      return Column(
                        children: [
                          if (_isEmailSelected)
                            SlideTransition(
                              position: _emailSlideAnimation,
                              child: customTextField(
                                controller: _controllers[index],
                                height: height * 0.06,
                              ),
                            ),
                          if (!_isEmailSelected)
                            SlideTransition(
                              position: _phoneSlideAnimation,
                              child: Flexible(
                                child: phoneNumberTextField(
                                  phoneController: _controllers[index],
                                  initialCountryCode: '01',
                                  countryItems: countryItems,
                                  onCountryChanged: (item) {},
                                  borderRadius: 37.5,
                                  height: height * 0.06,
                                ),
                              ),
                            ),
                          SizedBox(height: height * 0.03),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        customTextField(
                          controller: _controllers[index],
                          height: height * 0.06,
                        ),
                        SizedBox(height: height * 0.03),
                      ],
                    );
                  },
                ),
                SizedBox(height: height * 0.02),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      devtools.log('Sign Up button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      fixedSize: Size(AspectRatios.width * 0.58717948717,
                          AspectRatios.height * 0.05450236966),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(37.5),
                      ),
                    ),
                    child: const Text('Sign Up'),
                  ),
                ),
                SizedBox(height: height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(loginRoute);
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/* 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/constants/widgets.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

bool _isEmailSelected = true;

class _SignupPageState extends State<SignupPage> {
  late final List<TextEditingController> _controllers;
  @override
  void initState() {
    _controllers = List.generate(4, (_) => TextEditingController());
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AspectRatios.height * 0.13210900473,
          horizontal: AspectRatios.width * 0.07051282051,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AspectRatios.height * 0.03672985781,
              width: AspectRatios.width * 0.85897435897,
              child: const Text(
                'Sign Up to Rates',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: AspectRatios.height * 0.03554502369),
            GestureDetector(
              onTap: () {
                Get.offNamed(loginRoute);
              },
              child: const Text(
                'Choose your sign-up method',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(
              height: AspectRatios.height * 0.01777251184,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                // Animated background for the selected button
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: _isEmailSelected
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    width: AspectRatios.width * 0.42948717948,
                    height: AspectRatios.height * 0.02606635071,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                // Buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEmailSelected = true;
                        });
                      },
                      child: Container(
                        width: AspectRatios.width * 0.42948717948,
                        height: AspectRatios.height * 0.02606635071,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors
                              .transparent, // Background handled by animated layer
                        ),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            style: TextStyle(
                              color: _isEmailSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            duration: const Duration(
                                milliseconds: 300), // Smooth color transition
                            curve: Curves.easeInOut,
                            child: const Text('Email'),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isEmailSelected = false;
                        });
                      },
                      child: Container(
                        width: AspectRatios.width * 0.42948717948,
                        height: AspectRatios.height * 0.02606635071,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors
                              .transparent, // Background handled by animated layer
                        ),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            style: TextStyle(
                              color: !_isEmailSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            duration: const Duration(
                                milliseconds: 300), // Smooth color transition
                            curve: Curves.easeInOut,
                            child: const Text('0779980801'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: AspectRatios.height * 0.02,
            ),
            ...List.generate(
              4,
              (index) {
                if (index == 1) {
                  if (_isEmailSelected == true) {
                    return Column(
                      children: [
                        customTextField(
                          height: AspectRatios.height * 0.05450236966,
                        ),
                        SizedBox(
                          height: AspectRatios.height * 0.02665876777,
                        )
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        phoneNumberTextField(
                          phoneController: _controllers[index],
                          countryItems: [],
                          onCountryChanged: (_) {},
                          dropdownWidth: AspectRatios.width * 0.20256410256,
                          borderRadius: 37.5,
                          height: AspectRatios.height * 0.05450236966,
                          spaceWidth: AspectRatios.width * 0.01538461538,
                          textFieldWidth: AspectRatios.width * 0.64102564102,
                        ),
                        SizedBox(
                          height: AspectRatios.height * 0.02665876777,
                        )
                      ],
                    );
                  }
                }
                return Column(
                  children: [
                    customTextField(
                        height: AspectRatios.height * 0.05450236966),
                    SizedBox(
                      height: AspectRatios.height * 0.02665876777,
                    )
                  ],
                );
              },
            ),
            SizedBox(
              height: AspectRatios.height * 0.00888625592,
            ),
            SizedBox(
              height: AspectRatios.height * 0.03554502369,
              child: Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (_) {},
                  ),
                  const Flexible(
                    child: Text(
                      'By creating an account, you are agreeing with Rates terms and conditions',
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: AspectRatios.height * 0.00829383886,
            ),
            SizedBox(
              height: AspectRatios.height * 0.02843601895,
              child: Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (_) {},
                  ),
                  const Text(
                    'Email me new updates',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: AspectRatios.height * 0.02665876777,
            ),
            SizedBox(
              height: AspectRatios.height * 0.05450236966,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Sign Up'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(37.5),
                      ),
                      minimumSize: Size(
                        AspectRatios.width * 0.34871794871,
                        double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: AspectRatios.width * 0.03,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0),
                      shadowColor: Colors.white.withOpacity(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(37.5),
                      ),
                      minimumSize: Size(
                        AspectRatios.width * 0.34871794871,
                        double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AspectRatios.height * 0.02665876777),
            SizedBox(
              height: AspectRatios.height * 0.02251184834,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  GestureDetector(
                    onTap: () {
                      Get.offNamed(loginRoute);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 */
