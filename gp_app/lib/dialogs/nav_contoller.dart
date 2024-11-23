import 'package:get/get.dart';
import 'package:rates/constants/routes.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs; // Reactive variable for the selected index

  void changePage(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.offAllNamed(homeRoute); // Navigate to Home
        break;
      case 1:
        Get.offAllNamed('/profile'); // Navigate to Profile (define this route)
        break;
      case 2:
        Get.offAllNamed(loginRoute); // Navigate to Login
        break;
      case 3:
        Get.offAllNamed('/favorites'); // Navigate to Favorites (define this route)
        break;
      case 4:
        Get.offAllNamed('/about'); // Navigate to About (define this route)
        break;
    }
  }
}













// import 'dart:developer' as devtools show log;

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:rates/constants/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Import GetX package
// import 'package:rates/Pages/home/home_page.dart';
// import 'package:rates/Pages/registration/login_page.dart';
// import 'package:rates/constants/routes.dart';
// import 'package:rates/init_page.dart';
// import 'package:rates/controllers/bottom_nav_controller.dart'; // Import the controller

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Initialize the BottomNavController
//     Get.put(BottomNavController());

//     return GetMaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       initialRoute: homeRoute, // Set the initial route
//       getPages: [
//         GetPage(name: homeRoute, page: () => const HomePage()),
//         GetPage(name: loginRoute, page: () => const LoginPage()),
//         // Add other pages as needed
//         GetPage(name: '/init', page: () => const InitPage()),
//       ],
//     );
//   }
// }

// ////////////////////////////////////////////////////
// BottomNavigationBar na(BuildContext context, int index) {
//   return BottomNavigationBar(
//       currentIndex: 2,
//       onTap: (index) {
//         switch (index) {
//           case 0:
//             Navigator.of(context).pushReplacementNamed(homeRoute);
//             devtools.log('object');
//             break;
//           case 1:
//             devtools.log('pew');
//           // Navigator.of(context).pushReplacementNamed('routeName');
//           case 2:
//             Navigator.of(context).pushReplacementNamed(loginRoute);
//         }
//       },
//       selectedItemColor: Colors.black,
//       unselectedItemColor: Colors.black,
//       items: [
//         BottomNavigationBarItem(
//           icon: SvgPicture.asset('assets/icons/rate_icon.svg'),
//           label: 'Rate',
//         ),
//         BottomNavigationBarItem(
//           icon: SvgPicture.asset('assets/icons/profile_icon.svg'),
//           label: 'Profile',
//         ),
//         BottomNavigationBarItem(
//           icon: SvgPicture.asset('assets/icons/home_icon.svg'),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: SvgPicture.asset('assets/icons/favorite_icon.svg'),
//           label: 'Favorites',
//         ),
//         BottomNavigationBarItem(
//           icon: SvgPicture.asset('assets/icons/about_icon.svg'),
//           label: 'About',
//         ),
//       ]);
// }
