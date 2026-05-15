import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';
import '../widgets/menu_grid_card.dart';
import '../widgets/menu_list_tile.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? _selectedCategoryId;
  bool _isGridView = true;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MenuItem> get _filteredItems {
    var items = MockData.menuItems.toList();
    if (_selectedCategoryId != null) {
      items = items.where((i) => i.categoryId == _selectedCategoryId).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      items = items
          .where(
            (i) =>
                i.name.toLowerCase().contains(q) ||
                i.description.toLowerCase().contains(q),
          )
          .toList();
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Sp.base, Sp.base, Sp.sm, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Menu',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: colors.textPrimary,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      setState(() => _isGridView = !_isGridView);
                    },
                    icon: Icon(
                      _isGridView
                          ? Icons.view_list_rounded
                          : Icons.grid_view_rounded,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sp.base,
                vertical: Sp.sm,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: AppTextStyles.bodyLg.copyWith(
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search dishes...',
                  hintStyle: AppTextStyles.bodyLg.copyWith(
                    color: colors.textTertiary,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: colors.textTertiary,
                    size: 20,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: colors.textTertiary,
                            size: 18,
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor: colors.bgSecondary,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Sp.base,
                    vertical: Sp.md,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Rd.xl),
                    borderSide: BorderSide(color: colors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Rd.xl),
                    borderSide: BorderSide(color: colors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Rd.xl),
                    borderSide: const BorderSide(
                      color: AppColors.accent,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: Sp.base),
                itemCount: MockData.categories.length + 1,
                itemBuilder: (_, i) {
                  final isAll = i == 0;
                  final category =
                      isAll ? null : MockData.categories[i - 1];
                  final isSelected = isAll
                      ? _selectedCategoryId == null
                      : _selectedCategoryId == category!.id;

                  return Padding(
                    padding: const EdgeInsets.only(right: Sp.sm),
                    child: _CategoryChip(
                      label: isAll
                          ? 'All'
                          : '${category!.emoji} ${category.name}',
                      isSelected: isSelected,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(
                          () => _selectedCategoryId =
                              isAll ? null : category!.id,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: Sp.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sp.base),
              child: Text(
                '${items.length} ${items.length == 1 ? 'dish' : 'dishes'}',
                style: AppTextStyles.bodyMd.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ),
            const SizedBox(height: Sp.sm),
            Expanded(
              child: items.isEmpty
                  ? const _EmptyState()
                  : _isGridView
                      ? _GridContent(items: items)
                      : _ListContent(items: items),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: Sp.md,
          vertical: Sp.xs,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.goldGradient : null,
          color: isSelected ? null : colors.bgSecondary,
          borderRadius: BorderRadius.circular(Rd.pill),
          border: Border.all(
            color: isSelected ? AppColors.accent : colors.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMd.copyWith(
            color: isSelected ? Colors.white : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _GridContent extends StatelessWidget {
  final List<MenuItem> items;

  const _GridContent({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        Sp.base,
        0,
        Sp.base,
        Sp.xxxl,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Sp.md,
        mainAxisSpacing: Sp.md,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => MenuGridCard(item: items[i]),
    );
  }
}

class _ListContent extends StatelessWidget {
  final List<MenuItem> items;

  const _ListContent({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(Sp.base, 0, Sp.base, Sp.xxxl),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: Sp.sm),
      itemBuilder: (_, i) => MenuListTile(item: items[i]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🍽️', style: TextStyle(fontSize: 48)),
          const SizedBox(height: Sp.base),
          Text(
            'No dishes found',
            style: AppTextStyles.cardTitle.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: Sp.xs),
          Text(
            'Try a different search or category',
            style: AppTextStyles.bodyMd.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}
