import 'package:flutter/material.dart';
import 'package:rates/Pages/login_page.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/pages/firebase_initialiser_page.dart';
import 'package:rates/pages/home_page.dart';
import 'package:rates/pages/register_page.dart';
import 'package:rates/pages/shop_page.dart';
import 'package:rates/pages/shops_page.dart';
import 'package:rates/pages/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: Routes.firebaseInitRoute,
      routes: {
        Routes.firebaseInitRoute: (context) => const FirebaseInitPage(),
        Routes.loginRoute: (context) => const LoginPage(),
        Routes.registerRoute: (context) => const RegisterPage(),
        Routes.splashScreenRoute: (context) => const SplashScreen(),
        Routes.homeRoute: (context) => const HomePage(),
        Routes.shopsRoute: (context) => const ShopsPage(),
        Routes.shopRoute: (context) => const ShopPage(),
      },
    ),
  );
}
