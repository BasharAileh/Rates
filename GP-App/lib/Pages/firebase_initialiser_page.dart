import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/pages/home_page.dart';
import 'package:rates/pages/login_page.dart';
import 'package:rates/pages/splash_screen.dart';
import 'package:rates/services/auth/auth_service.dart';

final Future<void> _initializeFirebase =
    Future.delayed(const Duration(seconds: 2), () async {
  await AuthService.firebase().initialize();
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
            return const SplashScreen();
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            devtools.log('User: $user');
            if (user != null) {
              if (user.isAnonymous) {
                return const HomePage();
              }
              if (user.isEmailVerified) {
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
