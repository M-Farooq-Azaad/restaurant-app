import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';

class ActiveMissionsCard extends StatelessWidget {
  const ActiveMissionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final missions = MockData.missions.take(2).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sp.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(Rd.sm),
                    ),
                    child: const Center(
                      child: Text('🎯', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: Sp.sm),
                  Text(
                    'Active Missions',
                    style: AppTextStyles.cardTitle
                        .copyWith(color: colors.textPrimary),
                  ),
                ],
              ),
              Text(
                'View all',
                style:
                    AppTextStyles.labelMd.copyWith(color: colors.accent),
              ),
            ],
          ),
          const SizedBox(height: Sp.md),
          Container(
            decoration: BoxDecoration(
              color: colors.bgSecondary,
              borderRadius: BorderRadius.circular(Rd.xl),
              border: Border.all(color: colors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: List.generate(missions.length, (i) {
                final m = missions[i];
                final progress = (m.current / m.target).clamp(0.0, 1.0);
                final isLast = i == missions.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Sp.base),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.accentSoft,
                              borderRadius: BorderRadius.circular(Rd.md),
                            ),
                            child: Center(
                              child: Text(
                                m.emoji,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          const SizedBox(width: Sp.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        m.title,
                                        style: AppTextStyles.itemTitle
                                            .copyWith(
                                                color: colors.textPrimary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Sp.sm, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.accentSoft,
                                        borderRadius:
                                            BorderRadius.circular(Rd.pill),
                                      ),
                                      child: Text(
                                        '+${m.rewardPoints} pts',
                                        style: AppTextStyles.labelSm
                                            .copyWith(
                                          color: AppColors.accentDeep,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${m.current} / ${m.target}  ·  ${m.subtitle}',
                                      style: AppTextStyles.bodySm.copyWith(
                                          color: colors.textTertiary),
                                    ),
                                    Text(
                                      '${(progress * 100).round()}%',
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: colors.accent,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: Sp.xs),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Rd.pill),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: colors.bgTertiary,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            AppColors.accent),
                                    minHeight: 5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        color: colors.divider,
                        indent: Sp.base,
                        endIndent: Sp.base,
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
