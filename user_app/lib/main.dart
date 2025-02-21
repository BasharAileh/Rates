import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/Pages/home/main_pages_with_nav_bar.dart';
import 'package:rates/Pages/registration/login_page.dart';
import 'package:rates/Pages/registration/otp_verify_page.dart';
import 'package:rates/Pages/registration/reset_pass_method_page.dart';
import 'package:rates/Pages/registration/signup_page.dart';
import 'package:rates/Pages/shop/menu_page.dart';
import 'package:rates/Pages/shop/rest_info_page.dart';
import 'package:rates/Pages/shop/shops_page.dart';
import 'package:rates/Pages/shop/view_ratings_page.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/constants/theme_controller.dart';
import 'package:rates/dialogs/nav_bar.dart';
import 'package:rates/dialogs/redeem_dialog.dart';
import 'package:rates/init_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BottomNavController()); // Initialize BottomNavController
    Get.put(ThemeController()); // Initialize ThemeController

    return GetMaterialApp(
      title: 'Flutter Demo',
      themeMode: Get.find<ThemeController>().themeMode.value, // Use ThemeController's theme mode
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // Background color in light mode
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: MediaQuery.of(context).size.height * 0.0663507109,
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.grey[800]!,
          onSecondary: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black, // Button text color
          ),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900], // Background color in dark mode
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          elevation: 0,
          toolbarHeight: MediaQuery.of(context).size.height * 0.0663507109,
        ),
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.grey[900]!,
          onSecondary: Colors.black,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white, // Button text color
          ),
        ),
        useMaterial3: true,
      ),
      initialRoute: initRoute,
      getPages: [
        GetPage(
          name: homeRoute,
          page: () => const PagesWithNavBar(page: 2),
        ),
        GetPage(
          name: loginRoute,
          page: () => const LoginPage(),
        ),
        GetPage(
          name: initRoute,
          page: () => const InitPage(),
        ),
        GetPage(
          name: signupRoute,
          page: () => const SignupPage(),
        ),
        GetPage(
          name: otpVerifyRoute,
          page: () => const OtpVerifyPage(),
        ),
        GetPage(
          name: verifySuccessRoute,
          page: () => const Placeholder(), // Replace with SvgTopToBottomFade if defined
        ),
        GetPage(
          name: verCodeDialogRoute,
          page: () => const VerificationDialogPage(),
        ),
        GetPage(
          name: resetPassMethodRoute,
          page: () => const ResetPassMethodPage(),
        ),
        GetPage(
          name: profileRoute,
          page: () => const PagesWithNavBar(page: 1),
        ),
        GetPage(
          name: topRatedRoute,
          page: () => const FoodPage(),
        ),
        GetPage(
          name: restInfoRoute,
          page: () => const RestaurantInformationPage(),
        ),
        GetPage(
          name: menuPageRoute,
          page: () => const MenuPage(),
        ),
        GetPage(
          name: viewRatingRoute,
          page: () => const ViewRating(),
        ),
      ],
    );
  }
}