import 'package:flutter/material.dart';
import 'package:rates/dialogs/error_dialog.dart';
import 'package:rates/dialogs/verification_dialog.dart';
import 'package:rates/services/auth/auth_exception.dart';
import 'package:rates/services/auth/auth_service.dart';

Future<void> register(
  BuildContext context,
  TextEditingController gEmail,
  TextEditingController password1,
) async {
  final TextEditingController email = gEmail;
  final TextEditingController password = password1;
  try {
    await AuthService.firebase()
        .createUser(email: email.text, password: password.text);
    await AuthService.firebase().sendEmailVerification();
    {
      if (context.mounted) {
        await showVerificationDialog(context);
      }
    }
  } on WeakPasswordAuthException {
    if (context.mounted) {
      await showErrorDialog(context, 'The password provided is too weak.');
    }
  } on EmailAlreadyInUseAuthException {
    if (context.mounted) {
      await showErrorDialog(
          context, 'The account already exists for that email.');
    }
  } on InvalidEmailAuthException {
    if (context.mounted) {
      await showErrorDialog(context, 'The email address is badly formatted.');
    }
  } on GenericAuthException {
    if (context.mounted) {
      await showErrorDialog(context, 'An error occurred.');
    }
  }
}
