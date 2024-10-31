import 'package:flutter/material.dart';

InputDecoration textFieldDecoration(String hintText) {
  return InputDecoration(
    labelText: hintText, // Use labelText instead of hintText
    labelStyle: const TextStyle(color: Colors.grey), // Color of the label
    filled: false, // Set filled to false to remove the background color
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10), // Slightly rounded corners
      borderSide: BorderSide(
        color: Colors.grey[300]!, // Subtle border color
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.blue, // Color when focused
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.grey[300]!, // Color when enabled
      ),
    ),
  );
}
