import 'dart:developer' as devtools show log;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/dialogs/error_dialog.dart';
import 'package:rates/dialogs/register_dialog.dart';
import 'package:rates/dialogs/verification_dialog.dart';
import 'package:rates/services/auth/auth_exception.dart';
import 'package:rates/services/auth/auth_service.dart';
import 'package:rates/services/firebase%20methods/register_method.dart';
import 'package:rates/services/temp_logo.dart';
import 'package:rates/services/text_width_fun.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool enabled = false;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (AuthService.firebase().currentUser != null &&
          AuthService.firebase().currentUser?.isEmailVerified != true) {
        devtools.log('${AuthService.firebase().currentUser}');
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
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String noAccountMessage = 'don\'t have an account? Register';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Horizontal_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(top: AspectRatios.height * 0.2),
                      child: Column(
                        children: [
                          const RatesLogo(),
                          SizedBox(height: AspectRatios.height * 0.05),
                          Center(
                            child: SizedBox(
                              width: AspectRatios.width * 0.8,
                              height: AspectRatios.height * 0.6,
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                Text loginText = const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                                TextPainter textPainter = TextPainter(
                                  text: TextSpan(
                                      text: loginText.data,
                                      style: loginText.style),
                                  textDirection: TextDirection.ltr,
                                )..layout();
                                double textWidth = textPainter.width;
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 5, sigmaY: 5),
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
                                        borderRadius:
                                            BorderRadius.circular(15.0),
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
                                              left:
                                                  (constraints.maxWidth * 0.5) -
                                                      (textWidth / 2) -
                                                      AspectRatios.width * 0.05,
                                              child: loginText),
                                          //this is the LinearGradiented container next to the email textfield
                                          Positioned(
                                            top: constraints.maxHeight * 0.15,
                                            left: constraints.maxWidth * 0.15,
                                            child: Container(
                                              width: constraints.maxWidth * 0.7,
                                              height:
                                                  constraints.maxHeight * 0.1,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.centerLeft,
                                                  colors: [
                                                    Color.fromARGB(150, 244,
                                                        143, 66), // Warm orange
                                                    Color.fromARGB(100, 191, 90,
                                                        48), // Darker orange
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          //this is the email textfield and its container with a gradient
                                          Positioned(
                                            top: constraints.maxHeight * 0.15,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: constraints.maxWidth *
                                                      0.75,
                                                  height:
                                                      constraints.maxHeight *
                                                          0.1,
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      transform:
                                                          GradientRotation(0.5),
                                                      begin:
                                                          Alignment.centerRight,
                                                      end: Alignment.centerLeft,
                                                      colors: [
                                                        Color.fromARGB(
                                                            200,
                                                            255,
                                                            255,
                                                            230), // Light yellow hint
                                                        Color.fromARGB(
                                                            255,
                                                            255,
                                                            234,
                                                            200), // Pale orange
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: TextField(
                                                    enableSuggestions: false,
                                                    controller: _email,
                                                    focusNode: _emailFocusNode,
                                                    autocorrect: false,
                                                    onChanged: (value) {
                                                      if (value.isNotEmpty &&
                                                          _password.text
                                                              .isNotEmpty) {
                                                        setState(() {
                                                          enabled = true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          enabled = false;
                                                        });
                                                      }
                                                    },
                                                    onSubmitted: (_) {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              _passwordFocusNode);
                                                    },
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    decoration: InputDecoration(
                                                      hintText: 'Email',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide: BorderSide
                                                            .none, // Remove border to fit gradient
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                        vertical: constraints
                                                                .maxHeight *
                                                            0.03, // Adjust padding as needed
                                                        horizontal: constraints
                                                                .maxWidth *
                                                            0.03,
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
                                              height:
                                                  constraints.maxHeight * 0.1,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.centerLeft,
                                                  colors: [
                                                    Color.fromARGB(150, 244,
                                                        143, 66), // Warm orange
                                                    Color.fromARGB(100, 191, 90,
                                                        48), // Darker orange
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          //this is the password textfield and its container with a gradient
                                          Positioned(
                                            top: constraints.maxHeight * 0.3,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: constraints.maxWidth *
                                                      0.75,
                                                  height:
                                                      constraints.maxHeight *
                                                          0.1,
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      transform:
                                                          GradientRotation(0.5),
                                                      begin:
                                                          Alignment.centerRight,
                                                      end: Alignment.centerLeft,
                                                      colors: [
                                                        Color.fromARGB(
                                                            200,
                                                            255,
                                                            255,
                                                            230), // Light yellow hint
                                                        Color.fromARGB(
                                                            255,
                                                            255,
                                                            234,
                                                            200), // Pale orange
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: TextField(
                                                    enableSuggestions: false,
                                                    obscureText: true,
                                                    autocorrect: false,
                                                    controller: _password,
                                                    focusNode:
                                                        _passwordFocusNode,
                                                    onChanged: (value) {
                                                      if (value.isNotEmpty &&
                                                          _email.text
                                                              .isNotEmpty) {
                                                        setState(() {
                                                          enabled = true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          enabled = false;
                                                        });
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Password',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide: BorderSide
                                                            .none, // Removes the default border to fit gradient
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                        vertical: constraints
                                                                .maxHeight *
                                                            0.03, // Adjust padding as needed
                                                        horizontal: constraints
                                                                .maxWidth *
                                                            0.03,
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
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 230),
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
                                                onPressed: enabled == false
                                                    ? null
                                                    : () async {
                                                        final email =
                                                            _email.text;
                                                        final password =
                                                            _password.text;
                                                        try {
                                                          await AuthService
                                                                  .firebase()
                                                              .logIn(
                                                            email: email,
                                                            password: password,
                                                          );
                                                          final user =
                                                              AuthService
                                                                      .firebase()
                                                                  .currentUser;
                                                          if (user != null) {
                                                            if (!user
                                                                .isEmailVerified) {
                                                              if (mounted) {
                                                                showVerificationDialog(
                                                                    context.mounted
                                                                        ? context
                                                                        : context);
                                                              }
                                                              return;
                                                            } else {
                                                              Navigator.of(context
                                                                          .mounted
                                                                      ? context
                                                                      : context)
                                                                  .pushNamedAndRemoveUntil(
                                                                      homeRoute,
                                                                      (route) =>
                                                                          false);
                                                            }
                                                          }
                                                        } on InvalidEmailAuthException {
                                                          await showErrorDialog(
                                                              context.mounted
                                                                  ? context
                                                                  : context,
                                                              'The email address is badly formatted');
                                                        } on InvalidCredentialAuthException {
                                                          await showErrorDialog(
                                                              context.mounted
                                                                  ? context
                                                                  : context,
                                                              'User not found');
                                                        } on GenericAuthException {
                                                          await showErrorDialog(
                                                              context.mounted
                                                                  ? context
                                                                  : context,
                                                              'An error occurred');
                                                        }
                                                      },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: enabled ==
                                                          false
                                                      ? Colors.grey
                                                          .withOpacity(0.5)
                                                      : const Color.fromARGB(
                                                          150,
                                                          244,
                                                          143,
                                                          66), // Orange button
                                                ),
                                                child: const Text('Login',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: constraints.maxHeight * 0.65,
                                            left: (constraints.maxWidth * 0.5) -
                                                constraints.maxWidth *
                                                    0.75 /
                                                    2 -
                                                AspectRatios.width * 0.05,
                                            child: SizedBox(
                                              width:
                                                  constraints.maxWidth * 0.75,
                                              height:
                                                  constraints.maxHeight * 0.1,
                                              child: ElevatedButton(
                                                  style: ElevatedButton
                                                      .styleFrom(),
                                                  onPressed: () async {
                                                    try {
                                                      await AuthService.google()
                                                          .logIn();
                                                      Navigator.of(
                                                              context.mounted
                                                                  ? context
                                                                  : context)
                                                          .pushNamedAndRemoveUntil(
                                                              homeRoute,
                                                              (route) => false);
                                                    } catch (e) {
                                                      devtools
                                                          .log(e.toString());
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                measureTextWidth(
                                                        noAccountMessage) /
                                                    2 -
                                                AspectRatios.width * 0.05,
                                            child: SizedBox(
                                              height:
                                                  constraints.maxHeight * 0.15,
                                              child: Row(
                                                children: [
                                                  Text(noAccountMessage
                                                      .split('Register')[0]),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      Map results =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              child:
                                                                  const RegisterDialog());
                                                        },
                                                      );
                                                      if (results['register'] ==
                                                          true) {
                                                        if (context.mounted) {
                                                          await register(
                                                              context,
                                                              results['email'],
                                                              results[
                                                                  'password']);
                                                          setState(() {});
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                      noAccountMessage
                                                          .split('? ')[1],
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              0,
                                                              130,
                                                              0)), // Green link
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
                  ),
                ],
              ),
            ),
            Positioned(
              top: AspectRatios.height * 0.05,
              right: AspectRatios.width * 0.05,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    AuthService.firebase().logInAnonymously();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      Text(
                        'Guest',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
