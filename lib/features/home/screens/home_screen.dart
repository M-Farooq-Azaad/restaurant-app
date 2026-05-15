import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';
import '../widgets/gamification_card.dart';
import '../widgets/loyalty_card.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/quick_actions_row.dart';
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
          _PlaceholderTab(label: 'Menu', emoji: '🍽️'),
          _PlaceholderTab(label: 'Cart', emoji: '🛒'),
          _PlaceholderTab(label: 'Loyalty', emoji: '⭐'),
          _PlaceholderTab(label: 'Profile', emoji: '👤'),
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
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
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: Colors.transparent,
        indicatorColor: AppColors.accentSoft,
        shadowColor: Colors.transparent,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: colors.accent),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.restaurant_menu_outlined),
            selectedIcon:
                Icon(Icons.restaurant_menu_rounded, color: colors.accent),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_bag_outlined),
            selectedIcon:
                Icon(Icons.shopping_bag_rounded, color: colors.accent),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: const Icon(Icons.stars_outlined),
            selectedIcon: Icon(Icons.stars_rounded, color: colors.accent),
            label: 'Loyalty',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: colors.accent),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

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

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          toolbarHeight: 64,
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
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search_rounded, color: colors.textPrimary),
            ),
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
            const SizedBox(width: Sp.xs),
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Sp.md),
              const LoyaltyCard(user: MockData.currentUser),
              const SizedBox(height: Sp.xl),
              const QuickActionsRow(),
              const SizedBox(height: Sp.xl),
              const PromoCarousel(),
              const SizedBox(height: Sp.xl),
              SectionHeader(title: "Today's Picks", onSeeAll: () {}),
              const SizedBox(height: Sp.md),
              SizedBox(
                height: 270,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: Sp.base),
                  itemCount: todaysPicks.length,
                  itemBuilder: (_, i) => MenuItemCard(item: todaysPicks[i]),
                ),
              ),
              const SizedBox(height: Sp.xl),
              SectionHeader(title: 'Best Sellers', onSeeAll: () {}),
              const SizedBox(height: Sp.md),
              SizedBox(
                height: 270,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: Sp.base),
                  itemCount: bestSellers.length,
                  itemBuilder: (_, i) => MenuItemCard(item: bestSellers[i]),
                ),
              ),
              const SizedBox(height: Sp.xl),
              const GamificationCard(),
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
