import 'package:flutter/material.dart';

class RatesLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Star Icon
        Icon(
          Icons.star,
          color: Colors.orange, // Set the color of the star
          size: 30.0, // Adjust size as needed
        ),
        SizedBox(width: 8), // Spacing between icon and text
        // Text "Rates"
        Text(
          'Rates',
          style: TextStyle(
            fontSize: 24.0, // Font size for the text
            fontWeight: FontWeight.bold,
            color: Colors.black, // Text color
          ),
        ),
      ],
    );
  }
}
