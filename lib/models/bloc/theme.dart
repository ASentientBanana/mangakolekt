import 'package:flutter/material.dart';

class ThemeStore {
  late Color primaryColor;
  late Color accentColor;
  late Color backgroundColor;
  late Color primaryDark;
  late Color tertiary;

  ThemeStore(
      {required this.primaryDark,
      required this.tertiary,
      required this.accentColor,
      required this.primaryColor,
      required this.backgroundColor});

  ThemeStore.defaultTheme() {
    primaryColor = const Color(0xFFEAC57D);
    accentColor = const Color(0xFF7B7C81);
    backgroundColor = const Color(0xFF1D0F0F);
    primaryDark = const Color(0xFF7B586B);
    tertiary = const Color(0xFF453C41);
  }
}
