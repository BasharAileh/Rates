import 'package:flutter/material.dart';
import 'package:rates/constants/aspect_ratio.dart';
import 'package:rates/constants/routes.dart';
import 'package:rates/pages/register_page.dart';

void showSignUpOptions(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Center(child: Text('Sign up options')),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: AspectRatios.width * 0.8,
                          height: AspectRatios.height * 0.7,
                          child: const RegisterPage(),
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text('Sign up with email'),
            ),
            ElevatedButton(
              onPressed: () {
                //todo: implement
              },
              child: const Text('Sign up with phone'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Sign up with google'),
            ),
          ],
        ),
      );
    },
  );
}
