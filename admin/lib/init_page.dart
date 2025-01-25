import 'dart:developer' as devtools show log;
import 'package:admin/admins_pages/pending.dart';
import 'package:admin/pages/home/home_page.dart';
import 'package:admin/pages/registration/login_page.dart';
import 'package:admin/services/auth/auth_service.dart';
import 'package:admin/services/auth/auth_user.dart';
import 'package:admin/services/cloud/cloud_instances.dart';
import 'package:admin/services/cloud/cloud_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

String? userType;
CloudService cloudService = CloudService();

final Future<void> _initializeFirebase = Future.delayed(
    const Duration(
      milliseconds: 2820,
    ), () async {
  await AuthService.firebase().initialize();
});

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    /* AspectRatios.init(
      MediaQuery.of(context).size.height,
      MediaQuery.of(context).size.width,
    ); */
    return FutureBuilder(
      future: _initializeFirebase.then((value) async {
        AuthUser? user = AuthService.firebase().currentUser;
        if (user != null) {
          userType = await cloudService.getUserType(user.id);
        }
      }),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.done:
            AuthUser? user = AuthService.firebase().currentUser;
            if (user != null) {
              return userType == 'admin'
                  ? const AdminRestaurantsPage()
                  : const RestaurantInformationPage();
            }
            return const LoginPage();

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
