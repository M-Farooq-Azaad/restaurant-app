import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgTertiary;
  final Color accent;
  final Color accentSoft;
  final Color accentDeep;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnAccent;
  final Color divider;
  final Color error;
  final Color success;

  const AppColorsExtension({
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgTertiary,
    required this.accent,
    required this.accentSoft,
    required this.accentDeep,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnAccent,
    required this.divider,
    required this.error,
    required this.success,
  });

  static const light = AppColorsExtension(
    bgPrimary: AppColors.bgPrimary,
    bgSecondary: AppColors.bgSecondary,
    bgTertiary: AppColors.bgTertiary,
    accent: AppColors.accent,
    accentSoft: AppColors.accentSoft,
    accentDeep: AppColors.accentDeep,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textTertiary: AppColors.textTertiary,
    textOnAccent: AppColors.textOnAccent,
    divider: AppColors.divider,
    error: AppColors.error,
    success: AppColors.success,
  );

  static const dark = AppColorsExtension(
    bgPrimary: AppColors.darkBgPrimary,
    bgSecondary: AppColors.darkBgSecondary,
    bgTertiary: AppColors.darkBgTertiary,
    accent: AppColors.accent,
    accentSoft: AppColors.darkAccentSoft,
    accentDeep: AppColors.darkAccentDeep,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textTertiary: AppColors.darkTextTertiary,
    textOnAccent: AppColors.darkTextOnAccent,
    divider: AppColors.darkDivider,
    error: Color(0xFFDC2626),
    success: Color(0xFF16A34A),
  );

  @override
  AppColorsExtension copyWith({
    Color? bgPrimary, Color? bgSecondary, Color? bgTertiary,
    Color? accent, Color? accentSoft, Color? accentDeep,
    Color? textPrimary, Color? textSecondary, Color? textTertiary,
    Color? textOnAccent, Color? divider, Color? error, Color? success,
  }) {
    return AppColorsExtension(
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgTertiary: bgTertiary ?? this.bgTertiary,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      accentDeep: accentDeep ?? this.accentDeep,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      divider: divider ?? this.divider,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other == null) return this;
    return AppColorsExtension(
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t)!,
      bgTertiary: Color.lerp(bgTertiary, other.bgTertiary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      accentDeep: Color.lerp(accentDeep, other.accentDeep, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textOnAccent: Color.lerp(textOnAccent, other.textOnAccent, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColorsExtension get colors => Theme.of(this).extension<AppColorsExtension>()!;
}
