import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/buttons/primary_button.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<_PaymentMethod> _methods = [
    _PaymentMethod(
      id: '1',
      type: _CardType.visa,
      label: 'Visa',
      maskedNumber: '•••• •••• •••• 4242',
      expiry: '08 / 27',
      isDefault: true,
    ),
    _PaymentMethod(
      id: '2',
      type: _CardType.mastercard,
      label: 'Mastercard',
      maskedNumber: '•••• •••• •••• 5555',
      expiry: '12 / 26',
      isDefault: false,
    ),
    _PaymentMethod(
      id: '3',
      type: _CardType.cash,
      label: 'Cash on Delivery',
      maskedNumber: 'Pay when your order arrives',
      expiry: '',
      isDefault: false,
    ),
  ];

  void _setDefault(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      for (final m in _methods) {
        m.isDefault = m.id == id;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Default payment method updated'),
        backgroundColor: AppColors.accentDeep,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rd.lg),
        ),
      ),
    );
  }

  void _delete(String id) {
    HapticFeedback.mediumImpact();
    setState(() => _methods.removeWhere((m) => m.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Payment method removed'),
        backgroundColor: AppColors.accentDeep,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rd.lg),
        ),
      ),
    );
  }

  void _showOptions(_PaymentMethod method) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PaymentOptionsSheet(
        method: method,
        onSetDefault: () {
          Navigator.pop(ctx);
          _setDefault(method.id);
        },
        onDelete: () {
          Navigator.pop(ctx);
          _delete(method.id);
        },
      ),
    );
  }

  void _addMethod() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Add payment method coming soon'),
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
    return Scaffold(
      backgroundColor: context.colors.bgPrimary,
      body: CustomScrollView(
        slivers: [
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
            title: Text(
              'Payment Methods',
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Sp.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Sp.sm),
                  if (_methods.isEmpty) _EmptyState(),
                  ...List.generate(_methods.length, (i) {
                    final method = _methods[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Sp.md),
                      child: _PaymentCard(
                        method: method,
                        onTap: () => _showOptions(method),
                      ),
                    );
                  }),
                  const SizedBox(height: Sp.md),
                  PrimaryButton(
                    label: 'Add Payment Method',
                    onPressed: _addMethod,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + Sp.xl,
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

// ── Models ────────────────────────────────────────────────────────────────────

enum _CardType { visa, mastercard, cash }

class _PaymentMethod {
  final String id;
  final _CardType type;
  final String label;
  final String maskedNumber;
  final String expiry;
  bool isDefault;

  _PaymentMethod({
    required this.id,
    required this.type,
    required this.label,
    required this.maskedNumber,
    required this.expiry,
    required this.isDefault,
  });
}

// ── Payment card ──────────────────────────────────────────────────────────────

class _PaymentCard extends StatelessWidget {
  final _PaymentMethod method;
  final VoidCallback onTap;

  const _PaymentCard({required this.method, required this.onTap});

  Color get _iconColor {
    switch (method.type) {
      case _CardType.visa:
        return const Color(0xFF1A1F71);
      case _CardType.mastercard:
        return const Color(0xFFEB001B);
      case _CardType.cash:
        return AppColors.success;
    }
  }

  IconData get _icon {
    switch (method.type) {
      case _CardType.visa:
      case _CardType.mastercard:
        return Icons.credit_card_rounded;
      case _CardType.cash:
        return Icons.payments_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Sp.base),
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: BorderRadius.circular(Rd.xl),
          border: Border.all(
            color: method.isDefault
                ? AppColors.accent.withValues(alpha: 0.40)
                : colors.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Rd.md),
              ),
              child: Center(
                child: Icon(_icon, size: 20, color: _iconColor),
              ),
            ),
            const SizedBox(width: Sp.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        method.label,
                        style: AppTextStyles.labelMd.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (method.isDefault) ...[
                        const SizedBox(width: Sp.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft,
                            borderRadius: BorderRadius.circular(Rd.pill),
                          ),
                          child: Text(
                            'Default',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.accentDeep,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    method.maskedNumber,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: colors.textSecondary,
                      letterSpacing: method.type != _CardType.cash ? 1.2 : 0,
                    ),
                  ),
                  if (method.expiry.isNotEmpty)
                    Text(
                      'Exp ${method.expiry}',
                      style: AppTextStyles.bodySm.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.more_vert_rounded,
              size: 20,
              color: colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Options bottom sheet ───────────────────────────────────────────────────────

class _PaymentOptionsSheet extends StatelessWidget {
  final _PaymentMethod method;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const _PaymentOptionsSheet({
    required this.method,
    required this.onSetDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.all(Sp.base),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xxl),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: Sp.sm),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: colors.divider,
              borderRadius: BorderRadius.circular(Rd.pill),
            ),
          ),
          const SizedBox(height: Sp.base),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sp.base),
            child: Text(
              method.label,
              style: AppTextStyles.cardTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: Sp.sm),
          if (!method.isDefault)
            _SheetOption(
              icon: Icons.check_circle_outline_rounded,
              label: 'Set as Default',
              color: AppColors.success,
              onTap: onSetDefault,
            ),
          _SheetOption(
            icon: Icons.delete_outline_rounded,
            label: 'Remove',
            color: AppColors.error,
            onTap: onDelete,
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + Sp.base,
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: AppTextStyles.bodyLg.copyWith(color: color),
      ),
      onTap: onTap,
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sp.xxl),
      child: Column(
        children: [
          Icon(
            Icons.credit_card_off_outlined,
            size: 56,
            color: colors.textTertiary,
          ),
          const SizedBox(height: Sp.base),
          Text(
            'No payment methods',
            style: AppTextStyles.cardTitle.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: Sp.xs),
          Text(
            'Add a card or payment option to get started',
            style: AppTextStyles.bodyMd.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}
