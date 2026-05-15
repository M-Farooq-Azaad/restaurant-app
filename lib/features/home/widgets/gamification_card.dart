import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';

class GamificationCard extends StatelessWidget {
  const GamificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const user = MockData.currentUser;
    const platinumThreshold = 4000;
    final pointsToNext = platinumThreshold - user.totalPoints;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sp.base),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Sp.xl),
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: BorderRadius.circular(Rd.xl),
          border: Border.all(color: AppColors.accentSoft),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(Rd.md),
              ),
              child: const Center(
                child: Text('🎯', style: TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: Sp.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You're so close!",
                    style: AppTextStyles.itemTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    pointsToNext > 0
                        ? '$pointsToNext pts away from Platinum 🏆'
                        : 'Platinum tier reached! 🏆',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: Sp.sm),
                  Text(
                    'Order more to earn faster →',
                    style: AppTextStyles.labelMd.copyWith(
                      color: colors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
