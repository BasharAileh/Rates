import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

Widget registerDialog =
    LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
  return SizedBox(
    width: constraints.maxWidth,
    height: constraints.maxHeight,
    child: Column(
      children: [
        ElevatedButton(
          onPressed: () {
            devtools.log('${constraints.maxWidth}, ${constraints.maxHeight}');
          },
          child: const Text('Log constraints'),
        ),
      ],
    ),
  );
});
