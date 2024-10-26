import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'dart:developer' as developer show log;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent]),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: AspectRatios.height * 0.1,
                ),
                GestureDetector(
                  onTap: () => developer.log(AspectRatios.height.toString()),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
