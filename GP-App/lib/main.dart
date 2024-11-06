import 'package:flutter/material.dart';
import 'package:rates/Pages/favorites_page.dart';
import 'package:rates/Pages/login_page.dart';
import 'package:rates/Pages/shop_page.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/pages/firebase_initialiser_page.dart';
import 'package:rates/pages/home_page.dart';
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
      initialRoute: firebaseInitRoute,
      routes: {
        firebaseInitRoute: (context) => const FirebaseInitPage(),
        loginRoute: (context) => const LoginPage(),
        splashScreenRoute: (context) => const SplashScreen(),
        homeRoute: (context) => const HomePage(),
        shopsRoute: (context) => const ShopsPage(),
        shopRoute: (context) => const ShopPage(),
        favoritesRoute: (context) => const FavoritesPage(),
      },
    ),
  );
}
