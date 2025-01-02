import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rates/constants/decorations.dart';
import 'package:rates/dialogs/error_dialog.dart';

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({super.key});

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
//controllers
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password1;
  late final TextEditingController _password2;
  String _passwordError = '';

  @override
  void initState() {
    _username = TextEditingController();
    _email = TextEditingController();
    _password1 = TextEditingController();
    _password2 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password1.dispose();
    _password2.dispose();
    super.dispose();
  }

  bool _isTermsChecked = false;
  bool _isNewsletterChecked = false;
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(
              image: AssetImage('assets/images/Horizontal_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width *
                                0.08, // Responsive font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: constraints.maxHeight *
                              0.02), // Responsive spacing
                      Container(
                        decoration: Constants.textFieldContainerBoxDecoration(),
                        child: TextField(
                          controller: _username,
                          decoration: Constants.textFieldDecoration(
                              labelText: 'Username'),
                          onChanged: (value) {
                            if (_passwordError == '' &&
                                _username.text.isNotEmpty &&
                                _email.text.isNotEmpty &&
                                _password1.text.isNotEmpty &&
                                _password2.text.isNotEmpty &&
                                _isTermsChecked) {
                              setState(() {
                                enabled = true;
                              });
                            } else {
                              setState(() {
                                enabled = false;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      Container(
                        decoration: Constants.textFieldContainerBoxDecoration(),
                        child: TextField(
                          controller: _email,
                          decoration:
                              Constants.textFieldDecoration(labelText: 'Email'),
                          onChanged: (value) {
                            if (_passwordError == '' &&
                                _username.text.isNotEmpty &&
                                _email.text.isNotEmpty &&
                                _password1.text.isNotEmpty &&
                                _password2.text.isNotEmpty &&
                                _isTermsChecked) {
                              setState(() {
                                enabled = true;
                              });
                            } else {
                              setState(() {
                                enabled = false;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      Container(
                        decoration: Constants.textFieldContainerBoxDecoration(),
                        child: TextField(
                          controller: _password1,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          onChanged: (value) {
                            if (_password2.text.isNotEmpty &&
                                _password2.text != value) {
                              setState(() {
                                _passwordError = 'Passwords do not match';
                                enabled = false;
                              });
                            } else {
                              setState(() {
                                _passwordError = '';
                                if (_isTermsChecked &&
                                    _username.text.isNotEmpty &&
                                    _email.text.isNotEmpty &&
                                    _password2.text.isNotEmpty) {
                                  enabled = true;
                                }
                              });
                            }
                          },
                          decoration: Constants.textFieldDecoration(
                              labelText: 'Password'),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.75),
                        ),
                        child: TextField(
                          controller: _password2,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          onChanged: (value) {
                            if (_password1.text != value) {
                              setState(() {
                                _passwordError = 'Passwords do not match';
                                enabled = false;
                              });
                            } else {
                              setState(() {
                                _passwordError = '';
                                if (_isTermsChecked &&
                                    _email.text.isNotEmpty &&
                                    _password1.text.isNotEmpty) {
                                  enabled = true;
                                }
                              });
                            }
                          },
                          decoration: Constants.textFieldDecoration(
                              labelText: 'Confirm Password'),
                        ),
                      ),
                      if (_passwordError.isNotEmpty)
                        Text(
                          _passwordError,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      _buildCheckboxRow('I agree to the terms and conditions',
                          _isTermsChecked, (value) {
                        setState(() {
                          _isTermsChecked = value!;
                          if (_isTermsChecked &&
                              _username.text.isNotEmpty &&
                              _email.text.isNotEmpty &&
                              _password1.text.isNotEmpty &&
                              _password2.text.isNotEmpty) {
                            enabled = true;
                          } else {
                            enabled = false;
                          }
                        });
                      }),
                      _buildCheckboxRow(
                          'I would like to receive the newsletter',
                          _isNewsletterChecked, (value) {
                        setState(() {
                          _isNewsletterChecked = value!;
                        });
                      }),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: enabled == false
                                  ? null
                                  : () {
                                      try {
                                        if (context.mounted) {
                                          Navigator.of(context).pop(
                                            {
                                              'register': true,
                                              'email': _email,
                                              'password': _password1,
                                            },
                                          );
                                        }
                                      } catch (e) {
                                        showErrorDialog(context, e.toString());
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    150, 244, 143, 66), // Orange button
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 30,
                                ),
                              ),
                              child: const Text('Register'),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account?'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Login'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Method to build checkbox rows
Widget _buildCheckboxRow(
    String label, bool value, ValueChanged<bool?> onChanged) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Checkbox(
        value: value,
        onChanged: onChanged,
      ),
      Text(
        label,
        style: const TextStyle(
          fontSize: 12.0,
        ),
      ),
    ],
  );
}
