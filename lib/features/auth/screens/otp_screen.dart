import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _otpController = TextEditingController();
  int _secondsLeft = 60;
  Timer? _timer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _verify() async {
    setState(() => _error = null);
    final ok = await ref.read(authProvider.notifier).verifyOtp(_otpController.text);
    if (mounted) {
      if (ok) {
        context.go('/home');
      } else {
        setState(() => _error = 'Invalid OTP. Try any 6-digit code.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final auth = ref.watch(authProvider);
    final isLoading = auth.status == AuthStatus.loading;
    final canVerify = _otpController.text.length == 6;

    final maskedPhone = widget.phone.length > 6
        ? '${widget.phone.substring(0, 4)}****${widget.phone.substring(widget.phone.length - 3)}'
        : widget.phone;

    final defaultPinTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: AppTextStyles.cardTitle.copyWith(color: colors.textPrimary),
      decoration: BoxDecoration(
        color: colors.bgTertiary,
        borderRadius: BorderRadius.circular(Rd.md),
        border: Border.all(color: Colors.transparent, width: 1.5),
      ),
    );

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sp.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: Sp.xxl),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colors.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.phone_android, size: 40, color: colors.accent),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

              const SizedBox(height: Sp.xl),

              Text(
                'Verify your number',
                style: AppTextStyles.sectionTitle.copyWith(color: colors.textPrimary),
                textAlign: TextAlign.center,
              ).animate().fade(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: Sp.sm),

              Text(
                'Enter the 6-digit code sent to $maskedPhone',
                style: AppTextStyles.bodyMd.copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ).animate().fade(delay: 150.ms, duration: 400.ms),

              const SizedBox(height: Sp.xxxl),

              // OTP Input
              Pinput(
                controller: _otpController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: colors.accent, width: 1.5),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: colors.accentSoft,
                    border: Border.all(color: colors.accent, width: 1.5),
                  ),
                ),
                onCompleted: (_) => _verify(),
                onChanged: (_) => setState(() {}),
              ).animate().fade(delay: 200.ms, duration: 400.ms),

              if (_error != null) ...[
                const SizedBox(height: Sp.md),
                Text(
                  _error!,
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.error),
                ),
              ],

              const SizedBox(height: Sp.xl),

              // Resend timer
              _secondsLeft > 0
                  ? Text(
                      'Resend code in 0:${_secondsLeft.toString().padLeft(2, '0')}',
                      style: AppTextStyles.bodySm.copyWith(color: colors.textSecondary),
                    )
                  : GestureDetector(
                      onTap: _startTimer,
                      child: Text(
                        'Resend OTP',
                        style: AppTextStyles.labelMd.copyWith(color: colors.accent),
                      ),
                    ),

              const SizedBox(height: Sp.xxl),

              PrimaryButton(
                label: 'Verify',
                onPressed: (canVerify && !isLoading) ? _verify : null,
                isLoading: isLoading,
              ).animate().fade(delay: 250.ms, duration: 400.ms),

              const SizedBox(height: Sp.md),

              Text(
                'Hint: any 6-digit code works in demo mode',
                style: AppTextStyles.bodySm.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
