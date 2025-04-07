import 'package:flutter/material.dart';
import 'package:threadly/core/theme/app_pallete.dart';

class AppTheme {
  static OutlineInputBorder _border([Color color = Colors.transparent]) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppPallete.blackColor),
    useMaterial3: true,
  ).copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    primaryColor: AppPallete.primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
      foregroundColor: AppPallete.primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPallete.whiteColor, // Background color of TextFormField
      floatingLabelBehavior:
          FloatingLabelBehavior.auto, // Keeps label above text
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ), // Adjust padding to prevent overlap
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(),
      errorBorder: _border(AppPallete.errorColor),
      labelStyle: TextStyle(color: Colors.grey[400]), // Style the label text
      hintStyle: TextStyle(color: Colors.grey[600]), // Style the hint text
    ),
  );
}
