import 'package:admin/admins_pages/pending.dart';
import 'package:admin/constants/aspect_ratio.dart';
import 'package:admin/pages/registration/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const RatesAdminApp());
}

class RatesAdminApp extends StatelessWidget {
  const RatesAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    AspectRatios.init(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return MaterialApp(
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
      home: const LoginPage(),
    );
  }
}
