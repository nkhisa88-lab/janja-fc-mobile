import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.ivory,

    colorScheme:
        ColorScheme.fromSeed(
          seedColor: AppColors.mutedGold,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.espresso,
          secondary: AppColors.mutedGold,
          surface: AppColors.ivory,
          onPrimary: AppColors.white,
          onSurface: AppColors.espresso,
        ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.ivory,
      foregroundColor: AppColors.espresso,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.cormorantGaramond(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: AppColors.espresso,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: GoogleFonts.cormorantGaramond(
        color: AppColors.espresso,
        fontSize: 42,
        fontWeight: FontWeight.w600,
      ),

      displayMedium: GoogleFonts.cormorantGaramond(
        color: AppColors.espresso,
        fontSize: 36,
        fontWeight: FontWeight.w600,
      ),

      headlineLarge: GoogleFonts.cormorantGaramond(
        color: AppColors.espresso,
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),

      headlineMedium: GoogleFonts.cormorantGaramond(
        color: AppColors.espresso,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),

      titleLarge: GoogleFonts.cormorantGaramond(
        color: AppColors.espresso,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),

      bodyLarge: GoogleFonts.inter(color: AppColors.espresso, fontSize: 16),

      bodyMedium: GoogleFonts.inter(color: AppColors.warmGrey, fontSize: 14),

      labelLarge: GoogleFonts.inter(
        color: AppColors.espresso,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,

      labelStyle: const TextStyle(color: AppColors.warmGrey),

      floatingLabelStyle: const TextStyle(color: AppColors.espresso),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.border),
      ),

      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.espresso, width: 1.5),
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.espresso,
        foregroundColor: AppColors.white,

        elevation: 0,

        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),

        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.espresso,

        side: const BorderSide(color: AppColors.espresso),

        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      margin: const EdgeInsets.all(8),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: AppColors.border),
      ),
    ),

    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.espresso,
      contentTextStyle: TextStyle(color: AppColors.white),
    ),
  );
}
