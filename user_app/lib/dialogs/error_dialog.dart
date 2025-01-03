import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String message,
) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('An error occurred'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
