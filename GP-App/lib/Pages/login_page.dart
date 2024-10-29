import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'dart:developer' as developer show log;
import 'package:rates/pages/temp_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
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
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: AspectRatios.height * 0.4,
                      maxWidth: AspectRatios.width * 0.8,
                    ),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Container(
                        width: constraints.maxHeight,
                        height: constraints.maxHeight,
                        padding: EdgeInsets.symmetric(
                          horizontal: AspectRatios.width * 0.05,
                          vertical: AspectRatios.height * 0.03,
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
                              top: constraints.maxHeight * 0.2,
                              child: Container(
                                width: constraints.maxWidth * 0.8,
                                height: constraints.maxHeight * 0.125,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.centerRight,
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
                              left: constraints.maxWidth * 0.15,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    transform: GradientRotation(0.5),
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color.fromARGB(200, 223, 242, 235),
                                      Color.fromARGB(255, 185, 229, 232),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SizedBox(
                                  width: constraints.maxWidth * 0.7,
                                  height: constraints.maxHeight * 0.125,
                                  child: TextField(
                                    onChanged: (value) {
                                      developer
                                          .log('==${constraints.maxWidth}');
                                    },
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
                                  width: constraints.maxWidth * 0.7,
                                  height: constraints.maxHeight * 0.125,
                                  child: TextField(
                                    onChanged: (value) {
                                      developer
                                          .log('==${constraints.maxWidth}');
                                    },
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
                              top: constraints.maxHeight * 0.2,
                              child: Container(
                                width: constraints.maxWidth * 0.8,
                                height: constraints.maxHeight * 0.125,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.centerRight,
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
                              left: constraints.maxWidth * 0.15,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    transform: GradientRotation(0.5),
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color.fromARGB(200, 223, 242, 235),
                                      Color.fromARGB(255, 185, 229, 232),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SizedBox(
                                  width: constraints.maxWidth * 0.7,
                                  height: constraints.maxHeight * 0.125,
                                  child: TextField(
                                    onChanged: (value) {
                                      developer
                                          .log('==${constraints.maxWidth}');
                                    },
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