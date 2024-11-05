import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showVerificationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Email not verified'),
        content: const Text('Please verify your email to continue.'),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.currentUser!.sendEmailVerification();
            },
            child: const Text('Send verification email'),
          ),
        ],
      );
    },
  );
}
