import 'dart:developer' as devtools show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/firebase_options.dart';
import 'package:rates/pages/home_page.dart';
import 'package:rates/pages/login_page.dart';
import 'package:rates/pages/splash_screen.dart';

final Future<void> _initializeFirebase =
    Future.delayed(const Duration(seconds: 2), () async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
});

class FirebaseInitPage extends StatelessWidget {
  const FirebaseInitPage({super.key});
  @override
  Widget build(BuildContext context) {
    AspectRatios.init(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return FutureBuilder(
      future: _initializeFirebase,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            devtools.log('1');
            return const SplashScreen();
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            devtools.log('User: $user');
            if (user != null) {
              if (user.emailVerified) {
                return const HomePage();
              } else {
                return const LoginPage();
              }
            } else {
              return const LoginPage();
            }

          default:
            devtools.log('2');
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
