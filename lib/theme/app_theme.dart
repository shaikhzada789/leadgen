// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary
  static const Color cyan = Color(0xFF06B6D4);
  static const Color blue = Color(0xFF3B82F6);
  static const Color purple = Color(0xFFA855F7);
  static const Color emerald = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color rose = Color(0xFFF43F5E);

  // Backgrounds
  static const Color bgDeep = Color(0xFF020617);
  static const Color bgDark = Color(0xFF0F172A);
  static const Color bgCard = Color(0x0DFFFFFF);
  static const Color bgGlass = Color(0x08FFFFFF);

  // Borders
  static const Color borderGlass = Color(0x14FFFFFF);
  static const Color borderGlow = Color(0x40FFFFFF);

  // Text
  static const Color textPrimary = Color(0xFFE2E8F0);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF475569);

  // Gradients
  static const LinearGradient cyanBlue = LinearGradient(
    colors: [cyan, blue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient emeraldGreen = LinearGradient(
    colors: [emerald, Color(0xFF16A34A)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient dangerRed = LinearGradient(
    colors: [rose, Color(0xFFE11D48)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient purpleCyan = LinearGradient(
    colors: [purple, cyan],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDeep,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.cyan,
        secondary: AppColors.blue,
        surface: AppColors.bgDark,
        error: AppColors.rose,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 32,
        ),
        headlineMedium: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
        titleMedium: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
    );
  }
}
