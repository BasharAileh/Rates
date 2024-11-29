import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:rates/Pages/home/home_page.dart';
import 'package:rates/Pages/registration/login_page.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/services/auth/auth_service.dart';
import 'package:rates/Pages/home/home_page.dart';

import 'Pages/other/favorites_page.dart';
import 'Pages/other/profile_page.dart';
import 'Pages/shops/shops_page.dart';

final Future<void> _initializeFirebase =
    Future.delayed(const Duration(seconds: 2), () async {
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
            return const CircularProgressIndicator();
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
              return const LoginPage(); //this is the one you change whenever you want to run your page
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
