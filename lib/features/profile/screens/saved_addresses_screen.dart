import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/buttons/primary_button.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final List<_Address> _addresses = [
    _Address(
      id: '1',
      type: 'Home',
      icon: Icons.home_rounded,
      iconColor: AppColors.success,
      street: '12A Gulberg III',
      city: 'Lahore, Punjab 54000',
      isDefault: true,
    ),
    _Address(
      id: '2',
      type: 'Work',
      icon: Icons.business_rounded,
      iconColor: const Color(0xFF6366F1),
      street: 'Office Tower, MM Alam Road',
      city: 'Lahore, Punjab 54660',
      isDefault: false,
    ),
    _Address(
      id: '3',
      type: 'Other',
      icon: Icons.location_on_rounded,
      iconColor: AppColors.warning,
      street: '45B DHA Phase 5',
      city: 'Lahore, Punjab 54810',
      isDefault: false,
    ),
  ];

  void _setDefault(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      for (final a in _addresses) {
        a.isDefault = a.id == id;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Default address updated'),
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
    setState(() => _addresses.removeWhere((a) => a.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Address removed'),
        backgroundColor: AppColors.accentDeep,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rd.lg),
        ),
      ),
    );
  }

  void _showOptions(_Address address) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddressOptionsSheet(
        address: address,
        onSetDefault: () {
          Navigator.pop(ctx);
          _setDefault(address.id);
        },
        onDelete: () {
          Navigator.pop(ctx);
          _delete(address.id);
        },
        onEdit: () {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Address editing coming soon'),
              backgroundColor: AppColors.accentDeep,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Rd.lg),
              ),
            ),
          );
        },
      ),
    );
  }

  void _addAddress() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Add address coming soon'),
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
              'Saved Addresses',
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Sp.base),
              child: Column(
                children: [
                  const SizedBox(height: Sp.sm),
                  if (_addresses.isEmpty) _EmptyState(),
                  ...List.generate(_addresses.length, (i) {
                    final address = _addresses[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Sp.md),
                      child: _AddressCard(
                        address: address,
                        onTap: () => _showOptions(address),
                      ),
                    );
                  }),
                  const SizedBox(height: Sp.md),
                  PrimaryButton(
                    label: 'Add New Address',
                    onPressed: _addAddress,
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

class _Address {
  final String id;
  final String type;
  final IconData icon;
  final Color iconColor;
  final String street;
  final String city;
  bool isDefault;

  _Address({
    required this.id,
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.street,
    required this.city,
    required this.isDefault,
  });
}

// ── Address card ──────────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  final _Address address;
  final VoidCallback onTap;

  const _AddressCard({required this.address, required this.onTap});

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
            color: address.isDefault
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
                color: address.iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Rd.md),
              ),
              child: Center(
                child: Icon(address.icon, size: 20, color: address.iconColor),
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
                        address.type,
                        style: AppTextStyles.labelMd.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (address.isDefault) ...[
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
                    address.street,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  Text(
                    address.city,
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

class _AddressOptionsSheet extends StatelessWidget {
  final _Address address;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _AddressOptionsSheet({
    required this.address,
    required this.onSetDefault,
    required this.onDelete,
    required this.onEdit,
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
              address.type,
              style: AppTextStyles.cardTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: Sp.sm),
          _SheetOption(
            icon: Icons.edit_outlined,
            label: 'Edit Address',
            color: colors.textPrimary,
            onTap: onEdit,
          ),
          if (!address.isDefault)
            _SheetOption(
              icon: Icons.check_circle_outline_rounded,
              label: 'Set as Default',
              color: AppColors.success,
              onTap: onSetDefault,
            ),
          _SheetOption(
            icon: Icons.delete_outline_rounded,
            label: 'Delete Address',
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
            Icons.location_off_outlined,
            size: 56,
            color: colors.textTertiary,
          ),
          const SizedBox(height: Sp.base),
          Text(
            'No saved addresses',
            style: AppTextStyles.cardTitle.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: Sp.xs),
          Text(
            'Add a delivery address to get started',
            style: AppTextStyles.bodyMd.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}
