import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:rates/Pages/other/splash_screen.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/services/auth/auth_service.dart';
import 'Pages/other/profile_page.dart';
import 'Pages/home/home_page.dart';

final Future<void> _initializeFirebase = Future.delayed(
    const Duration(
        /* seconds: 4, */
        ), () async {
  await AuthService.firebase().initialize();
});

class InitPage extends StatelessWidget {
  const InitPage({super.key});
  @override
  Widget build(BuildContext context) {
    AspectRatios.init(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return FutureBuilder(
      future: _initializeFirebase,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return SplashScreen();
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            devtools.log('User: $user');
            if (user != null) {
              if (user.isAnonymous) {
                return ProfilePage();
              }
              if (user.isEmailVerified) {
                return ProfilePage();
              } else {
                return ProfilePage();
              }
            } else {
              return SplashScreen(); //this is the one you change whenever you want to run your page
              //don't text me 'what line to change, so i can run my page please :)'
            }

          default:
            devtools.log('2');
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
