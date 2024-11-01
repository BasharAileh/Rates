import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/pages/register_page.dart';
import 'dart:developer' as devtools show log;
import 'package:rates/pages/temp_logo.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: AspectRatios.height * 0.2),
            child: Column(
              children: [
                RatesLogo(),
                SizedBox(height: AspectRatios.height * 0.13),
                Center(
                  child: Container(
                    width: AspectRatios.width * 0.9,
                    height: AspectRatios.height * 0.4,
                    child: LayoutBuilder(builder: (context, constraints) {
                      /* String loginText = "Login";
                      TextStyle style = const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      );
                       */
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
                      return Container(
                        width: constraints.maxHeight,
                        height: constraints.maxHeight,
                        padding: EdgeInsets.only(
                          left: AspectRatios.width * 0.05,
                          right: AspectRatios.width * 0.05,
                          top: AspectRatios.height * 0.03,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
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
                                top: constraints.maxHeight * 0.05,
                                left: (constraints.maxWidth * 0.5) -
                                    (textWidth / 2) -
                                    AspectRatios.width * 0.05,
                                child: loginText),
                            Positioned(
                              top: constraints.maxHeight * 0.2,
                              left: constraints.maxWidth * 0.15,
                              child: Container(
                                width: constraints.maxWidth * 0.7,
                                height: constraints.maxHeight * 0.125,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      Color.fromARGB(150, 122, 178, 211),
                                      Color.fromARGB(100, 74, 98, 138),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Positioned(
                              top: constraints.maxHeight * 0.2,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    transform: GradientRotation(0.5),
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      Color.fromARGB(200, 223, 242, 235),
                                      Color.fromARGB(255, 185, 229, 232),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SizedBox(
                                  width: constraints.maxWidth * 0.75,
                                  height: constraints.maxHeight * 0.125,
                                  child: TextField(
                                    controller: _email,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: constraints.maxHeight * 0.4,
                              left: constraints.maxWidth * 0.15,
                              child: Container(
                                width: constraints.maxWidth * 0.7,
                                height: constraints.maxHeight * 0.125,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      Color.fromARGB(150, 122, 178, 211),
                                      Color.fromARGB(100, 74, 98, 138),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Positioned(
                              top: constraints.maxHeight * 0.4,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    transform: GradientRotation(0.5),
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      Color.fromARGB(200, 223, 242, 235),
                                      Color.fromARGB(255, 185, 229, 232),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SizedBox(
                                  width: constraints.maxWidth * 0.75,
                                  height: constraints.maxHeight * 0.125,
                                  child: TextField(
                                    controller: _password,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: constraints.maxHeight * 0.54,
                                left: constraints.maxWidth * 0.02,
                                child: GestureDetector(
                                    onTap: () {},
                                    child: const Text('Forgot password?'))),
                            Positioned(
                              top: constraints.maxHeight * 0.65,
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
                                      //todo: navigate to home page
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'invalid-credential') {
                                        devtools.log('user not found');
                                      } else {
                                        devtools.log(
                                            'something went wrong\n ${e.code}');
                                      }
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(100, 74, 98, 138),
                                  ),
                                  child: const Text('Login'),
                                ),
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
                                    Text(noAccountMessage.split('Register')[0]),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: SizedBox(
                                                  width:
                                                      AspectRatios.width * 0.8,
                                                  height:
                                                      AspectRatios.height * 0.7,
                                                  child: const RegisterPage(),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        noAccountMessage.split('? ')[1],
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
