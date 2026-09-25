import 'package:flutter/material.dart';

class AppTheme {
  // Base
  static const Color textDark = Color(0xFF2D1B69);
  static const Color primary = Color(0xFF9B7EDE);
  static const Color primaryVariant = Color(0xFF7C5CBF);
  static const Color primaryDark = Color(0xFF5B3A9E);

  static const Color bgLight = Color(0xFFF8F6FC);
  static const Color inputLight = Color(0xFFF5F0FF);

  static const Color success = Color(0xFF4ADE80);
  static const Color successLight = Color(0xFF86EFAC);
  static const Color error = Color(0xFFF87171);
  static const Color errorLight = Color(0xFFFCA5A5);

  // Dark
  static const Color bgDark = Color(0xFF130B29);
  static const Color cardDark = Color(0xFF1F1340);
  static const Color inputDark = Color(0xFF2A1C54);

  // Graphs and Banks
  static const List<Color> pieColors = [
    Color(0xFF9B7EDE),
    Color(0xFF86EFAC),
    Color(0xFFFCA5A5),
    Color(0xFFFCD34D),
    Color(0xFFC4B5F4),
  ];

  static const Map<String, Color> bankColors = {
    'mp': Color(0xFF009EE3),
    'nx': Color(0xFFFF6900),
    'bn': Color(0xFF00509E),
    'lm': Color(0xFF7DC900),
  };

  // LightTheme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: bgLight,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primaryVariant,
        tertiary: primaryDark,
        surface: Colors.white,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0x99F5F0FF), width: 1),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textDark, fontWeight: FontWeight.w900),
        titleLarge: TextStyle(color: textDark, fontWeight: FontWeight.w900),
        bodyLarge: TextStyle(color: textDark, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputLight,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  // DarkTheme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primaryVariant,
        tertiary: primaryDark,
        surface: cardDark,
        error: errorLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFF2D1B69), width: 1),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
        titleLarge: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
        bodyLarge: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          color: Colors.grey[400],
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputDark,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
