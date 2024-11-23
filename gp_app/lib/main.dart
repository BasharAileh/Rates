import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/Pages/home/home_page.dart';
import 'package:rates/Pages/registration/login_page.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/dialogs/nav_contoller.dart';
import 'package:rates/init_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize BottomNavController globally
    Get.put(BottomNavController());

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/init',
      getPages: [
        GetPage(name: homeRoute, page: () => const HomePage()),
        GetPage(name: loginRoute, page: () => const LoginPage()),
        GetPage(name: '/init', page: () => const InitPage()),
        // Add other pages with their respective routes
      ],
    );
  }
}
