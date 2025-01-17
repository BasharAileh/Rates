import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin_app/constants/app_colors.dart';
import 'package:admin_app/constants/routes.dart';
import 'package:admin_app/constants/widgets.dart';
import 'package:admin_app/pages/registration/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

List<String> _textFields = [
  'Username',
  'Email',
  'Phone Number',
  'Password',
  'Confirm Password',
  'Address link',
];

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  late final List<TextEditingController> _controllers;
  late List<bool> _isSelected;
  bool _bottomEnabled = false;
  String? _passwordsMatch;
  bool _isPasswordVisible = false;
  XFile? _logoImage;

  String username = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
  String confirmPassword = '';
  String address = '';
  String pictureUrl = '';
  String pictureName = '';

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
    _isSelected = [false, true];
    _controllers = List.generate(6, (_) => TextEditingController());
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _isSelected.clear();
    super.dispose();
  }

  Future<void> _pickLogoImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _logoImage = image;
      if (image != null) {
        pictureUrl = image.path;
        pictureName = image.name;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.1 - keyboardHeight / 2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign Up to Rates',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Text fields
                ...List.generate(
                  6,
                  (index) {
                    if (index == 2) {
                      return Column(
                        children: [
                          phoneNumberTextField(
                            onTextfieldChanged: (value) {
                              phoneNumber = value;
                              if (_controllers.every((controller) =>
                                      controller.text.isNotEmpty) &&
                                  _controllers[3].text ==
                                      _controllers[4].text &&
                                  _isSelected[0]) {
                                setState(() {
                                  _bottomEnabled = true;
                                });
                              } else {
                                setState(() {
                                  _bottomEnabled = false;
                                });
                              }
                            },
                            hintText: _textFields[index],
                            phoneController: _controllers[index],
                            initialCountryCode: '01',
                            countryItems: countryItems,
                            onCountryChanged: (item) {},
                            borderRadius: 37.5,
                            height: screenHeight * 0.06,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                        ],
                      );
                    }
                    if (index == 3 || index == 4) {
                      _isPasswordVisible = true;
                    } else {
                      _isPasswordVisible = false;
                    }
                    return Column(
                      children: [
                        customTextField(
                          onChanged: (value) {
                            if (index == 0) username = value;
                            if (index == 1) email = value;
                            if (index == 3) password = value;
                            if (index == 4) confirmPassword = value;
                            if (index == 5) address = value;

                            if (_controllers.every((controller) =>
                                    controller.text.isNotEmpty) &&
                                _controllers[3].text == _controllers[4].text &&
                                _isSelected[0]) {
                              setState(() {
                                _bottomEnabled = true;
                              });
                            } else {
                              setState(() {
                                _bottomEnabled = false;
                              });
                            }
                            if (_controllers[3].text != _controllers[4].text) {
                              setState(() {
                                _passwordsMatch = 'Passwords do not match';
                              });
                            } else {
                              setState(() {
                                _passwordsMatch = null;
                              });
                            }
                          },
                          obscureText: _isPasswordVisible,
                          controller: _controllers[index],
                          height: screenHeight * 0.06,
                          hintText: _textFields[index],
                        ),
                        index == 4 && _passwordsMatch != null
                            ? Column(
                                children: [
                                  SizedBox(height: screenHeight * 0.005),
                                  SizedBox(
                                    height: screenHeight * 0.025,
                                    child: Row(
                                      children: [
                                        SizedBox(width: screenWidth * 0.03),
                                        Text(
                                          _passwordsMatch!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(height: screenHeight * 0.01234),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.00288625592,
                ),
                // Upload logo field
                Center(
                  child: Column(
                    children: [
                      _logoImage != null
                          ? Text(
                              pictureName,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text('No logo selected'),
                      ElevatedButton(
                        onPressed: _pickLogoImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          fixedSize: Size(screenWidth * 0.58717948717,
                              screenWidth * 0.05450236966),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(37.5),
                          ),
                        ),
                        child: const Text('Upload Logo'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02554502369),
                SizedBox(
                  height: screenHeight * 0.03554502369,
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isSelected[0],
                        onChanged: (_) {
                          setState(() {
                            _isSelected[0] = !_isSelected[0];
                          });
                          if (_controllers.every(
                                  (controller) => controller.text.isNotEmpty) &&
                              _controllers[3].text == _controllers[4].text &&
                              _isSelected[0]) {
                            setState(() {
                              _bottomEnabled = true;
                            });
                          } else {
                            setState(() {
                              _bottomEnabled = false;
                            });
                          }
                        },
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
                  height: screenHeight * 0.00229383886,
                ),
                SizedBox(
                  height: screenHeight * 0.02843601895,
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isSelected[1],
                        onChanged: (_) {
                          setState(() {
                            _isSelected[1] = !_isSelected[1];
                          });
                        },
                      ),
                      const Text(
                        'Email me new updates',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: _bottomEnabled == true
                    ? () async {
                        try {
                          // Add your sign-up logic here
                          Get.snackbar(
                            'Check your email',
                            'Verification email sent',
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.green[900],
                            backgroundColor: Colors.white,
                            barBlur: 0.5,
                            duration: 5000.milliseconds,
                            icon: Icon(Icons.check, color: Colors.green[900]),
                          );
                          Get.offNamed(homeRoute);
                        } on Exception catch (e) {
                          Get.snackbar(
                            'Error',
                            e.toString(),
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.red,
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  fixedSize: Size(screenWidth * 0.58717948717,
                      screenWidth * 0.05450236966),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(37.5),
                  ),
                ),
                child: const Text('Sign Up'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(fontSize: 14),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
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
      ),
    );
  }
}