import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralController = TextEditingController();

  final Map<String, String?> _errors = {};
  bool _showOptional = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  bool _validate() {
    final errors = <String, String?>{};
    if (_fullNameController.text.trim().isEmpty) errors['name'] = 'Full name is required';
    if (_phoneController.text.length < 10) errors['phone'] = 'Enter a valid phone number';
    if (!_emailController.text.contains('@')) errors['email'] = 'Enter a valid email';
    if (_passwordController.text.length < 6) errors['password'] = 'Minimum 6 characters';
    if (_passwordController.text != _confirmPasswordController.text) {
      errors['confirm'] = 'Passwords do not match';
    }
    setState(() => _errors.addAll(errors));
    return errors.isEmpty;
  }

  void _register() async {
    if (!_validate()) return;
    await ref.read(authProvider.notifier).register(
          fullName: _fullNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
        );
    if (mounted) {
      final auth = ref.read(authProvider);
      if (auth.status == AuthStatus.authenticated) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final auth = ref.watch(authProvider);
    final isLoading = auth.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: colors.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Sp.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create account',
                style: AppTextStyles.sectionTitle.copyWith(color: colors.textPrimary),
              ).animate().fade(duration: 400.ms),

              const SizedBox(height: Sp.sm),

              Text(
                'Join and start earning rewards',
                style: AppTextStyles.bodyMd.copyWith(color: colors.textSecondary),
              ).animate().fade(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: Sp.xxl),

              // Required fields
              _buildField(
                AppTextField(
                  label: 'Full Name',
                  controller: _fullNameController,
                  prefixIcon: const Icon(Icons.person_outline),
                  errorText: _errors['name'],
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() => _errors.remove('name')),
                ),
                delay: 150,
              ),
              const SizedBox(height: Sp.md),
              _buildField(
                AppTextField(
                  label: 'Username',
                  controller: _usernameController,
                  prefixIcon: const Icon(Icons.alternate_email),
                  textInputAction: TextInputAction.next,
                ),
                delay: 175,
              ),
              const SizedBox(height: Sp.md),
              _buildField(
                AppTextField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  errorText: _errors['phone'],
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() => _errors.remove('phone')),
                ),
                delay: 200,
              ),
              const SizedBox(height: Sp.md),
              _buildField(
                AppTextField(
                  label: 'Email Address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  errorText: _errors['email'],
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() => _errors.remove('email')),
                ),
                delay: 225,
              ),
              const SizedBox(height: Sp.md),
              _buildField(
                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  showPasswordToggle: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  errorText: _errors['password'],
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() => _errors.remove('password')),
                ),
                delay: 250,
              ),
              const SizedBox(height: Sp.md),
              _buildField(
                AppTextField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  showPasswordToggle: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  errorText: _errors['confirm'],
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() => _errors.remove('confirm')),
                ),
                delay: 275,
              ),

              const SizedBox(height: Sp.lg),

              // Optional section toggle
              GestureDetector(
                onTap: () => setState(() => _showOptional = !_showOptional),
                child: Row(
                  children: [
                    Icon(
                      _showOptional ? Icons.remove_circle_outline : Icons.add_circle_outline,
                      color: colors.accent,
                      size: 18,
                    ),
                    const SizedBox(width: Sp.sm),
                    Text(
                      'Add more details (optional)',
                      style: AppTextStyles.labelMd.copyWith(color: colors.accent),
                    ),
                  ],
                ),
              ),

              if (_showOptional) ...[
                const SizedBox(height: Sp.md),
                Text(
                  'Date of Birth & Anniversary can unlock special perks',
                  style: AppTextStyles.bodySm.copyWith(color: colors.textTertiary),
                ),
              ],

              const SizedBox(height: Sp.xl),

              // Referral code
              AppTextField(
                label: 'Referral Code (optional)',
                controller: _referralController,
                prefixIcon: const Icon(Icons.card_giftcard_outlined),
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: Sp.xxl),

              PrimaryButton(
                label: 'Create Account',
                onPressed: isLoading ? null : _register,
                isLoading: isLoading,
              ).animate().fade(delay: 300.ms, duration: 400.ms),

              const SizedBox(height: Sp.lg),

              // Terms
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'By signing up you agree to our ',
                    style: AppTextStyles.bodySm.copyWith(color: colors.textTertiary),
                    children: [
                      TextSpan(
                        text: 'Terms',
                        style: AppTextStyles.bodySm.copyWith(color: colors.accent),
                      ),
                      const TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: AppTextStyles.bodySm.copyWith(color: colors.accent),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: Sp.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(Widget field, {required int delay}) {
    return field.animate().fade(delay: Duration(milliseconds: delay), duration: 400.ms);
  }
}
