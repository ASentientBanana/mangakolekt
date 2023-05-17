import 'package:flutter/material.dart';
import 'package:mangakolekt/models/bloc/theme.dart';

convertToThemeData(ThemeStore ts) {
  return ThemeData(
    primaryColor: ts.primaryColor,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ts.backgroundColor,
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: ts.textColor,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ts.appbarBackground,
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: ts.primaryColor,
      secondary: ts.accentColor,
      tertiary: ts.tertiary,
      brightness: Brightness.dark,
    ),
  );
}
