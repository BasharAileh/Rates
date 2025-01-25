import 'dart:io';

import 'package:admin/services/cloud/cloud_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin/constants/app_colors.dart';
import 'package:admin/constants/widgets.dart';
import 'package:admin/pages/registration/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

List<String> _textFields = [
  'Shop Name',
  'Email',
  'Phone Number',
  'Shop Category',
  'Available On',
  'Google Maps Link',
  'Available Hours',
  'Password',
  'Confirm Password',
];

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  late final List<TextEditingController> _controllers;
  late List<bool> _isSelected;
  bool _bottomEnabled = false;
  String? _passwordsMatch;
  bool _isPasswordVisible = false;
  File? _logoImage;

  String selectedCountryCode = '00962';
  String username = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
  String confirmPassword = '';
  String address = '';
  String pictureUrl = '';
  String pictureName = '';

  final List<DropdownMenuItem<String>> _availableOn = [
    const DropdownMenuItem(
      value: 'Talabat',
      child: Text('Talabat'),
    ),
    const DropdownMenuItem(
      value: 'Careem',
      child: Text('Careem'),
    ),
  ];

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
    _controllers =
        List.generate(_textFields.length, (_) => TextEditingController());
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
      _logoImage = File(image!.path);
      pictureName = image.name;
    });
  }

  String value1 = '09:00';
  String value2 = '17:00';

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.06,
          right: screenWidth * 0.06,
          top: screenHeight * 0.06,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('pending')
                          .add(
                        {
                          'username': username,
                          'email': email,
                          'phoneNumber': phoneNumber,
                          'password': password,
                          'confirmPassword': confirmPassword,
                          'address': address,
                          'pictureUrl': pictureUrl,
                          'pictureName': pictureName,
                          'selectedCountryCode': selectedCountryCode,
                        },
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(
                    'Become a part of Rates',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Text fields
                SizedBox(
                  height: screenHeight * 0.45,
                  child: Scrollbar(
                    scrollbarOrientation: ScrollbarOrientation.right,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          children: [
                            //TODO : Add shop location field
                            ...List.generate(
                              _textFields.length,
                              (index) {
                                if (_textFields[index] == 'Phone Number') {
                                  return Column(
                                    children: [
                                      phoneNumberTextField(
                                        onTextfieldChanged: (value) {
                                          phoneNumber = value;
                                          /* if (_controllers.every((controller) =>
                                              controller.text.isNotEmpty)) {
                                            if (_textFields[index] ==
                                                    'password' &&
                                                _controllers[index].text ==
                                                    _controllers[index + 1]
                                                        .text) {
                                              setState(() {
                                                _bottomEnabled = true;
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              _bottomEnabled = false;
                                            });
                                          } */
                                        },
                                        hintText: _textFields[index],
                                        phoneController: _controllers[index],
                                        initialCountryCode: '00962',
                                        countryItems: countryItems,
                                        onCountryChanged: (item) {
                                          selectedCountryCode = item!;
                                        },
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

                                if (_textFields[index] == 'Shop Category') {
                                  return Column(
                                    children: [
                                      DropdownButtonFormField(
                                        dropdownColor: Colors.white,
                                        decoration: InputDecoration(
                                          hintText: _textFields[index],
                                          hintStyle: const TextStyle(
                                            fontSize: 14,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(37.5),
                                          ),
                                        ),
                                        items: _shopCategorys,
                                        onChanged: (value) {
                                          setState(() {
                                            _controllers[index].text = value!;
                                          });
                                        },
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                    ],
                                  );
                                }

                                if (_textFields[index] == 'Available Hours') {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: screenHeight * 0.05,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'From',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            DropdownButton<String>(
                                              iconEnabledColor: Colors.black,
                                              value: value1,
                                              dropdownColor: Colors.white,
                                              items: _availableHours
                                                  .map<
                                                      DropdownMenuItem<
                                                          String>>((hour) =>
                                                      DropdownMenuItem<String>(
                                                        value: hour.value,
                                                        child: Text(hour.value
                                                            as String),
                                                      ))
                                                  .toList(),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  value1 = value!;
                                                  _controllers[index].text =
                                                      '$value1 - $value2';
                                                });
                                              },
                                            ),
                                            const SizedBox(width: 20),
                                            const Text(
                                              'To',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            DropdownButton<String>(
                                              iconEnabledColor: Colors.black,
                                              value: value2,
                                              dropdownColor: Colors.white,
                                              items: _availableHours
                                                  .map<
                                                      DropdownMenuItem<
                                                          String>>((hour) =>
                                                      DropdownMenuItem<String>(
                                                        value: hour.value,
                                                        child: Text(hour.value
                                                            as String),
                                                      ))
                                                  .toList(),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  value2 = value!;
                                                  _controllers[index].text =
                                                      '$value1 - $value2';
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                    ],
                                  );
                                }
                                if (_textFields[index] == 'Available On') {
                                  return Column(
                                    children: [
                                      DropdownButtonFormField(
                                        dropdownColor: Colors.white,
                                        decoration: InputDecoration(
                                          hintText: _textFields[index],
                                          hintStyle: const TextStyle(
                                            fontSize: 14,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(37.5),
                                          ),
                                        ),
                                        items: _availableOn,
                                        onChanged: (value) {
                                          setState(() {
                                            _controllers[index].text = value!;
                                          });
                                        },
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                    ],
                                  );
                                }
                                return Column(
                                  children: [
                                    customTextField(
                                      onChanged: (value) {
                                        _controllers[index].text = value;
                                        /* if (_controllers.every((controller) =>
                                            controller.text.isNotEmpty)) {
                                          if (_textFields[index] ==
                                                  'password' &&
                                              _controllers[index].text ==
                                                  _controllers[index + 1]
                                                      .text) {
                                            setState(() {
                                              _bottomEnabled = true;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            _bottomEnabled = false;
                                          });
                                        } */
                                        if (_controllers[3].text !=
                                            _controllers[4].text) {
                                          setState(() {
                                            _passwordsMatch =
                                                'Passwords do not match';
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
                                              SizedBox(
                                                  height: screenHeight * 0.005),
                                              SizedBox(
                                                height: screenHeight * 0.025,
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                        width:
                                                            screenWidth * 0.03),
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
                                        : SizedBox(
                                            height: screenHeight * 0.01234),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.0188625592,
                ),
                const Divider(
                  thickness: 3,
                ),
                SizedBox(
                  height: screenHeight * 0.0188625592,
                ),
                // Upload logo field
                Center(
                  child: Column(
                    children: [
                      _logoImage != null
                          ? Text(
                              pictureName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text('No logo selected'),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            // Pick the image first
                            await _pickLogoImage();
                          } catch (e) {
                            // Handle any errors during the process
                            print('Error during image upload: $e');
                          }
                        },
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
                          /* if (_controllers.every(
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
                          } */
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
                onPressed: () async {
                  try {
                    Map<String, dynamic> shopData = {};
                    _controllers.forEach((controller) {
                      if (controller.text.isNotEmpty) {
                        if (_textFields[_controllers.indexOf(controller)] ==
                            'Phone Number') {
                          shopData['Phone Number'] =
                              '$selectedCountryCode ${controller.text}';
                        } else {
                          shopData[
                                  '${_textFields[_controllers.indexOf(controller)]}'] =
                              controller.text;
                        }
                      }
                    });

                    if (_logoImage != null && shopData.isNotEmpty) {
                      String shopName = 'unDefined';
                      CloudService cloudService = CloudService();

                      for (var field in _textFields) {
                        if (field == 'Shop Name') {
                          shopName =
                              _controllers[_textFields.indexOf(field)].text;
                        }
                      }

                      String imagePath = await cloudService.uploadPendingImage(
                        File(_logoImage!.path),
                        shopName,
                      );
                      shopData['image_path'] = imagePath;

                      cloudService.uploadUserDetails(
                          shopData['Shop Name'], shopData);
                    } else {
                      print('No image selected.');
                    }
                  } on Exception catch (e) {
                    print('Error during image upload: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  fixedSize: Size(
                      screenWidth * 0.58717948717, screenWidth * 0.05450236966),
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
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
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

  final List<DropdownMenuItem<String>> _shopCategorys = [
    const DropdownMenuItem(
      value: 'Food',
      child: Text('Food'),
    ),
    const DropdownMenuItem(
      value: 'Clothing',
      child: Text('Clothing'),
    ),
    const DropdownMenuItem(
      value: 'Electronics',
      child: Text('Electronics'),
    ),
    const DropdownMenuItem(
      value: 'Furniture',
      child: Text('Furniture'),
    ),
    const DropdownMenuItem(
      value: 'Books',
      child: Text('Books'),
    ),
  ];

  final List<DropdownMenuItem<String>> _availableHours = [
    const DropdownMenuItem(
      value: '00:00',
      child: Text('00:00'),
    ),
    const DropdownMenuItem(
      value: '01:00',
      child: Text('01:00'),
    ),
    const DropdownMenuItem(
      value: '02:00',
      child: Text('02:00'),
    ),
    const DropdownMenuItem(
      value: '03:00',
      child: Text('03:00'),
    ),
    const DropdownMenuItem(
      value: '04:00',
      child: Text('04:00'),
    ),
    const DropdownMenuItem(
      value: '05:00',
      child: Text('05:00'),
    ),
    const DropdownMenuItem(
      value: '06:00',
      child: Text('06:00'),
    ),
    const DropdownMenuItem(
      value: '07:00',
      child: Text('07:00'),
    ),
    const DropdownMenuItem(
      value: '08:00',
      child: Text('08:00'),
    ),
    const DropdownMenuItem(
      value: '09:00',
      child: Text('09:00'),
    ),
    const DropdownMenuItem(
      value: '10:00',
      child: Text('10:00'),
    ),
    const DropdownMenuItem(
      value: '11:00',
      child: Text('11:00'),
    ),
    const DropdownMenuItem(
      value: '12:00',
      child: Text('12:00'),
    ),
    const DropdownMenuItem(
      value: '13:00',
      child: Text('13:00'),
    ),
    const DropdownMenuItem(
      value: '14:00',
      child: Text('14:00'),
    ),
    const DropdownMenuItem(
      value: '15:00',
      child: Text('15:00'),
    ),
    const DropdownMenuItem(
      value: '16:00',
      child: Text('16:00'),
    ),
    const DropdownMenuItem(
      value: '17:00',
      child: Text('17:00'),
    ),
    const DropdownMenuItem(
      value: '18:00',
      child: Text('18:00'),
    ),
    const DropdownMenuItem(
      value: '19:00',
      child: Text('19:00'),
    ),
    const DropdownMenuItem(
      value: '20:00',
      child: Text('20:00'),
    ),
    const DropdownMenuItem(
      value: '21:00',
      child: Text('21:00'),
    ),
    const DropdownMenuItem(
      value: '22:00',
      child: Text('22:00'),
    ),
    const DropdownMenuItem(
      value: '23:00',
      child: Text('23:00'),
    ),
  ];
}
