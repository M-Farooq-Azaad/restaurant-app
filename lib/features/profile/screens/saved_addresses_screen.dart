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
      street: '12A Gulberg III',
      city: 'Lahore, Punjab 54000',
      isDefault: true,
    ),
    _Address(
      id: '2',
      type: 'Work',
      street: 'Office Tower, MM Alam Road',
      city: 'Lahore, Punjab 54660',
      isDefault: false,
    ),
    _Address(
      id: '3',
      type: 'Other',
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
    _showSnackBar('Default address updated');
  }

  void _delete(String id) {
    setState(() => _addresses.removeWhere((a) => a.id == id));
    _showSnackBar('Address removed');
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.accentDeep,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rd.lg),
        ),
      ),
    );
  }

  void _confirmDelete(_Address address) {
    HapticFeedback.mediumImpact();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rd.xl),
        ),
        title: Text(
          'Delete Address',
          style: AppTextStyles.cardTitle.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        content: Text(
          'Remove "${address.type}" address? This cannot be undone.',
          style: AppTextStyles.bodyMd.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelMd.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _delete(address.id);
            },
            child: Text(
              'Delete',
              style: AppTextStyles.labelMd.copyWith(color: AppColors.error),
            ),
          ),
        ],
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
        onEdit: () {
          Navigator.pop(ctx);
          _showAddressForm(existing: address);
        },
        onDelete: () {
          Navigator.pop(ctx);
          _confirmDelete(address);
        },
      ),
    );
  }

  void _showAddressForm({_Address? existing}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddressFormSheet(
        existing: existing,
        onSave: (updated) {
          setState(() {
            if (existing == null) {
              _addresses.add(updated);
            } else {
              final idx = _addresses.indexWhere((a) => a.id == existing.id);
              if (idx != -1) _addresses[idx] = updated;
            }
          });
          _showSnackBar(
            existing == null ? 'Address added' : 'Address updated',
          );
        },
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
                  if (_addresses.isEmpty) const _EmptyState(),
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
                    onPressed: () => _showAddressForm(),
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

// ── Helpers ───────────────────────────────────────────────────────────────────

IconData _iconForType(String type) {
  switch (type) {
    case 'Home':
      return Icons.home_rounded;
    case 'Work':
      return Icons.business_rounded;
    default:
      return Icons.location_on_rounded;
  }
}

Color _colorForType(String type) {
  switch (type) {
    case 'Home':
      return AppColors.success;
    case 'Work':
      return const Color(0xFF6366F1);
    default:
      return AppColors.warning;
  }
}

// ── Model ─────────────────────────────────────────────────────────────────────

class _Address {
  final String id;
  String type;
  String street;
  String city;
  bool isDefault;

  _Address({
    required this.id,
    required this.type,
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
    final iconColor = _colorForType(address.type);
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
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Rd.md),
              ),
              child: Center(
                child: Icon(
                  _iconForType(address.type),
                  size: 20,
                  color: iconColor,
                ),
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
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressOptionsSheet({
    required this.address,
    required this.onSetDefault,
    required this.onEdit,
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
      title: Text(label, style: AppTextStyles.bodyLg.copyWith(color: color)),
      onTap: onTap,
    );
  }
}

// ── Address form sheet ────────────────────────────────────────────────────────

class _AddressFormSheet extends StatefulWidget {
  final _Address? existing;
  final void Function(_Address) onSave;

  const _AddressFormSheet({required this.existing, required this.onSave});

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  static const _types = ['Home', 'Work', 'Other'];
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _cityCtrl;

  @override
  void initState() {
    super.initState();
    _type = widget.existing?.type ?? 'Home';
    _streetCtrl = TextEditingController(text: widget.existing?.street ?? '');
    _cityCtrl = TextEditingController(text: widget.existing?.city ?? '');
  }

  @override
  void dispose() {
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();
    final saved = _Address(
      id: widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      type: _type,
      street: _streetCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      isDefault: widget.existing?.isDefault ?? false,
    );
    widget.onSave(saved);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: const EdgeInsets.fromLTRB(Sp.base, 0, Sp.base, Sp.base),
      padding: EdgeInsets.fromLTRB(Sp.base, Sp.base, Sp.base, bottom + Sp.base),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xxl),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(Rd.pill),
                ),
              ),
            ),
            const SizedBox(height: Sp.base),
            Text(
              widget.existing == null ? 'Add Address' : 'Edit Address',
              style: AppTextStyles.cardTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: Sp.base),
            Text(
              'TYPE',
              style: AppTextStyles.labelSm.copyWith(
                color: colors.textTertiary,
                fontSize: 10,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: Sp.sm),
            Row(
              children: _types.map((t) {
                final isSelected = _type == t;
                final isLast = t == _types.last;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : Sp.sm),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _type = t);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accentSoft
                              : colors.bgTertiary,
                          borderRadius: BorderRadius.circular(Rd.md),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _iconForType(t),
                              size: 14,
                              color: isSelected
                                  ? AppColors.accentDeep
                                  : colors.textSecondary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              t,
                              style: AppTextStyles.labelSm.copyWith(
                                color: isSelected
                                    ? AppColors.accentDeep
                                    : colors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: Sp.base),
            _FormField(
              label: 'STREET ADDRESS',
              controller: _streetCtrl,
              hint: 'e.g. 12A Gulberg III',
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Street is required' : null,
            ),
            const SizedBox(height: Sp.sm),
            _FormField(
              label: 'CITY / AREA',
              controller: _cityCtrl,
              hint: 'e.g. Lahore, Punjab 54000',
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'City is required' : null,
            ),
            const SizedBox(height: Sp.base),
            PrimaryButton(label: 'Save Address', onPressed: _save),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const _FormField({
    required this.label,
    required this.controller,
    required this.hint,
    this.textInputAction,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sp.base, vertical: Sp.md),
      decoration: BoxDecoration(
        color: colors.bgTertiary,
        borderRadius: BorderRadius.circular(Rd.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: colors.textTertiary,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),
          TextFormField(
            controller: controller,
            textInputAction: textInputAction,
            validator: validator,
            style: TextStyle(color: colors.textPrimary, fontSize: 15),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: colors.textTertiary,
                fontSize: 15,
              ),
              errorStyle: const TextStyle(color: AppColors.error, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sp.xxl),
      child: Column(
        children: [
          Icon(Icons.location_off_outlined, size: 56, color: colors.textTertiary),
          const SizedBox(height: Sp.base),
          Text(
            'No saved addresses',
            style: AppTextStyles.cardTitle.copyWith(color: colors.textSecondary),
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
