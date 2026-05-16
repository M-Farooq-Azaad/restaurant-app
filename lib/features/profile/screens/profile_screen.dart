import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../mock/mock_data.dart';
import '../../auth/providers/auth_provider.dart';
import 'edit_profile_screen.dart';
import 'language_screen.dart';
import 'payment_methods_screen.dart';
import 'saved_addresses_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    const user = MockData.currentUser;
    final isDark = ref.watch(themeProvider) == AppThemeMode.dark;
    final tierName = MockData.tierNames[user.tierId] ?? 'Bronze';

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ProfileHeader(user: user, tierName: tierName),
          ),
          SliverToBoxAdapter(
            child: _StatsRow(user: user, tierName: tierName),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Sp.base,
                Sp.xl,
                Sp.base,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Section(
                    title: 'Account',
                    items: [
                      _RowItem(
                        icon: Icons.person_outline_rounded,
                        label: 'Edit Profile',
                        iconColor: AppColors.accent,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        ),
                      ),
                      _RowItem(
                        icon: Icons.location_on_outlined,
                        label: 'Saved Addresses',
                        iconColor: AppColors.success,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SavedAddressesScreen(),
                          ),
                        ),
                      ),
                      _RowItem(
                        icon: Icons.credit_card_rounded,
                        label: 'Payment Methods',
                        iconColor: const Color(0xFF6366F1),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PaymentMethodsScreen(),
                          ),
                        ),
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: Sp.xl),
                  _Section(
                    title: 'Preferences',
                    items: [
                      _RowItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        iconColor: AppColors.warning,
                        trailing: _NotifBadge(),
                        onTap: () {},
                      ),
                      _DarkModeRow(isDark: isDark, ref: ref),
                      _RowItem(
                        icon: Icons.language_rounded,
                        label: 'Language',
                        iconColor: const Color(0xFF0EA5E9),
                        valueLabel: 'English',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LanguageScreen(),
                          ),
                        ),
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: Sp.xl),
                  _Section(
                    title: 'Activity',
                    items: [
                      _RowItem(
                        icon: Icons.receipt_long_outlined,
                        label: 'Order History',
                        iconColor: const Color(0xFF8B5CF6),
                        onTap: () {},
                      ),
                      _RowItem(
                        icon: Icons.favorite_outline_rounded,
                        label: 'Favourites',
                        iconColor: AppColors.error,
                        onTap: () {},
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: Sp.xl),
                  _Section(
                    title: 'Loyalty',
                    items: [
                      _RowItem(
                        icon: Icons.workspace_premium_outlined,
                        label: 'My Rewards',
                        iconColor: AppColors.accent,
                        onTap: () {},
                      ),
                      _RowItem(
                        icon: Icons.card_giftcard_rounded,
                        label: 'Referral Code',
                        iconColor: AppColors.success,
                        trailing: _ReferralChip(code: user.username.toUpperCase()),
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: user.username.toUpperCase()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Referral code copied!'),
                              backgroundColor: AppColors.accentDeep,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Rd.lg),
                              ),
                            ),
                          );
                        },
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: Sp.xl),
                  _Section(
                    title: 'Support',
                    items: [
                      _RowItem(
                        icon: Icons.help_outline_rounded,
                        label: 'Help Center',
                        iconColor: const Color(0xFF0EA5E9),
                        onTap: () {},
                      ),
                      _RowItem(
                        icon: Icons.info_outline_rounded,
                        label: 'About',
                        iconColor: colors.textTertiary,
                        valueLabel: 'v1.0.0',
                        onTap: () {},
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: Sp.xl),
                  _SignOutButton(
                    onConfirm: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) context.go('/auth/login');
                    },
                  ),
                  const SizedBox(height: Sp.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ──────────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final MockUser user;
  final String tierName;

  const _ProfileHeader({required this.user, required this.tierName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1C1400), Color(0xFF3D2E00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned(top: -50, right: -20, child: _GoldCircle(size: 180)),
          const Positioned(bottom: -30, left: -20, child: _GoldCircle(size: 120)),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Sp.base, Sp.md, Sp.base, Sp.xxl),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile',
                        style: AppTextStyles.cardTitle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.qr_code_rounded,
                          color: Colors.white70,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Sp.md),
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accent,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.40),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/avatar.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: Sp.md),
                  Text(
                    user.fullName,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    user.email,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: Sp.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sp.md,
                      vertical: Sp.xs,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(Rd.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${tierName.toUpperCase()} MEMBER',
                          style: AppTextStyles.labelSm.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final MockUser user;
  final String tierName;

  const _StatsRow({required this.user, required this.tierName});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.fromLTRB(Sp.base, Sp.xl, Sp.base, 0),
      padding: const EdgeInsets.symmetric(vertical: Sp.base),
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
      child: Row(
        children: [
          const _StatCell(value: '34', label: 'Orders'),
          _Divider(),
          _StatCell(
            value: '${user.totalPoints}',
            label: 'Points',
            accent: true,
          ),
          _Divider(),
          _StatCell(value: tierName, label: 'Tier'),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final bool accent;

  const _StatCell({required this.value, required this.label, this.accent = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.cardTitle.copyWith(
              color: accent ? colors.accent : colors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(width: 1, height: 32, color: colors.divider);
  }
}

// ── Section ──────────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Sp.xs, bottom: Sp.sm),
          child: Text(
            title,
            style: AppTextStyles.labelMd.copyWith(
              color: colors.textTertiary,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Container(
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
          child: Column(children: items),
        ),
      ],
    );
  }
}

// ── Row items ────────────────────────────────────────────────────────────────

class _RowItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? valueLabel;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool isLast;

  const _RowItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.valueLabel,
    this.trailing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: BorderRadius.vertical(
            top: Radius.zero,
            bottom: isLast ? const Radius.circular(Rd.xl) : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sp.base,
              vertical: Sp.md,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(Rd.md),
                  ),
                  child: Center(
                    child: Icon(icon, size: 18, color: iconColor),
                  ),
                ),
                const SizedBox(width: Sp.md),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (valueLabel != null)
                  Text(
                    valueLabel!,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                if (trailing != null) trailing!,
                const SizedBox(width: Sp.xs),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: colors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: Sp.base + 36 + Sp.md),
            child: Divider(height: 1, color: colors.divider),
          ),
      ],
    );
  }
}

class _DarkModeRow extends StatelessWidget {
  final bool isDark;
  final WidgetRef ref;

  const _DarkModeRow({required this.isDark, required this.ref});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const iconColor = Color(0xFF6366F1);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sp.base,
            vertical: Sp.sm,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Rd.md),
                ),
                child: const Center(
                  child: Icon(
                    Icons.dark_mode_outlined,
                    size: 18,
                    color: iconColor,
                  ),
                ),
              ),
              const SizedBox(width: Sp.md),
              Expanded(
                child: Text(
                  'Dark Mode',
                  style: AppTextStyles.bodyLg.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Switch.adaptive(
                value: isDark,
                onChanged: (val) {
                  HapticFeedback.selectionClick();
                  ref
                      .read(themeProvider.notifier)
                      .setTheme(
                        val ? AppThemeMode.dark : AppThemeMode.light,
                      );
                },
                activeColor: AppColors.accent,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: Sp.base + 36 + Sp.md),
          child: Divider(height: 1, color: colors.divider),
        ),
      ],
    );
  }
}

// ── Misc widgets ─────────────────────────────────────────────────────────────

class _NotifBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(Rd.pill),
      ),
      child: Text(
        '3',
        style: AppTextStyles.labelSm.copyWith(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _ReferralChip extends StatelessWidget {
  final String code;

  const _ReferralChip({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sp.sm, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(Rd.sm),
      ),
      child: Text(
        code,
        style: AppTextStyles.labelSm.copyWith(
          color: AppColors.accentDeep,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  final Future<void> Function() onConfirm;

  const _SignOutButton({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: colors.bgSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Rd.xl),
            ),
            title: Text(
              'Sign Out',
              style: AppTextStyles.cardTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
            content: Text(
              'Are you sure you want to sign out?',
              style: AppTextStyles.bodyMd.copyWith(color: colors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.labelMd.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  onConfirm();
                },
                child: Text(
                  'Sign Out',
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Rd.xl),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              size: 18,
              color: AppColors.error,
            ),
            const SizedBox(width: Sp.sm),
            Text(
              'Sign Out',
              style: AppTextStyles.labelLg.copyWith(color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared ───────────────────────────────────────────────────────────────────

class _GoldCircle extends StatelessWidget {
  final double size;

  const _GoldCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent.withValues(alpha: 0.06),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.14),
          width: 1,
        ),
      ),
    );
  }
}
