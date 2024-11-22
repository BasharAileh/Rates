import 'package:flutter/material.dart';
import 'package:rates/init_page.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const InitPage(),
  ));
}



// import 'package:flutter/material.dart';
// import 'package:rates/constants/routes.dart';
// import 'package:rates/pages/firebase_initialiser_page.dart';
// import 'package:rates/pages/home_page.dart';
// import 'package:rates/pages/shops_page.dart';
// import 'package:rates/pages/splash_screen.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       initialRoute: firebaseInitRoute,
//       routes: {
//         firebaseInitRoute: (context) => const FirebaseInitPage(),
//         loginRoute: (context) => const LoginPage(),
//         splashScreenRoute: (context) => const SplashScreen(),
//         homeRoute: (context) => const HomePage(),
//         shopsRoute: (context) => const ShopsPage(),
//         shopRoute: (context) => const ShopPage(),
//         favoritesRoute: (context) => const FavoritesPage(),
//         favoriteRoute: (context) => FavoritePage(
//               favoriteRestaurants: const [],
//               favoriteLogos: const [],
//               onRemoveFavorite: (String restaurantId, String logoUrl) {},
//             ),
//         categoriesRoute: (context) => const Categories(),
//       },
//     ),
//   );
// }
