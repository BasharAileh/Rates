import 'package:flutter/material.dart';
import 'package:rates/constants/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, loginRoute);
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
