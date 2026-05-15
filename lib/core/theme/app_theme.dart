import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'app_theme_extension.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bgPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      secondary: AppColors.accentSoft,
      surface: AppColors.bgSecondary,
      error: AppColors.error,
    ),
    textTheme: GoogleFonts.dmSansTextTheme(),
    extensions: const [AppColorsExtension.light],
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBgPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.darkAccentSoft,
      surface: AppColors.darkBgSecondary,
      error: Color(0xFFDC2626),
    ),
    textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme),
    extensions: const [AppColorsExtension.dark],
  );
}
