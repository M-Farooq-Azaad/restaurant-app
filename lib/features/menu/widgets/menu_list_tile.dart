import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';
import '../screens/item_detail_screen.dart';

class MenuListTile extends StatelessWidget {
  final MenuItem item;

  const MenuListTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
      ),
      child: Container(
      padding: const EdgeInsets.all(Sp.md),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xl),
        border: Border.all(color: colors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: colors.bgTertiary,
              borderRadius: BorderRadius.circular(Rd.lg),
            ),
            child: Center(
              child: Text(item.emoji, style: const TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(width: Sp.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: AppTextStyles.itemTitle.copyWith(
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.isBestSeller || item.isNew || item.isPopular) ...[
                      const SizedBox(width: Sp.xs),
                      _InlineBadge(item: item),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  item.description,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: colors.textTertiary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Sp.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 13,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${item.rating} (${item.reviewCount})',
                      style: AppTextStyles.labelSm.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: Sp.sm),
                    Icon(
                      Icons.schedule_rounded,
                      size: 12,
                      color: colors.textTertiary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${item.prepTimeMinutes} min',
                      style: AppTextStyles.labelSm.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Sp.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: AppTextStyles.price.copyWith(color: colors.accent),
              ),
              const SizedBox(height: Sp.xs),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(Rd.md),
                ),
                child: const Center(
                  child: Icon(Icons.add_rounded, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}

class _InlineBadge extends StatelessWidget {
  final MenuItem item;

  const _InlineBadge({required this.item});

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;

    if (item.isBestSeller) {
      label = '🏆 Best';
      color = AppColors.accentDeep;
    } else if (item.isNew) {
      label = '✨ New';
      color = AppColors.success;
    } else {
      label = '🔥 Hot';
      color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Rd.sm),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(color: color, fontSize: 10),
      ),
    );
  }
}
