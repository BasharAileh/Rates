import 'package:flutter/material.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/pages/login_page.dart';
import 'package:rates/pages/register_page.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: loginRoute,
    routes: {
      loginRoute: (context) => const LoginPage(),
      registerRoute: (context) => const RegisterPage(),
    },
  ));
}
