<<<<<<< HEAD
import 'package:admin_app/constants/aspect_ratio.dart';
import 'package:admin_app/pages/registration/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization error: $e");
    return;
  }
  FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: false,
      host: 'firestore.googleapis.com',
      sslEnabled: true);
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
      home: const SignupPage(),
    );
  }
}
=======

>>>>>>> a15e3720ffad3c4ab14f36235c99bcd7ce9bc088
