import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';
import '../../loyalty/screens/loyalty_screen.dart';
import '../../menu/screens/menu_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../widgets/active_coupons_section.dart';
import '../widgets/active_missions_card.dart';
import '../widgets/category_chips_row.dart';
import '../widgets/loyalty_card.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/recent_orders_section.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          MenuScreen(),
          _PlaceholderTab(label: 'Cart', emoji: '🛒'),
          LoyaltyScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) {
          HapticFeedback.selectionClick();
          setState(() => _currentIndex = i);
        },
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  static const _icons = [
    (Icons.storefront_outlined, Icons.storefront_rounded),
    (Icons.menu_book_outlined, Icons.menu_book_rounded),
    (Icons.shopping_cart_outlined, Icons.shopping_cart_rounded),
    (Icons.workspace_premium_outlined, Icons.workspace_premium_rounded),
    (Icons.account_circle_outlined, Icons.account_circle_rounded),
  ];

  static const _labels = ['Home', 'Menu', 'Cart', 'Rewards', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.only(
        left: Sp.xl,
        right: Sp.xl,
        bottom: MediaQuery.of(context).padding.bottom + Sp.xs,
        top: Sp.sm,
      ),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: BorderRadius.circular(Rd.xxl),
          border: Border.all(color: colors.divider, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: List.generate(
            _labels.length,
            (i) => _NavItem(
              icon: _icons[i].$1,
              selectedIcon: _icons[i].$2,
              label: _labels[i],
              isSelected: currentIndex == i,
              onTap: () => onTap(i),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeInOut,
              width: isSelected ? 48 : 36,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentSoft : Colors.transparent,
                borderRadius: BorderRadius.circular(Rd.lg),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, anim) => ScaleTransition(
                    scale: anim,
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: Icon(
                    isSelected ? selectedIcon : icon,
                    key: ValueKey(isSelected),
                    size: isSelected ? 22 : 20,
                    color: isSelected
                        ? AppColors.accentDeep
                        : colors.textTertiary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.labelSm.copyWith(
                color:
                    isSelected ? AppColors.accentDeep : colors.textTertiary,
                fontSize: 10,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 0.2,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Home Tab ──────────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const user = MockData.currentUser;
    final todaysPicks = MockData.todaysPicks;
    final bestSellers = MockData.bestSellers;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    // Personalized subtitle
    const platinumThreshold = 4000;
    final remaining = platinumThreshold - user.totalPoints;
    final subtitle = '$remaining pts away from Platinum ✨';

    final initials = user.fullName
        .trim()
        .split(' ')
        .take(2)
        .map((p) => p[0])
        .join()
        .toUpperCase();

    return CustomScrollView(
      slivers: [
        // ── App Bar ──────────────────────────────────────────────────────
        SliverAppBar(
          floating: true,
          snap: true,
          toolbarHeight: 72,
          backgroundColor: colors.bgPrimary,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleSpacing: Sp.base,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: AppTextStyles.bodySm.copyWith(
                  color: colors.textTertiary,
                ),
              ),
              Text(
                user.fullName.split(' ').first,
                style: AppTextStyles.cardTitle.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.accentDeep,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: colors.textPrimary,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: Sp.md),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: AppTextStyles.labelMd.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Sp.md),

              // ── Search Bar ────────────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Sp.base),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.bgSecondary,
                      borderRadius: BorderRadius.circular(Rd.pill),
                      border: Border.all(color: colors.divider),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: Sp.base),
                        Icon(Icons.search_rounded,
                            color: colors.textTertiary, size: 20),
                        const SizedBox(width: Sp.sm),
                        Expanded(
                          child: Text(
                            'Search meals, drinks, desserts…',
                            style: AppTextStyles.bodyMd
                                .copyWith(color: colors.textTertiary),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: Sp.sm, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft,
                            borderRadius: BorderRadius.circular(Rd.lg),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.tune_rounded,
                                  size: 13,
                                  color: AppColors.accentDeep),
                              const SizedBox(width: 3),
                              Text(
                                'Filter',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.accentDeep,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Sp.lg),

              // ── Loyalty Wallet Card ───────────────────────────────────
              const LoyaltyCard(user: MockData.currentUser),
              const SizedBox(height: Sp.xl),

              // ── Category Chips ────────────────────────────────────────
              const CategoryChipsRow(),
              const SizedBox(height: Sp.xl),

              // ── Quick Actions ─────────────────────────────────────────
              const QuickActionsRow(),
              const SizedBox(height: Sp.xl),

              // ── Promo Carousel ────────────────────────────────────────
              const PromoCarousel(),
              const SizedBox(height: Sp.xl),

              // ── Active Missions ───────────────────────────────────────
              const ActiveMissionsCard(),
              const SizedBox(height: Sp.xl),

              // ── Today's Picks ─────────────────────────────────────────
              SectionHeader(title: "Today's Picks", onSeeAll: () {}),
              const SizedBox(height: Sp.md),
              SizedBox(
                height: 290,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: Sp.base),
                  itemCount: todaysPicks.length,
                  itemBuilder: (_, i) =>
                      MenuItemCard(item: todaysPicks[i]),
                ),
              ),
              const SizedBox(height: Sp.xl),

              // ── Best Sellers ──────────────────────────────────────────
              SectionHeader(title: 'Best Sellers', onSeeAll: () {}),
              const SizedBox(height: Sp.md),
              SizedBox(
                height: 290,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: Sp.base),
                  itemCount: bestSellers.length,
                  itemBuilder: (_, i) =>
                      MenuItemCard(item: bestSellers[i]),
                ),
              ),
              const SizedBox(height: Sp.xl),

              // ── Recent Orders ─────────────────────────────────────────
              const RecentOrdersSection(),
              const SizedBox(height: Sp.xl),

              // ── Active Coupons ────────────────────────────────────────
              const ActiveCouponsSection(),
              const SizedBox(height: Sp.xxxl),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String label;
  final String emoji;

  const _PlaceholderTab({required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: Sp.base),
            Text(
              '$label — coming soon',
              style: AppTextStyles.cardTitle.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
