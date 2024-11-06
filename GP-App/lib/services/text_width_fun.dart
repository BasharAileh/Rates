import 'package:flutter/material.dart';

const TextStyle defaultStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

double measureTextWidth(String text, {TextStyle? style}) {
  final textStyle = style ?? defaultStyle;

  final textPainter = TextPainter(
    text: TextSpan(text: text, style: textStyle),
    textDirection: TextDirection.ltr,
  )..layout();

  return textPainter.width;
}
