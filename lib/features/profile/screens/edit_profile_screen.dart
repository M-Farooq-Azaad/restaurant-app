import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../mock/mock_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  DateTime? _dob;
  String _gender = 'Male';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    const user = MockData.currentUser;
    _nameCtrl = TextEditingController(text: user.fullName);
    _usernameCtrl = TextEditingController(text: user.username);
    _bioCtrl = TextEditingController(text: 'Food lover & Gold Member 🍽️');
    _emailCtrl = TextEditingController(text: user.email);
    _phoneCtrl = TextEditingController(text: user.phone);
    _dob = DateTime(1995, 6, 15);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _bioCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully!'),
        backgroundColor: AppColors.accentDeep,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rd.lg),
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    HapticFeedback.selectionClick();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(1995, 6, 15),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            onPrimary: Colors.white,
            surface: Color(0xFF1C1400),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _onChangePhoto() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Photo update coming soon'),
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
    final dobLabel = _dob == null
        ? 'Select date'
        : '${_dob!.day.toString().padLeft(2, '0')} / '
            '${_dob!.month.toString().padLeft(2, '0')} / '
            '${_dob!.year}';

    return Scaffold(
      backgroundColor: context.colors.bgPrimary,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
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
                'Edit Profile',
                style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AvatarZone(onTap: _onChangePhoto),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Sp.base,
                      Sp.xl,
                      Sp.base,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel('Personal Info'),
                        const SizedBox(height: Sp.sm),
                        _InputRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Full Name',
                          controller: _nameCtrl,
                          textInputAction: TextInputAction.next,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Name is required'
                              : null,
                        ),
                        const SizedBox(height: Sp.md),
                        _InputRow(
                          icon: Icons.alternate_email_rounded,
                          label: 'Username',
                          controller: _usernameCtrl,
                          textInputAction: TextInputAction.next,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Username is required'
                              : null,
                        ),
                        const SizedBox(height: Sp.md),
                        _InputRow(
                          icon: Icons.edit_note_rounded,
                          label: 'Bio',
                          controller: _bioCtrl,
                          maxLines: 3,
                          textInputAction: TextInputAction.newline,
                        ),
                        const SizedBox(height: Sp.xl),
                        const _SectionLabel('Contact'),
                        const SizedBox(height: Sp.sm),
                        _InputRow(
                          icon: Icons.mail_outline_rounded,
                          label: 'Email',
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!v.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: Sp.md),
                        _InputRow(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Phone is required'
                              : null,
                        ),
                        const SizedBox(height: Sp.xl),
                        const _SectionLabel('Details'),
                        const SizedBox(height: Sp.sm),
                        _DatePickerRow(label: dobLabel, onTap: _pickDate),
                        const SizedBox(height: Sp.md),
                        _GenderRow(
                          selected: _gender,
                          onSelect: (g) => setState(() => _gender = g),
                        ),
                        const SizedBox(height: Sp.xxl),
                        PrimaryButton(
                          label: 'Save Changes',
                          onPressed: _isSaving ? null : _save,
                          isLoading: _isSaving,
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).padding.bottom + Sp.xl,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatar zone ───────────────────────────────────────────────────────────────

class _AvatarZone extends StatelessWidget {
  final VoidCallback onTap;

  const _AvatarZone({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1C1400),
      padding: const EdgeInsets.fromLTRB(0, Sp.base, 0, Sp.xl),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accent, width: 2.5),
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
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      gradient: AppColors.goldGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sp.md),
          GestureDetector(
            onTap: onTap,
            child: Text(
              'Change Photo',
              style: AppTextStyles.labelMd.copyWith(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.labelSm.copyWith(
        color: context.colors.textTertiary,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ── Unified input row ─────────────────────────────────────────────────────────

class _InputRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const _InputRow({
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.textInputAction,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sp.base,
        vertical: Sp.md,
      ),
      decoration: BoxDecoration(
        color: colors.bgTertiary,
        borderRadius: BorderRadius.circular(Rd.md),
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: maxLines > 1
                ? const EdgeInsets.only(top: Sp.xs)
                : EdgeInsets.zero,
            child: Icon(icon, size: 20, color: colors.textTertiary),
          ),
          const SizedBox(width: Sp.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppTextStyles.labelSm.copyWith(
                    color: colors.textTertiary,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  validator: validator,
                  textInputAction: textInputAction,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    isDense: maxLines == 1,
                    contentPadding: maxLines > 1
                        ? const EdgeInsets.only(top: 4)
                        : EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    errorStyle: const TextStyle(
                      color: AppColors.error,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Date picker row ───────────────────────────────────────────────────────────

class _DatePickerRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DatePickerRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPlaceholder = label == 'Select date';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sp.base,
          vertical: Sp.md,
        ),
        decoration: BoxDecoration(
          color: colors.bgTertiary,
          borderRadius: BorderRadius.circular(Rd.md),
        ),
        child: Row(
          children: [
            Icon(Icons.cake_outlined, size: 20, color: colors.textTertiary),
            const SizedBox(width: Sp.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DATE OF BIRTH',
                    style: AppTextStyles.labelSm.copyWith(
                      color: colors.textTertiary,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: TextStyle(
                      color: isPlaceholder
                          ? colors.textTertiary
                          : colors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.calendar_month_rounded,
              size: 18,
              color: colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Gender row ────────────────────────────────────────────────────────────────

class _GenderRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const _GenderRow({required this.selected, required this.onSelect});

  static const _options = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GENDER',
          style: AppTextStyles.labelSm.copyWith(
            color: colors.textTertiary,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: Sp.sm),
        Row(
          children: List.generate(_options.length, (i) {
            final opt = _options[i];
            final isSelected = selected == opt;
            final isLast = i == _options.length - 1;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : Sp.sm),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelect(opt);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    height: 44,
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
                    child: Center(
                      child: Text(
                        opt,
                        style: AppTextStyles.labelMd.copyWith(
                          color: isSelected
                              ? AppColors.accentDeep
                              : colors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
