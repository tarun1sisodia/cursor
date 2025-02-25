import 'package:firebase/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.blueAccent;

  // Text Styles
  static TextStyle get headlineLarge =>
      const TextStyle(fontSize: 28, fontWeight: FontWeight.bold);

  static TextStyle get headlineMedium =>
      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  static TextStyle get bodyLarge => const TextStyle(fontSize: 16);

  static TextStyle get bodyMedium => const TextStyle(fontSize: 14);

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Apppallete.backgroundColor,
    brightness: Brightness.dark,
    primaryColor: Apppallete.primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: Apppallete.primaryColorDark,
      secondary: Apppallete.primaryColor,
      onError: Apppallete.error,
      onSurface: Apppallete.primaryDarkColor,
      onSecondary: Apppallete.secondaryColor,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor:Apppallete.darkThemeButtonDarkColor, // Default button color
      // textTheme: ButtonTextTheme.primary,
      splashColor: Apppallete.primaryColoryellowish,
      
    ),
    textTheme: TextTheme(
      headlineLarge: headlineLarge.copyWith(color: Apppallete.textPrimary),
      headlineMedium: headlineMedium.copyWith(color: Apppallete.textPrimary),
      bodyLarge: bodyLarge.copyWith(color: Apppallete.textPrimary),
      bodyMedium: bodyMedium.copyWith(color: Apppallete.textSecondary),
      bodySmall: const TextStyle(fontSize: 12, color: Apppallete.textHint),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Apppallete.darkThemeButtonDarkColor,

        // foregroundColor: Colors.white,
      ),
    ),
  );

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
      );
}
