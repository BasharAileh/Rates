import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rates/constants/routes.dart';

class VerificationPopup extends StatelessWidget {
  final User user;
  const VerificationPopup({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Verify your email"),
      content: const Text(
          "We have sent a verification link to your email. Please verify your email to continue."),
      actions: [
        TextButton(
          onPressed: () {
            user.sendEmailVerification();
            Navigator.of(context).pop();
          },
          child: const Text("Resend verification email"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Routes.loginRoute);
          },
          child: const Text("Go back to login"),
        ),
      ],
    );
  }
}
