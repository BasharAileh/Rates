import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rates/firebase_options.dart';
import 'package:rates/pages/home_page.dart';
import 'package:rates/pages/login_page.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/pages/register_page.dart';
import 'package:rates/pages/splash_screen.dart';
import 'package:rates/pages/verification_page.dart';

class FirebaseInitPage extends StatelessWidget {
  const FirebaseInitPage({super.key});
  @override
  Widget build(BuildContext context) {
    AspectRatios.init(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2), () async {
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
      }),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const SplashScreen();
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const HomePage();
              } else {
                return const VerificationPage();
              }
            } else {
              return const LoginPage();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
