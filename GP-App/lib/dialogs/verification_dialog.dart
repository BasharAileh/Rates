import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rates/constants/routes.dart';

Future<void> showVerificationDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Check your email'),
        content: const Text('Please verify your email to continue.'),
        actions: [
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Log out')),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.currentUser!.sendEmailVerification();
            },
            child: const Text('Send verification email'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('I have verified my email')),
        ],
      );
    },
  );
}
