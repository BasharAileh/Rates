import 'package:admin_app/constants/aspect_ratio.dart';
import 'package:admin_app/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const RatesAdminApp());
}

class RatesAdminApp extends StatelessWidget {
  const RatesAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    AspectRatios.init(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      title: 'Restaurant Information',
      theme: ThemeData(
          primarySwatch: Colors.amber,
          scaffoldBackgroundColor: Colors.white,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color.fromARGB(255, 243, 198, 35), // Cursor color
            selectionHandleColor:
                Color.fromARGB(255, 243, 198, 35), // Caret handle color
          )),
      home: const RestaurantInformationPage(),
    );
  }
}
