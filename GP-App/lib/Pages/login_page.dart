import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/dialogs/register_dialog.dart';
import 'package:rates/dialogs/signup_options.dart';
import 'package:rates/dialogs/verification_dialog.dart';
import 'package:rates/pages/register_page.dart';
import 'package:rates/services/temp_logo.dart';
import 'dart:developer' as devtools show log;
import 'package:rates/services/text_width_fun.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified != true) {
        devtools.log('${FirebaseAuth.instance.currentUser!.emailVerified}');
        if (mounted) {
          showVerificationDialog(context);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String noAccountMessage = 'don\'t have an account? Register';
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Horizontal_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: AspectRatios.height * 0.2),
              child: Column(
                children: [
                  const RatesLogo(),
                  SizedBox(height: AspectRatios.height * 0.05),
                  Center(
                    child: SizedBox(
                      width: AspectRatios.width * 0.8,
                      height: AspectRatios.height * 0.6,
                      child: LayoutBuilder(builder: (context, constraints) {
                        Text loginText = const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                        TextPainter textPainter = TextPainter(
                          text: TextSpan(
                              text: loginText.data, style: loginText.style),
                          textDirection: TextDirection.ltr,
                        )..layout();
                        double textWidth = textPainter.width;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              width: constraints.maxHeight,
                              height: constraints.maxHeight,
                              padding: EdgeInsets.only(
                                left: AspectRatios.width * 0.05,
                                right: AspectRatios.width * 0.05,
                                top: AspectRatios.height * 0.03,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                      0,
                                      3,
                                    ), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: constraints.maxHeight * 0.01,
                                      left: (constraints.maxWidth * 0.5) -
                                          (textWidth / 2) -
                                          AspectRatios.width * 0.05,
                                      child: loginText),
                                  //this is the LinearGradiented container next to the email textfield
                                  Positioned(
                                    top: constraints.maxHeight * 0.15,
                                    left: constraints.maxWidth * 0.15,
                                    child: Container(
                                      width: constraints.maxWidth * 0.7,
                                      height: constraints.maxHeight * 0.1,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.centerLeft,
                                          colors: [
                                            Color.fromARGB(150, 244, 143,
                                                66), // Warm orange
                                            Color.fromARGB(100, 191, 90,
                                                48), // Darker orange
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  //this is the email textfield and its container with a gradient
                                  Positioned(
                                    top: constraints.maxHeight * 0.15,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: constraints.maxWidth * 0.75,
                                          height: constraints.maxHeight * 0.1,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              transform: GradientRotation(0.5),
                                              begin: Alignment.centerRight,
                                              end: Alignment.centerLeft,
                                              colors: [
                                                Color.fromARGB(200, 255, 255,
                                                    230), // Light yellow hint
                                                Color.fromARGB(255, 255, 234,
                                                    200), // Pale orange
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextField(
                                            enableSuggestions: false,
                                            controller: _email,
                                            autocorrect: false,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              hintText: 'Email',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide
                                                    .none, // Remove border to fit gradient
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: constraints
                                                        .maxHeight *
                                                    0.03, // Adjust padding as needed
                                                horizontal:
                                                    constraints.maxWidth * 0.03,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //this is the LinearGradiented container next to the password textfield
                                  Positioned(
                                    top: constraints.maxHeight * 0.3,
                                    left: constraints.maxWidth * 0.15,
                                    child: Container(
                                      width: constraints.maxWidth * 0.7,
                                      height: constraints.maxHeight * 0.1,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.centerLeft,
                                          colors: [
                                            Color.fromARGB(150, 244, 143,
                                                66), // Warm orange
                                            Color.fromARGB(100, 191, 90,
                                                48), // Darker orange
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  //this is the password textfield and its container with a gradient
                                  Positioned(
                                    top: constraints.maxHeight * 0.3,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: constraints.maxWidth * 0.75,
                                          height: constraints.maxHeight * 0.1,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              transform: GradientRotation(0.5),
                                              begin: Alignment.centerRight,
                                              end: Alignment.centerLeft,
                                              colors: [
                                                Color.fromARGB(200, 255, 255,
                                                    230), // Light yellow hint
                                                Color.fromARGB(255, 255, 234,
                                                    200), // Pale orange
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextField(
                                            enableSuggestions: false,
                                            obscureText: true,
                                            autocorrect: false,
                                            controller: _password,
                                            decoration: InputDecoration(
                                              hintText: 'Password',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide
                                                    .none, // Removes the default border to fit gradient
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: constraints
                                                        .maxHeight *
                                                    0.03, // Adjust padding as needed
                                                horizontal:
                                                    constraints.maxWidth * 0.03,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Positioned(
                                    top: constraints.maxHeight * 0.425,
                                    left: constraints.maxWidth * 0.02,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: const Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 230),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //this is the login button
                                  Positioned(
                                    top: constraints.maxHeight * 0.5,
                                    left: (constraints.maxWidth * 0.5) -
                                        constraints.maxWidth * 0.5 / 2 -
                                        AspectRatios.width * 0.05,
                                    child: SizedBox(
                                      width: constraints.maxWidth * 0.5,
                                      child: TextButton(
                                        onPressed: () async {
                                          final email = _email.text;
                                          final password = _password.text;
                                          try {
                                            await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                              email: email,
                                              password: password,
                                            );
                                            final user = FirebaseAuth
                                                .instance.currentUser;
                                            if (user == null) return;
                                            if (!user.emailVerified) {
                                              if (mounted) {
                                                showVerificationDialog(context);
                                              }
                                              return;
                                            }
                                            if (mounted) {
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      homeRoute,
                                                      (route) => false);
                                            }
                                          } on FirebaseAuthException catch (e) {
                                            if (e.code ==
                                                'invalid-credential') {
                                              devtools.log('user not found');
                                            } else {
                                              devtools.log(
                                                  'something went wrong\n ${e.code}');
                                            }
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              150,
                                              244,
                                              143,
                                              66), // Orange button
                                        ),
                                        child: const Text('Login',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: constraints.maxHeight * 0.65,
                                    left: (constraints.maxWidth * 0.5) -
                                        constraints.maxWidth * 0.75 / 2 -
                                        AspectRatios.width * 0.05,
                                    child: SizedBox(
                                      width: constraints.maxWidth * 0.75,
                                      height: constraints.maxHeight * 0.1,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(),
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Image.asset(
                                                  'assets/images/google_logo.png',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              ),
                                              const Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                      'Login with Google')),
                                            ],
                                          )),
                                    ),
                                  ),
                                  Positioned(
                                    top: constraints.maxHeight * 0.75,
                                    left: (constraints.maxWidth * 0.5) -
                                        measureTextWidth(noAccountMessage) / 2 -
                                        AspectRatios.width * 0.05,
                                    child: SizedBox(
                                      height: constraints.maxHeight * 0.15,
                                      child: Row(
                                        children: [
                                          Text(noAccountMessage
                                              .split('Register')[0]),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: SizedBox(
                                                        width:
                                                            AspectRatios.width *
                                                                0.8,
                                                        height: AspectRatios
                                                                .height *
                                                            0.7,
                                                        child: RegisterPage(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Text(
                                              noAccountMessage.split('? ')[1],
                                              style: const TextStyle(
                                                  color: Color.fromARGB(255, 0,
                                                      130, 0)), // Green link
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
