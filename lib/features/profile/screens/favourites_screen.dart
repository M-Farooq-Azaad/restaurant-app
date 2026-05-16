import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';

// ── Category accent colors ────────────────────────────────────────────────────

const _catColors = {
  'cat_burgers': Color(0xFFFF6B35),
  'cat_pizza': Color(0xFFE63946),
  'cat_pasta': Color(0xFFF59E0B),
  'cat_salads': Color(0xFF22C55E),
  'cat_desserts': Color(0xFFEC4899),
  'cat_drinks': Color(0xFF0EA5E9),
};

// ── Screen ────────────────────────────────────────────────────────────────────

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  String? _selectedCategoryId;
  late List<MenuItem> _favourites;

  @override
  void initState() {
    super.initState();
    const favIds = {
      'item_008', // Double Smash Burger
      'item_107', // Wagyu Beef Burger
      'item_204', // Prosciutto & Arugula
      'item_002', // Truffle Margherita
      'item_303', // Seafood Linguine
      'item_306', // Truffle Tagliatelle
      'item_004', // Grilled Salmon Bowl
      'item_005', // Lava Chocolate Cake
      'item_502', // Tiramisu
      'item_601', // Espresso Martini
      'item_603', // Matcha Latte
    };
    _favourites =
        MockData.menuItems.where((i) => favIds.contains(i.id)).toList();
  }

  List<MenuItem> get _filtered {
    if (_selectedCategoryId == null) return _favourites;
    return _favourites
        .where((i) => i.categoryId == _selectedCategoryId)
        .toList();
  }

  List<MenuCategory> get _presentCategories {
    final catIds = _favourites.map((i) => i.categoryId).toSet();
    return MockData.categories.where((c) => catIds.contains(c.id)).toList();
  }

  MenuCategory? _categoryFor(String categoryId) {
    try {
      return MockData.categories.firstWhere((c) => c.id == categoryId);
    } catch (_) {
      return null;
    }
  }

  void _remove(MenuItem item) {
    final index = _favourites.indexOf(item);
    HapticFeedback.mediumImpact();
    setState(() => _favourites.remove(item));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} removed from favourites'),
        backgroundColor: AppColors.accentDeep,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rd.lg),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            if (mounted) {
              setState(() {
                final i = index.clamp(0, _favourites.length);
                _favourites.insert(i, item);
              });
            }
          },
        ),
      ),
    );
  }

  void _addToCart(MenuItem item) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        backgroundColor: AppColors.accentDeep,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rd.lg),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final filtered = _filtered;
    final categories = _presentCategories;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          // ── App bar ──
          SliverAppBar(
            pinned: true,
            toolbarHeight: 64,
            backgroundColor: const Color(0xFF1C1400),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Row(
              children: [
                Text(
                  'Favourites',
                  style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
                ),
                const SizedBox(width: Sp.sm),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    key: ValueKey(_favourites.length),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(Rd.pill),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.40),
                      ),
                    ),
                    child: Text(
                      '${_favourites.length}',
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            centerTitle: false,
          ),

          // ── Category filter ──
          SliverPersistentHeader(
            pinned: true,
            delegate: _CategoryFilterDelegate(
              selectedId: _selectedCategoryId,
              categories: categories,
              counts: {
                null: _favourites.length,
                for (final c in categories)
                  c.id: _favourites
                      .where((i) => i.categoryId == c.id)
                      .length,
              },
              onChanged: (id) {
                HapticFeedback.selectionClick();
                setState(() => _selectedCategoryId = id);
              },
              bgColor: colors.bgPrimary,
              dividerColor: colors.divider,
            ),
          ),

          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(hasAnyFavourites: _favourites.isNotEmpty),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                Sp.base,
                Sp.md,
                Sp.base,
                MediaQuery.of(context).padding.bottom + Sp.xl,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final item = filtered[i];
                    final cat = _categoryFor(item.categoryId);
                    final catColor =
                        _catColors[item.categoryId] ?? AppColors.accent;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Sp.md),
                      child: _FavouriteCard(
                        item: item,
                        category: cat,
                        catColor: catColor,
                        onRemove: () => _remove(item),
                        onAddToCart: () => _addToCart(item),
                      ),
                    );
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Category filter delegate ──────────────────────────────────────────────────

class _CategoryFilterDelegate extends SliverPersistentHeaderDelegate {
  final String? selectedId;
  final List<MenuCategory> categories;
  final Map<String?, int> counts;
  final ValueChanged<String?> onChanged;
  final Color bgColor;
  final Color dividerColor;

  _CategoryFilterDelegate({
    required this.selectedId,
    required this.categories,
    required this.counts,
    required this.onChanged,
    required this.bgColor,
    required this.dividerColor,
  });

  @override
  double get minExtent => 56;
  @override
  double get maxExtent => 56;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colors = context.colors;
    return Container(
      color: bgColor,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: Sp.base,
                vertical: Sp.sm,
              ),
              children: [
                _FilterChip(
                  label: 'All',
                  count: counts[null] ?? 0,
                  isSelected: selectedId == null,
                  onTap: () => onChanged(null),
                  colors: colors,
                  dividerColor: dividerColor,
                ),
                ...categories.map(
                  (cat) => _FilterChip(
                    label: cat.name,
                    emoji: cat.emoji,
                    count: counts[cat.id] ?? 0,
                    isSelected: selectedId == cat.id,
                    onTap: () => onChanged(cat.id),
                    colors: colors,
                    dividerColor: dividerColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: dividerColor),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_CategoryFilterDelegate old) =>
      old.selectedId != selectedId ||
      old.categories != categories ||
      old.counts != counts ||
      old.bgColor != bgColor;
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String? emoji;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final AppColorsExtension colors;
  final Color dividerColor;

  const _FilterChip({
    required this.label,
    this.emoji,
    required this.count,
    required this.isSelected,
    required this.onTap,
    required this.colors,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Sp.sm),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: Sp.md,
            vertical: Sp.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentDeep : colors.bgSecondary,
            borderRadius: BorderRadius.circular(Rd.pill),
            border: Border.all(
              color: isSelected ? AppColors.accentDeep : dividerColor,
              width: 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accentDeep.withValues(alpha: 0.22),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (emoji != null) ...[
                Text(emoji!, style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: AppTextStyles.labelSm.copyWith(
                  color: isSelected ? Colors.white : colors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.20)
                      : colors.bgTertiary,
                  borderRadius: BorderRadius.circular(Rd.pill),
                ),
                child: Text(
                  '$count',
                  style: AppTextStyles.labelSm.copyWith(
                    color: isSelected ? Colors.white : colors.textTertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Favourite card ────────────────────────────────────────────────────────────

class _FavouriteCard extends StatelessWidget {
  final MenuItem item;
  final MenuCategory? category;
  final Color catColor;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const _FavouriteCard({
    required this.item,
    required this.category,
    required this.catColor,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xl),
        border: Border.all(color: colors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Rd.xl),
        child: Column(
          children: [
            // ── Body ──
            Padding(
              padding: const EdgeInsets.all(Sp.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emoji box with category color tint
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(Rd.lg),
                      border: Border.all(
                        color: catColor.withValues(alpha: 0.18),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        item.emoji,
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                  const SizedBox(width: Sp.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: AppTextStyles.bodyLg.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: Sp.xs),
                            // Remove from favourites
                            GestureDetector(
                              onTap: onRemove,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.error.withValues(alpha: 0.09),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.favorite_rounded,
                                  size: 16,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySm.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: Sp.sm),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              item.rating.toStringAsFixed(1),
                              style: AppTextStyles.bodySm.copyWith(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '  (${item.reviewCount})',
                              style: AppTextStyles.bodySm.copyWith(
                                color: colors.textTertiary,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.timer_outlined,
                              size: 12,
                              color: colors.textTertiary,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${item.prepTimeMinutes} min',
                              style: AppTextStyles.bodySm.copyWith(
                                color: colors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Footer ──
            Container(
              padding: const EdgeInsets.fromLTRB(Sp.md, Sp.sm, Sp.md, Sp.md),
              color: AppColors.accentSoft,
              child: Row(
                children: [
                  // Category chip
                  if (category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sp.sm,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(Rd.pill),
                        border: Border.all(
                          color: catColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            category!.emoji,
                            style: const TextStyle(fontSize: 11),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category!.name,
                            style: AppTextStyles.labelSm.copyWith(
                              color: catColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.accentDeep,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: Sp.sm),
                  // Add to cart button
                  GestureDetector(
                    onTap: onAddToCart,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sp.md,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentDeep,
                        borderRadius: BorderRadius.circular(Rd.pill),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentDeep.withValues(alpha: 0.28),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Add to Cart',
                            style: AppTextStyles.labelSm.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool hasAnyFavourites;
  const _EmptyState({required this.hasAnyFavourites});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final emoji = hasAnyFavourites ? '🔍' : '💔';
    final title =
        hasAnyFavourites ? 'No Items Here' : 'No Favourites Yet';
    final subtitle = hasAnyFavourites
        ? 'No saved items in this category.'
        : 'Tap the heart on any menu item to save it here.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sp.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.bgSecondary,
                shape: BoxShape.circle,
                border: Border.all(color: colors.divider),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(height: Sp.xl),
            Text(
              title,
              style: AppTextStyles.cardTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: Sp.sm),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
