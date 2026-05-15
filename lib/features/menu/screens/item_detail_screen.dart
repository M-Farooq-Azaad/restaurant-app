import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';

class ItemDetailScreen extends StatefulWidget {
  final MenuItem item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _quantity = 1;
  bool _isFavorite = false;

  MenuItem get item => widget.item;
  double get _total => item.price * _quantity;

  String get _categoryName {
    final cat = MockData.categories.firstWhere(
      (c) => c.id == item.categoryId,
      orElse: () => const MenuCategory(id: '', name: 'Food', emoji: '🍽️'),
    );
    return '${cat.emoji} ${cat.name}';
  }

  int get _mockCalories {
    if (item.price < 8) return 220;
    if (item.price < 12) return 350;
    if (item.price < 16) return 480;
    if (item.price < 20) return 620;
    if (item.price < 25) return 750;
    return 900;
  }

  List<MenuItem> get _relatedItems => MockData.menuItems
      .where((i) => i.categoryId == item.categoryId && i.id != item.id)
      .take(6)
      .toList();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          _HeroAppBar(
            item: item,
            isFavorite: _isFavorite,
            onFavoriteTap: () {
              HapticFeedback.lightImpact();
              setState(() => _isFavorite = !_isFavorite);
            },
          ),
          SliverToBoxAdapter(child: _buildBody(colors)),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(colors),
    );
  }

  Widget _buildBody(AppColorsExtension colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sp.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Sp.base),
          if (item.isBestSeller || item.isNew || item.isPopular) ...[
            _DetailBadge(item: item),
            const SizedBox(height: Sp.sm),
          ],
          Text(
            item.name,
            style: AppTextStyles.sectionTitle.copyWith(color: colors.textPrimary),
          ).animate().fadeIn(duration: 300.ms, delay: 80.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: Sp.sm),
          _StatsRow(item: item, categoryName: _categoryName),
          const SizedBox(height: Sp.base),
          Divider(color: colors.divider, height: 1),
          const SizedBox(height: Sp.base),
          Text(
            'About this dish',
            style: AppTextStyles.itemTitle.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: Sp.xs),
          Text(
            item.description,
            style: AppTextStyles.bodyLg.copyWith(
              color: colors.textSecondary,
              height: 1.6,
            ),
          ).animate().fadeIn(duration: 300.ms, delay: 160.ms),
          const SizedBox(height: Sp.base),
          Row(
            children: [
              _HighlightChip(
                icon: Icons.local_fire_department_rounded,
                label: '~$_mockCalories cal',
              ),
              const SizedBox(width: Sp.sm),
              const _HighlightChip(
                icon: Icons.person_rounded,
                label: 'Serves 1',
              ),
              const SizedBox(width: Sp.sm),
              const _HighlightChip(
                icon: Icons.eco_rounded,
                label: 'Fresh daily',
              ),
            ],
          ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
          if (_relatedItems.isNotEmpty) ...[
            const SizedBox(height: Sp.xl),
            Divider(color: colors.divider, height: 1),
            const SizedBox(height: Sp.base),
            Text(
              'You might also like',
              style: AppTextStyles.itemTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: Sp.md),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _relatedItems.length,
                itemBuilder: (_, i) {
                  final related = _relatedItems[i];
                  return GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItemDetailScreen(item: related),
                      ),
                    ),
                    child: _RelatedItemCard(item: related),
                  )
                      .animate()
                      .fadeIn(
                        duration: 280.ms,
                        delay: Duration(
                          milliseconds: (i * 60).clamp(0, 240),
                        ),
                      )
                      .slideX(
                        begin: 0.05,
                        end: 0,
                        duration: 280.ms,
                        delay: Duration(
                          milliseconds: (i * 60).clamp(0, 240),
                        ),
                      );
                },
              ),
            ),
          ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBottomBar(AppColorsExtension colors) {
    return Container(
      padding: EdgeInsets.only(
        left: Sp.base,
        right: Sp.base,
        top: Sp.md,
        bottom: MediaQuery.of(context).padding.bottom + Sp.md,
      ),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        border: Border(top: BorderSide(color: colors.divider, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          _QuantitySelector(
            quantity: _quantity,
            onDecrement: () {
              if (_quantity > 1) {
                HapticFeedback.lightImpact();
                setState(() => _quantity--);
              }
            },
            onIncrement: () {
              HapticFeedback.lightImpact();
              setState(() => _quantity++);
            },
          ),
          const SizedBox(width: Sp.md),
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${item.name} added to cart',
                      style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppColors.accentDeep,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Rd.lg),
                    ),
                  ),
                );
              },
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(Rd.xl),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: Sp.sm),
                    Text(
                      'Add to Cart  •  \$${_total.toStringAsFixed(2)}',
                      style: AppTextStyles.labelLg.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _HeroAppBar extends StatelessWidget {
  final MenuItem item;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const _HeroAppBar({
    required this.item,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: colors.bgPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.all(Sp.sm),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: colors.bgSecondary.withValues(alpha: 0.92),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: colors.textPrimary,
              size: 20,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: Sp.base, top: Sp.sm, bottom: Sp.sm),
          child: GestureDetector(
            onTap: onFavoriteTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.bgSecondary.withValues(alpha: 0.92),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFavorite ? AppColors.error : colors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: colors.bgTertiary,
              child: Center(
                child: Text(
                  item.emoji,
                  style: const TextStyle(fontSize: 110),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      colors.bgPrimary.withValues(alpha: 0.75),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final MenuItem item;
  final String categoryName;

  const _StatsRow({required this.item, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 15, color: AppColors.accent),
        const SizedBox(width: 3),
        Text(
          '${item.rating}',
          style: AppTextStyles.labelMd.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '  (${item.reviewCount} reviews)',
          style: AppTextStyles.bodyMd.copyWith(color: colors.textSecondary),
        ),
        const Spacer(),
        Icon(Icons.schedule_rounded, size: 14, color: colors.textTertiary),
        const SizedBox(width: 3),
        Text(
          '${item.prepTimeMinutes} min',
          style: AppTextStyles.bodyMd.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(width: Sp.md),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sp.sm,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.accentSoft,
            borderRadius: BorderRadius.circular(Rd.pill),
          ),
          child: Text(
            categoryName,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.accentDeep,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 120.ms);
  }
}

class _DetailBadge extends StatelessWidget {
  final MenuItem item;

  const _DetailBadge({required this.item});

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color bg;

    if (item.isBestSeller) {
      label = '🏆 Best Seller';
      bg = AppColors.accentDeep;
    } else if (item.isNew) {
      label = '✨ New';
      bg = AppColors.success;
    } else {
      label = '🔥 Popular';
      bg = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sp.sm, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Rd.sm),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 250.ms, delay: 40.ms)
        .scale(begin: const Offset(0.9, 0.9));
  }
}

class _HighlightChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HighlightChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sp.md, vertical: Sp.sm),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.lg),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelMd.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _RelatedItemCard extends StatelessWidget {
  final MenuItem item;

  const _RelatedItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: Sp.md),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.lg),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: Sp.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sp.xs),
            child: Text(
              item.name,
              style: AppTextStyles.bodySm.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '\$${item.price.toStringAsFixed(0)}',
            style: AppTextStyles.labelSm.copyWith(
              color: colors.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantitySelector({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgTertiary,
        borderRadius: BorderRadius.circular(Rd.lg),
      ),
      child: Row(
        children: [
          _QtyBtn(icon: Icons.remove_rounded, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sp.md),
            child: Text(
              '$quantity',
              style: AppTextStyles.cardTitle.copyWith(color: colors.textPrimary),
            ),
          ),
          _QtyBtn(icon: Icons.add_rounded, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: BorderRadius.circular(Rd.md),
        ),
        child: Icon(icon, size: 18, color: colors.textPrimary),
      ),
    );
  }
}
