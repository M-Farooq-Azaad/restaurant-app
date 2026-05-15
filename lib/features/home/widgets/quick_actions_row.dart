import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';

class _QuickAction {
  final String label;
  final IconData icon;
  final bool highlight;

  const _QuickAction({
    required this.label,
    required this.icon,
    this.highlight = false,
  });
}

const _kActions = [
  _QuickAction(
    label: 'Order',
    icon: Icons.shopping_bag_outlined,
    highlight: true,
  ),
  _QuickAction(label: 'Reserve', icon: Icons.calendar_today_outlined),
  _QuickAction(label: 'Loyalty', icon: Icons.stars_outlined),
  _QuickAction(label: 'Wallet', icon: Icons.account_balance_wallet_outlined),
];

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sp.base),
      child: Row(
        children: _kActions
            .map((action) => Expanded(child: _ActionItem(action: action)))
            .toList(),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final _QuickAction action;

  const _ActionItem({required this.action});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sp.xs),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: action.highlight ? AppColors.goldGradient : null,
              color: action.highlight ? null : colors.bgSecondary,
              borderRadius: BorderRadius.circular(Rd.lg),
              border: action.highlight
                  ? null
                  : Border.all(color: colors.divider, width: 1),
              boxShadow: [
                BoxShadow(
                  color: action.highlight
                      ? AppColors.accent.withValues(alpha: 0.28)
                      : Colors.black.withValues(alpha: 0.04),
                  blurRadius: action.highlight ? 14 : 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              action.icon,
              size: 24,
              color: action.highlight ? Colors.white : colors.accent,
            ),
          ),
          const SizedBox(height: Sp.xs),
          Text(
            action.label,
            style: AppTextStyles.labelMd.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
