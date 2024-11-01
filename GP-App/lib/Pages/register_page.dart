import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:developer' as devtools show log;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  String? _selectedGender;
  bool _isTermsChecked = false;
  bool _isNewsletterChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.1,
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.1,
                  child: TextField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.1,
                  child: TextField(
                    controller: _password1,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.2,
                  child: TextField(
                    onChanged: (value) {
                      if (_password1.text != value) {
                        setState(() {
                          _passwordError = 'Passwords do not match';
                        });
                      }
                    },
                    controller: _password2,
                    decoration: InputDecoration(
                      helperText: _passwordError,
                      labelText: 'Confirm Password',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -constraints.maxHeight * 0.065),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.165,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _isTermsChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isTermsChecked = value!;
                                });
                              },
                            ),
                            const Text(
                              'I agree to the terms and conditions',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        Transform.translate(
                          offset: Offset(0, -constraints.maxHeight * 0.025),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: _isNewsletterChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isNewsletterChecked = value!;
                                  });
                                },
                              ),
                              const Text(
                                'I would like to receive the newsletter',
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -constraints.maxHeight * 0.085),
                  child: Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final email = _email.text;

                            if (_password1.text == _password2.text) {
                              final password = _password1.text;
                              try {
                                devtools
                                    .log('Creating user with email: $email');
                                devtools.log(
                                    'Creating user with password: $password');
                                final userCredential = await FirebaseAuth
                                    .instance
                                    .createUserWithEmailAndPassword(
                                        email: email, password: password);
                                devtools.log(userCredential.user.toString());
                              } on FirebaseAuthException catch (e) {
                                // ignore: avoid_devtools.log
                                if (e.code == 'weak-password') {
                                  setState(() {
                                    _passwordError =
                                        'The password provided is too weak.';
                                  });
                                } else if (e.code == 'email-already-in-use') {
                                  devtools.log(
                                      'The account already exists for that email.');
                                } else if (e.code == 'invalid-email') {
                                  devtools.log(
                                      'The email address is badly formatted.');
                                }
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          child: const Text('Register'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Already have an account? Login',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
