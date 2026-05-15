import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  int _filterVersion = 0;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Show categorised sections only when on "All" tab with no active search.
  bool get _showCategorized =>
      _selectedCategoryId == null && _searchQuery.isEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MenuItem> get _filteredItems {
    var items = MockData.menuItems.toList();
    if (_selectedCategoryId != null) {
      items =
          items.where((i) => i.categoryId == _selectedCategoryId).toList();
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

  void _onSearchChanged(String v) {
    setState(() {
      _searchQuery = v;
      _filterVersion++;
    });
  }

  void _onCategorySelected(String? categoryId) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedCategoryId = categoryId;
      _filterVersion++;
    });
  }

  void _onToggleView() {
    HapticFeedback.selectionClick();
    setState(() {
      _isGridView = !_isGridView;
      _filterVersion++;
    });
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
            // Header row
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(Sp.base, Sp.base, Sp.sm, 0),
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
                    onPressed: _onToggleView,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(
                        scale: animation,
                        child:
                            FadeTransition(opacity: animation, child: child),
                      ),
                      child: Icon(
                        _isGridView
                            ? Icons.view_list_rounded
                            : Icons.grid_view_rounded,
                        key: ValueKey(_isGridView),
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sp.base,
                vertical: Sp.sm,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style:
                    AppTextStyles.bodyLg.copyWith(color: colors.textPrimary),
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
                            _onSearchChanged('');
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
            // Category chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: Sp.base),
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
                      onTap: () => _onCategorySelected(
                        isAll ? null : category!.id,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: Sp.sm),
            // Result count — hidden in categorized view
            if (!_showCategorized)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Sp.base),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    '${items.length} ${items.length == 1 ? 'dish' : 'dishes'}',
                    key: ValueKey(items.length),
                    style: AppTextStyles.bodyMd.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ),
              ),
            if (!_showCategorized) const SizedBox(height: Sp.sm),
            // Content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: _showCategorized
                    ? _AllCategoriesContent(
                        key: ValueKey('all_${_isGridView}_$_filterVersion'),
                        isGridView: _isGridView,
                        filterVersion: _filterVersion,
                      )
                    : items.isEmpty
                        ? const _EmptyState(key: ValueKey('empty'))
                        : _isGridView
                            ? _GridContent(
                                key: ValueKey('grid_$_filterVersion'),
                                items: items,
                                filterVersion: _filterVersion,
                              )
                            : _ListContent(
                                key: ValueKey('list_$_filterVersion'),
                                items: items,
                                filterVersion: _filterVersion,
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Category chip ───────────────────────────────────────────────────────────

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

// ── Categorized "All" view ──────────────────────────────────────────────────

class _AllCategoriesContent extends StatelessWidget {
  final bool isGridView;
  final int filterVersion;

  const _AllCategoriesContent({
    super.key,
    required this.isGridView,
    required this.filterVersion,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final slivers = <Widget>[];

    for (int ci = 0; ci < MockData.categories.length; ci++) {
      final category = MockData.categories[ci];
      final items = MockData.menuItems
          .where((item) => item.categoryId == category.id)
          .toList();

      if (items.isEmpty) continue;

      // Section header
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              Sp.base,
              ci == 0 ? Sp.xs : Sp.xl,
              Sp.base,
              Sp.md,
            ),
            child: Row(
              children: [
                Text(
                  category.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: Sp.sm),
                Text(
                  category.name,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(width: Sp.xs),
                Text(
                  '(${items.length})',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(
                duration: 260.ms,
                delay: Duration(milliseconds: (ci * 60).clamp(0, 240)),
              )
              .slideX(
                begin: -0.03,
                end: 0,
                duration: 260.ms,
                delay: Duration(milliseconds: (ci * 60).clamp(0, 240)),
                curve: Curves.easeOut,
              ),
        ),
      );

      // Items grid or list
      if (isGridView) {
        slivers.add(
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: Sp.base),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: Sp.md,
                mainAxisSpacing: Sp.md,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => MenuGridCard(
                  key: ValueKey('${items[i].id}_$filterVersion'),
                  item: items[i],
                )
                    .animate()
                    .fadeIn(
                      duration: 280.ms,
                      delay: Duration(
                        milliseconds: (i * 45).clamp(0, 200),
                      ),
                      curve: Curves.easeOut,
                    )
                    .slideY(
                      begin: 0.06,
                      end: 0,
                      duration: 280.ms,
                      delay: Duration(
                        milliseconds: (i * 45).clamp(0, 200),
                      ),
                      curve: Curves.easeOut,
                    ),
                childCount: items.length,
              ),
            ),
          ),
        );
      } else {
        slivers.add(
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: Sp.base),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: EdgeInsets.only(
                    bottom: i < items.length - 1 ? Sp.sm : 0,
                  ),
                  child: MenuListTile(
                    key: ValueKey('${items[i].id}_$filterVersion'),
                    item: items[i],
                  )
                      .animate()
                      .fadeIn(
                        duration: 260.ms,
                        delay: Duration(
                          milliseconds: (i * 40).clamp(0, 200),
                        ),
                        curve: Curves.easeOut,
                      )
                      .slideX(
                        begin: -0.04,
                        end: 0,
                        duration: 260.ms,
                        delay: Duration(
                          milliseconds: (i * 40).clamp(0, 200),
                        ),
                        curve: Curves.easeOut,
                      ),
                ),
                childCount: items.length,
              ),
            ),
          ),
        );
      }
    }

    slivers.add(const SliverToBoxAdapter(child: SizedBox(height: Sp.xxxl)));

    return CustomScrollView(slivers: slivers);
  }
}

// ── Filtered flat views ─────────────────────────────────────────────────────

class _GridContent extends StatelessWidget {
  final List<MenuItem> items;
  final int filterVersion;

  const _GridContent({
    super.key,
    required this.items,
    required this.filterVersion,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding:
          const EdgeInsets.fromLTRB(Sp.base, 0, Sp.base, Sp.xxxl),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Sp.md,
        mainAxisSpacing: Sp.md,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => MenuGridCard(
        key: ValueKey('${items[i].id}_$filterVersion'),
        item: items[i],
      )
          .animate()
          .fadeIn(
            duration: 280.ms,
            delay: Duration(milliseconds: (i * 45).clamp(0, 200)),
            curve: Curves.easeOut,
          )
          .slideY(
            begin: 0.06,
            end: 0,
            duration: 280.ms,
            delay: Duration(milliseconds: (i * 45).clamp(0, 200)),
            curve: Curves.easeOut,
          ),
    );
  }
}

class _ListContent extends StatelessWidget {
  final List<MenuItem> items;
  final int filterVersion;

  const _ListContent({
    super.key,
    required this.items,
    required this.filterVersion,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding:
          const EdgeInsets.fromLTRB(Sp.base, 0, Sp.base, Sp.xxxl),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: Sp.sm),
      itemBuilder: (_, i) => MenuListTile(
        key: ValueKey('${items[i].id}_$filterVersion'),
        item: items[i],
      )
          .animate()
          .fadeIn(
            duration: 260.ms,
            delay: Duration(milliseconds: (i * 40).clamp(0, 200)),
            curve: Curves.easeOut,
          )
          .slideX(
            begin: -0.04,
            end: 0,
            duration: 260.ms,
            delay: Duration(milliseconds: (i * 40).clamp(0, 200)),
            curve: Curves.easeOut,
          ),
    );
  }
}

// ── Empty state ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});

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
            style: AppTextStyles.bodyMd.copyWith(
              color: colors.textTertiary,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, curve: Curves.easeOut)
        .scale(
          begin: const Offset(0.95, 0.95),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }
}
