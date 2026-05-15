import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  String? _passwordError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loginWithEmail() async {
    setState(() {
      _emailError = _emailController.text.isEmpty || !_emailController.text.contains('@')
          ? 'Enter a valid email'
          : null;
      _passwordError = _passwordController.text.length < 6
          ? 'Password must be at least 6 characters'
          : null;
    });
    if (_emailError != null || _passwordError != null) return;

    await ref.read(authProvider.notifier).loginWithEmail(
          _emailController.text,
          _passwordController.text,
        );

    if (mounted) {
      final auth = ref.read(authProvider);
      if (auth.status == AuthStatus.authenticated) {
        context.go('/home');
      }
    }
  }

  void _sendOtp() async {
    setState(() {
      _phoneError = _phoneController.text.length < 10 ? 'Enter a valid phone number' : null;
    });
    if (_phoneError != null) return;

    await ref.read(authProvider.notifier).loginWithPhone(_phoneController.text);
    if (mounted) {
      context.push('/auth/otp', extra: _phoneController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final auth = ref.watch(authProvider);
    final isLoading = auth.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Sp.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: Sp.xxxl),

                // Logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.restaurant, size: 32, color: Colors.white),
                ).animate().fade(duration: 400.ms).scale(
                      begin: const Offset(0.9, 0.9),
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: Sp.xl),

                Text(
                  'Welcome back',
                  style: AppTextStyles.sectionTitle.copyWith(color: colors.textPrimary),
                ).animate().fade(delay: 100.ms, duration: 400.ms),

                const SizedBox(height: Sp.sm),

                Text(
                  'Sign in to continue',
                  style: AppTextStyles.bodyMd.copyWith(color: colors.textSecondary),
                ).animate().fade(delay: 150.ms, duration: 400.ms),

                const SizedBox(height: Sp.xxl),

                // Tab selector
                _TabSelector(controller: _tabController)
                    .animate()
                    .fade(delay: 200.ms, duration: 400.ms),

                const SizedBox(height: Sp.xl),

                // Tab content
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _tabController.index == 0
                      ? _EmailTab(
                          key: const ValueKey('email'),
                          emailController: _emailController,
                          passwordController: _passwordController,
                          emailError: _emailError,
                          passwordError: _passwordError,
                          isLoading: isLoading,
                          onLogin: _loginWithEmail,
                        )
                      : _PhoneTab(
                          key: const ValueKey('phone'),
                          phoneController: _phoneController,
                          phoneError: _phoneError,
                          isLoading: isLoading,
                          onSendOtp: _sendOtp,
                        ),
                ).animate().fade(duration: 200.ms),

                const SizedBox(height: Sp.xxl),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodyMd.copyWith(color: colors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/auth/register'),
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: colors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ).animate().fade(delay: 300.ms, duration: 400.ms),

                const SizedBox(height: Sp.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabSelector extends StatelessWidget {
  final TabController controller;

  const _TabSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colors.bgTertiary,
        borderRadius: BorderRadius.circular(Rd.pill),
      ),
      child: TabBar(
        controller: controller,
        tabs: const [Tab(text: 'Email'), Tab(text: 'Phone')],
        indicator: BoxDecoration(
          gradient: AppColors.goldGradient,
          borderRadius: BorderRadius.circular(Rd.pill),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: AppTextStyles.labelMd,
        labelColor: Colors.white,
        unselectedLabelColor: colors.textSecondary,
        splashFactory: NoSplash.splashFactory,
      ),
    );
  }
}

class _EmailTab extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;
  final String? passwordError;
  final bool isLoading;
  final VoidCallback onLogin;

  const _EmailTab({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.emailError,
    required this.passwordError,
    required this.isLoading,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        AppTextField(
          label: 'Email Address',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
          errorText: emailError,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: Sp.md),
        AppTextField(
          label: 'Password',
          controller: passwordController,
          obscureText: true,
          showPasswordToggle: true,
          prefixIcon: const Icon(Icons.lock_outline),
          errorText: passwordError,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: Sp.md),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Text(
              'Forgot Password?',
              style: AppTextStyles.labelMd.copyWith(color: colors.accent),
            ),
          ),
        ),
        const SizedBox(height: Sp.xl),
        PrimaryButton(
          label: 'Sign In',
          onPressed: isLoading ? null : onLogin,
          isLoading: isLoading,
        ),
        const SizedBox(height: Sp.xl),
        _OrDivider(),
        const SizedBox(height: Sp.lg),
        _SocialButton(
          label: 'Continue with Google',
          icon: Icons.g_mobiledata,
          onPressed: () {},
        ),
        const SizedBox(height: Sp.md),
        _SocialButton(
          label: 'Continue with Apple',
          icon: Icons.apple,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _PhoneTab extends StatelessWidget {
  final TextEditingController phoneController;
  final String? phoneError;
  final bool isLoading;
  final VoidCallback onSendOtp;

  const _PhoneTab({
    super.key,
    required this.phoneController,
    required this.phoneError,
    required this.isLoading,
    required this.onSendOtp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: 'Phone Number (+92 3XX XXXXXXX)',
          controller: phoneController,
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(Icons.phone_outlined),
          errorText: phoneError,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: Sp.xl),
        PrimaryButton(
          label: 'Send OTP',
          onPressed: isLoading ? null : onSendOtp,
          isLoading: isLoading,
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(child: Divider(color: colors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sp.md),
          child: Text(
            'or continue with',
            style: AppTextStyles.bodySm.copyWith(color: colors.textTertiary),
          ),
        ),
        Expanded(child: Divider(color: colors.divider)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: colors.textPrimary, size: 22),
        label: Text(
          label,
          style: AppTextStyles.labelMd.copyWith(color: colors.textPrimary),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.divider, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Rd.lg),
          ),
          backgroundColor: colors.bgSecondary,
        ),
      ),
    );
  }
}
