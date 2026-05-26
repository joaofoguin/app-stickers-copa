import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.oswaldTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        secondary: AppColors.successGreen,
        surface: AppColors.surface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.oswald(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.background,
        indicatorColor: Colors.transparent,
        height: 74,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selecionado = states.contains(WidgetState.selected);

          return GoogleFonts.oswald(
            color: selecionado
                ? AppColors.textPrimary
                : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selecionado = states.contains(WidgetState.selected);

          return IconThemeData(
            color: selecionado
                ? AppColors.textPrimary
                : AppColors.textSecondary,
            size: selecionado ? 28 : 26,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceMedium,
        hintStyle: GoogleFonts.oswald(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
        prefixIconColor: AppColors.textSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: AppColors.borderLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: AppColors.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 1.2,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        contentTextStyle: GoogleFonts.oswald(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}