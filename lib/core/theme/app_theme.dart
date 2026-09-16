import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF0D0D10);
  static const navigation = Color(0xFF121214);

  static const surface = Color(0xFF1B1B1E);
  static const surfaceSecondary = Color(0xFF18181C);

  static const border = Color(0xFF29292D);

  static const cyan = Color(0xFF00F0FF);
  static const cyanDark = Color(0xFF0B777F);

  static const green = Color(0xFF00FF87);
  static const greenDark = Color(0xFF087E49);

  static const text = Color(0xFFF2F2F4);
  static const muted = Color(0xFF8D8D98);
  static const subtle = Color(0xFF666672);

  static const warning = Color(0xFFE0A900);
  static const warningBackground = Color(0xFF211D12);

  static const error = Color(0xFFFF5D67);
  static const errorBackground = Color(0xFF291719);
}

abstract final class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,

      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.cyan,
        secondary: AppColors.green,
        error: AppColors.error,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.cyan,
          ),
        ),
      ),
    );
  }
}