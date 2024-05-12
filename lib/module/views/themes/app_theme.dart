import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black; // Change text color to black
  static const Color gradientStart = Colors.black;
  static const Color gradientEnd = Colors.lightBlueAccent;

  static const TextStyle bodyLarge =
      TextStyle(color: textColor, fontSize: 18); // Use textColor
  static const TextStyle bodyMedium =
      TextStyle(color: textColor, fontSize: 16); // Use textColor
  static const TextStyle titleMedium = TextStyle(
      color: textColor,
      fontSize: 20,
      fontWeight: FontWeight.bold); // Use textColor
  static const TextStyle titleSmall = TextStyle(
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.bold); // Use textColor

  static const LinearGradient gradientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static final ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.lightBlue, // Use Material Color for primary
    ),
    scaffoldBackgroundColor: backgroundColor,
    textTheme: const TextTheme(
      bodyLarge: bodyLarge, // Set text color
      bodyMedium: bodyMedium, // Set text color
      titleMedium: titleMedium, // Set text color
      titleSmall: titleSmall, // Set text color
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Colors.black), // Set elevated button background color
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
              color: Colors.white), // Set elevated button text color
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
            Colors.black), // Set outlined button text color
        side: MaterialStateProperty.all<BorderSide>(const BorderSide(
            color: Colors.black)), // Set outlined button border color
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
              color: Colors.black), // Set outlined button text color
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: backgroundColor, // Set input field background color
      filled: true,
      hintStyle:
          TextStyle(color: textColor.withOpacity(0.5)), // Set hint text color
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: textColor), // Set border color
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Colors.lightBlue), // Set focused border color
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
  );
}
