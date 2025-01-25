import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable theme mode
  var themeMode = ThemeMode.system.obs;

  // Initialize the theme based on system preference
  ThemeController() {
    _initializeTheme();
  }

  // Detect system theme and set initial theme mode
  void _initializeTheme() {
    final Brightness systemBrightness =
        WidgetsBinding.instance.window.platformBrightness;
    themeMode.value = systemBrightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  // Toggle between light, dark, and system themes
  void toggleTheme(String theme) {
    switch (theme) {
      case "Light":
        themeMode.value = ThemeMode.light;
        break;
      case "Dark":
        themeMode.value = ThemeMode.dark;
        break;
      case "System":
        themeMode.value = ThemeMode.system;
        break;
    }
    Get.changeThemeMode(themeMode.value); // Update the app's theme
  }
}