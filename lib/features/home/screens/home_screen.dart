import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: Center(
        child: Text(
          'Home — coming soon',
          style: AppTextStyles.cardTitle.copyWith(color: colors.textSecondary),
        ),
      ),
    );
  }
}
