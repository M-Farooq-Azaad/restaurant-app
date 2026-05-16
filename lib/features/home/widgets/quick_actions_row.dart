import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';

class _QuickAction {
  final String label;
  final IconData icon;
  final Color accentColor;
  final bool highlight;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.accentColor,
    this.highlight = false,
  });
}

const _kActions = [
  _QuickAction(
    label: 'Order',
    icon: Icons.shopping_bag_rounded,
    accentColor: AppColors.accent,
    highlight: true,
  ),
  _QuickAction(
    label: 'Reserve',
    icon: Icons.calendar_month_rounded,
    accentColor: Color(0xFF3B82F6),
  ),
  _QuickAction(
    label: 'Loyalty',
    icon: Icons.workspace_premium_rounded,
    accentColor: Color(0xFFA855F7),
  ),
  _QuickAction(
    label: 'Wallet',
    icon: Icons.account_balance_wallet_rounded,
    accentColor: Color(0xFF22C55E),
  ),
  _QuickAction(
    label: 'Favourites',
    icon: Icons.favorite_rounded,
    accentColor: Color(0xFFEF4444),
  ),
  _QuickAction(
    label: 'Scan QR',
    icon: Icons.qr_code_scanner_rounded,
    accentColor: Color(0xFF06B6D4),
  ),
  _QuickAction(
    label: 'Offers',
    icon: Icons.local_offer_rounded,
    accentColor: Color(0xFFF97316),
  ),
  _QuickAction(
    label: 'Track',
    icon: Icons.delivery_dining_rounded,
    accentColor: Color(0xFF8B5CF6),
  ),
];

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sp.sm),
      child: Column(
        children: [
          Row(
            children: _kActions
                .take(4)
                .map((a) => Expanded(child: _ActionItem(action: a)))
                .toList(),
          ),
          const SizedBox(height: Sp.md),
          Row(
            children: _kActions
                .skip(4)
                .map((a) => Expanded(child: _ActionItem(action: a)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatefulWidget {
  final _QuickAction action;

  const _ActionItem({required this.action});

  @override
  State<_ActionItem> createState() => _ActionItemState();
}

class _ActionItemState extends State<_ActionItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 160),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _ctrl.forward();
  void _onTapUp(_) => _ctrl.reverse();
  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final action = widget.action;
    final color = action.accentColor;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () => HapticFeedback.selectionClick(),
      child: ScaleTransition(
        scale: _scale,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: action.highlight ? AppColors.goldGradient : null,
                color: action.highlight ? null : color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Rd.xl),
                border: Border.all(
                  color: action.highlight
                      ? Colors.transparent
                      : color.withValues(alpha: 0.25),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(
                        alpha: action.highlight ? 0.36 : 0.12),
                    blurRadius: action.highlight ? 14 : 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                action.icon,
                size: 22,
                color: action.highlight ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              action.label,
              style: AppTextStyles.labelSm.copyWith(
                color: action.highlight
                    ? colors.textPrimary
                    : colors.textSecondary,
                fontWeight:
                    action.highlight ? FontWeight.w600 : FontWeight.w500,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
