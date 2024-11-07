import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:rates/dialogs/error_dialog.dart';

Future<void> register(
  BuildContext context,
  TextEditingController gEmail,
  TextEditingController password1,
  TextEditingController password2,
) async {
  final email = gEmail.text;

  if (password1.text == password2.text) {
    final password = password1.text;
    try {
      devtools.log('Creating user with email: $email');
      devtools.log('Creating user with password: $password');
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      devtools.log(userCredential.user.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (context.mounted) {
          await showErrorDialog(context, 'The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (context.mounted) {
          await showErrorDialog(
              context, 'The account already exists for that email.');
        }
      } else if (e.code == 'invalid-email') {
        if (context.mounted) {
          await showErrorDialog(
              context, 'The email address is badly formatted.');
        }
      }
    } catch (e) {
      if (context.mounted) {
        await showErrorDialog(context, e.toString());
      }
    }
  }
}
