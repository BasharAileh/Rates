import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rates/Pages/home/main_pages_with_nav_bar.dart';
import 'package:rates/Pages/other/splash_screen.dart';
import 'package:rates/Pages/registration/login_page.dart';
import 'package:rates/constants/app_colors.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/services/auth/auth_service.dart';
import 'package:rates/services/cloud/cloud_instances.dart';
import 'package:rates/services/cloud/firebase_cloud_storage.dart';

late final FireStoreUser? cloudUser;
FirebaseCloudStorage cloudService = FirebaseCloudStorage();

final Future<void> _initializeFirebase = Future.delayed(
    const Duration(
      milliseconds: 2820,
    ), () async {
  await AuthService.firebase().initialize();
});

class InitPage extends StatelessWidget {
  const InitPage({super.key});
  @override
  Widget build(BuildContext context) {
    AspectRatios.init(
      MediaQuery.of(context).size.height,
      MediaQuery.of(context).size.width,
    );
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
              return FutureBuilder(
                future: cloudService.getUserInfo(user.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SplashScreen(
                      shouldSkipAnimation: true,
                    );
                  } else if (snapshot.hasError) {
                    devtools.log('Error: ${snapshot.error}');
                    return const Center(
                      child: Text('Failed to load user info'),
                    );
                  } else if (snapshot.hasData) {
                    final cloudUser = snapshot.data as FireStoreUser;
                    if (cloudUser.isEmailVerified != user.isEmailVerified &&
                        user.isEmailVerified) {
                      cloudService.updateUserEmailVerification(
                        user.id,
                        user.isEmailVerified,
                      );
                      return const PagesWithNavBar(
                        removeVerificationMessage: true,
                      );
                    }
                    return const PagesWithNavBar();
                  }
                  return const Center(
                    child: Text('No user data found'),
                  );
                },
              );
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
