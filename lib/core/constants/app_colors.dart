import 'package:flutter/material.dart';

class AppColors {
  // Light Mode
  static const Color bgPrimary = Color(0xFFF7F5F2);
  static const Color bgSecondary = Color(0xFFFFFFFF);
  static const Color bgTertiary = Color(0xFFEFEDE9);
  static const Color accent = Color(0xFFC9A84C);
  static const Color accentSoft = Color(0xFFF5E9C8);
  static const Color accentDeep = Color(0xFF8B6914);
  static const Color textPrimary = Color(0xFF18181B);
  static const Color textSecondary = Color(0xFF71717A);
  static const Color textTertiary = Color(0xFFA1A1AA);
  static const Color textOnAccent = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color divider = Color(0xFFE4E4E7);
  static const Color scrim = Color(0x40000000);

  // Dark Mode
  static const Color darkBgPrimary = Color(0xFF0F0F12);
  static const Color darkBgSecondary = Color(0xFF1A1A20);
  static const Color darkBgTertiary = Color(0xFF242430);
  static const Color darkAccentDeep = Color(0xFFE8C46A);
  static const Color darkAccentSoft = Color(0xFF2A2010);
  static const Color darkTextPrimary = Color(0xFFF4F4F5);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkTextTertiary = Color(0xFF52525B);
  static const Color darkTextOnAccent = Color(0xFF18181B);
  static const Color darkDivider = Color(0xFF27272A);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE8C46A), Color(0xFFC9A84C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
