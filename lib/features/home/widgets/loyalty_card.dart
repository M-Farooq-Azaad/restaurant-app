import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../mock/mock_data.dart';

class LoyaltyCard extends StatelessWidget {
  final MockUser user;

  const LoyaltyCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const platinumThreshold = 4000;
    final progress = (user.totalPoints / platinumThreshold).clamp(0.0, 1.0);
    final remaining = platinumThreshold - user.totalPoints;
    final tierName = MockData.tierNames[user.tierId] ?? 'Bronze';
    final firstName = user.fullName.split(' ').first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sp.base),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1C1400), Color(0xFF3D2E00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(Rd.xxl),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.28),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            const Positioned(
              top: -30,
              right: -20,
              child: _GoldCircle(size: 140),
            ),
            const Positioned(
              bottom: -55,
              right: 90,
              child: _GoldCircle(size: 110),
            ),
            Padding(
              padding: const EdgeInsets.all(Sp.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $firstName!',
                            style: AppTextStyles.bodyMd.copyWith(
                              color: Colors.white60,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Loyalty Wallet',
                            style: AppTextStyles.cardTitle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      _TierBadge(tierName: tierName),
                    ],
                  ),
                  const SizedBox(height: Sp.xl),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${user.totalPoints}',
                        style: AppTextStyles.priceLg.copyWith(
                          fontSize: 44,
                          color: AppColors.accent,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(width: Sp.sm),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          'pts',
                          style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.accentSoft,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Sp.md),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Rd.pill),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accent,
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: Sp.xs),
                  Text(
                    remaining > 0
                        ? '$remaining pts to Platinum tier'
                        : 'Platinum tier reached! 🏆',
                    style: AppTextStyles.bodySm.copyWith(color: Colors.white54),
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

class _GoldCircle extends StatelessWidget {
  final double size;

  const _GoldCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent.withValues(alpha: 0.06),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.14),
          width: 1,
        ),
      ),
    );
  }
}

class _TierBadge extends StatelessWidget {
  final String tierName;

  const _TierBadge({required this.tierName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sp.md,
        vertical: Sp.xs,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(Rd.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars_rounded, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            tierName.toUpperCase(),
            style: AppTextStyles.labelSm.copyWith(
              color: Colors.white,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
