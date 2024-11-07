import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter/services.dart';

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({super.key});

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  //register method
  Future<void> register(
    TextEditingController gEmail,
    TextEditingController password1,
    TextEditingController password2,
  ) async {
    final email = gEmail.text;

    if (password1.text == password2.text) {
      final password = password1.text;
      try {
        devtools.log('Creating user with email: $email');
        devtools.log('Creating user with password: $password');
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await userCredential.user!.sendEmailVerification();
        devtools.log(userCredential.user.toString());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          setState(() {
            _passwordError = 'The password provided is too weak.';
          });
        } else if (e.code == 'email-already-in-use') {
          devtools.log('The account already exists for that email.');
        } else if (e.code == 'invalid-email') {
          devtools.log('The email address is badly formatted.');
        }
        Navigator.of(context).pop();
      }
    }
  }

//controllers
  late final TextEditingController _email;
  late final TextEditingController _password1;
  late final TextEditingController _password2;
  String _passwordError = '';

  @override
  void initState() {
    _email = TextEditingController();
    _password1 = TextEditingController();
    _password2 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password1.dispose();
    _password2.dispose();
    super.dispose();
  }

  bool _isTermsChecked = false;
  bool _isNewsletterChecked = false;

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
                      _buildTextField('First Name', false),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      _buildTextField('Email', false, _email),
                      SizedBox(height: constraints.maxHeight * 0.02),
                      _buildTextField('Password', true, _password1),
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
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.transparent,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
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
                              onPressed: () => {},
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

// Method to build a text field
Widget _buildTextField(String labelText, bool isPassword,
    [TextEditingController? controller]) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white.withOpacity(0.75),
    ),
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
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
