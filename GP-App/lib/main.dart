import 'package:flutter/material.dart';
import 'package:rates/Pages/login_page.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/pages/register_page.dart';
import 'package:rates/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (AspectRatios.isInitialized == false) {
      AspectRatios.height = MediaQuery.of(context).size.height;
      AspectRatios.isInitialized = true;
    }
    return MaterialApp(
      initialRoute: splashScreenRoute,
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterPage(),
        splashScreenRoute: (context) => const SplashScreen(),
      },
    );
  }
}
