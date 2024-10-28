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
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                developer.log('${constraints.maxHeight}');
                              },
                              child: Container(
                                width: constraints.maxWidth * 0.8,
                                height: constraints.maxHeight * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SizedBox(
                                  width: constraints.maxWidth * 0.8,
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
                              top: 100,
                              left: 35,
                              child: Container(
                                width: AspectRatios.width * 0.6,
                                height: AspectRatios.height * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
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
