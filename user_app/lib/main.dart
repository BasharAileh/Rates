import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/Pages/home/main_pages_with_nav_bar.dart';
import 'package:rates/Pages/registration/login_page.dart';
import 'package:rates/Pages/registration/otp_verify_page.dart';
import 'package:rates/Pages/registration/reset_pass_method_page.dart';
import 'package:rates/Pages/registration/signup_page.dart';
import 'package:rates/Pages/shop/rest_info_page.dart';
import 'package:rates/Pages/shop/shops_page.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/dialogs/nav_bar.dart';
import 'package:rates/dialogs/redeem_dialog.dart';
import 'package:rates/init_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BottomNavController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: MediaQuery.of(context).size.height * 0.0663507109,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
          page: () =>
              const Placeholder(), // Replace with SvgTopToBottomFade if defined
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
        // Add other pages with their respective routes
      ],
    );
  }
}
