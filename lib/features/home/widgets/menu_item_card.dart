import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const MenuItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: Sp.md),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xl),
        border: Border.all(color: colors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 112,
            decoration: BoxDecoration(
              color: colors.bgTertiary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Rd.xl),
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: SizedBox(),
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 52),
                    ),
                  ),
                ),
                if (item.isBestSeller || item.isNew || item.isPopular)
                  Positioned(
                    top: Sp.xs,
                    left: Sp.xs,
                    child: _Badge(item: item),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Sp.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.itemTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: AppTextStyles.bodySm.copyWith(
                    color: colors.textTertiary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Sp.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: AppTextStyles.price.copyWith(
                        color: colors.accent,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          item.rating.toString(),
                          style: AppTextStyles.labelSm.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: Sp.sm),
                const _AddButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final MenuItem item;

  const _Badge({required this.item});

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;

    if (item.isBestSeller) {
      label = 'Best Seller';
      color = AppColors.accentDeep;
    } else if (item.isNew) {
      label = 'New';
      color = AppColors.success;
    } else {
      label = 'Popular';
      color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Rd.sm),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(
          color: Colors.white,
          fontSize: 9,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(Rd.pill),
      ),
      child: const Center(
        child: Icon(Icons.add_rounded, size: 18, color: Colors.white),
      ),
    );
  }
}
