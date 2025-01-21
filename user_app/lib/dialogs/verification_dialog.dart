import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/services/auth/auth_exception.dart';
import 'package:rates/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

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
              await AuthService.firebase().logOut();
              if (context.mounted) {
                Get.offAllNamed(loginRoute);
              }
            },
            child: const Text('Log out'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await AuthService.firebase().sendEmailVerification();
              } on TooManyRequestsAuthException {
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Too many requests'),
                        content: const Text(
                            'Please wait a moment before sending another verification email.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              } catch (e) {
                devtools.log(e.toString());
              }
            },
            child: const Text('Send verification email'),
          ),
        ],
      );
    },
  );
}
