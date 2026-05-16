import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';
import '../../menu/screens/item_detail_screen.dart';

class MenuItemCard extends StatefulWidget {
  final MenuItem item;

  const MenuItemCard({super.key, required this.item});

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final item = widget.item;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
      ),
      child: Container(
        width: 172,
        margin: const EdgeInsets.only(right: Sp.md),
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: BorderRadius.circular(Rd.xl),
          border: Border.all(color: colors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image area ──────────────────────────────────────
            SizedBox(
              height: 130,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colors.bgTertiary,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(Rd.xl),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        item.emoji,
                        style: const TextStyle(fontSize: 58),
                      ),
                    ),
                  ),
                  if (item.isBestSeller || item.isNew || item.isPopular)
                    Positioned(
                      top: Sp.sm,
                      left: Sp.sm,
                      child: _Badge(item: item),
                    ),
                  Positioned(
                    top: Sp.xs,
                    right: Sp.xs,
                    child: GestureDetector(
                      onTap: () => setState(() => _liked = !_liked),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: _liked
                              ? AppColors.error.withValues(alpha: 0.15)
                              : colors.bgSecondary.withValues(alpha: 0.90),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _liked
                                ? AppColors.error.withValues(alpha: 0.40)
                                : colors.divider,
                            width: 0.8,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            _liked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 15,
                            color: _liked
                                ? AppColors.error
                                : colors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ──────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Sp.md, Sp.md, Sp.md, Sp.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.itemTitle.copyWith(
                        color: colors.textPrimary,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.description,
                      style: AppTextStyles.bodySm.copyWith(
                        color: colors.textTertiary,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // ── Time + Rating ──
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 11, color: colors.textTertiary),
                        const SizedBox(width: 3),
                        Text(
                          '${item.prepTimeMinutes} min',
                          style: AppTextStyles.labelSm.copyWith(
                            color: colors.textTertiary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: Sp.sm),
                        const Icon(Icons.star_rounded,
                            size: 11, color: AppColors.accent),
                        const SizedBox(width: 3),
                        Text(
                          item.rating.toString(),
                          style: AppTextStyles.labelSm.copyWith(
                            color: colors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sp.sm),
                    // ── Price + Add ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: AppTextStyles.price.copyWith(
                            color: colors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                        const _AddButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
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
          fontWeight: FontWeight.w700,
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
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(Rd.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.30),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.add_rounded, size: 18, color: Colors.white),
      ),
    );
  }
}
