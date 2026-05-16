import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';
import 'send_points_screen.dart';

enum _Step { amount, confirm, processing, receipt }

class TransferFlowScreen extends StatefulWidget {
  final AppContact contact;
  final VoidCallback onComplete;

  const TransferFlowScreen({
    super.key,
    required this.contact,
    required this.onComplete,
  });

  @override
  State<TransferFlowScreen> createState() => _TransferFlowScreenState();
}

class _TransferFlowScreenState extends State<TransferFlowScreen>
    with TickerProviderStateMixin {
  _Step _step = _Step.amount;
  String _amountStr = '';
  final _noteCtrl = TextEditingController();
  late final AnimationController _successCtrl;

  static final _balance = MockData.currentUser.totalPoints;

  int get _amount => int.tryParse(_amountStr) ?? 0;
  bool get _canProceed => _amount > 0 && _amount <= _balance;

  @override
  void initState() {
    super.initState();
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _successCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _onKey(String key) {
    HapticFeedback.selectionClick();
    setState(() {
      if (key == '⌫') {
        if (_amountStr.isNotEmpty) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
        }
      } else {
        final next = _amountStr + key;
        final val = int.tryParse(next) ?? 0;
        if (val <= _balance && next.length <= 4) _amountStr = next;
      }
    });
  }

  void _onSetAmount(String s) {
    HapticFeedback.selectionClick();
    final val = int.tryParse(s) ?? 0;
    if (val <= _balance) setState(() => _amountStr = s);
  }

  Future<void> _confirmTransfer() async {
    HapticFeedback.mediumImpact();
    setState(() => _step = _Step.processing);
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;
    setState(() => _step = _Step.receipt);
    _successCtrl.forward(from: 0);
    HapticFeedback.heavyImpact();
  }

  void _done() {
    Navigator.of(context).pop();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.bgPrimary,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 360),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
        ),
        child: switch (_step) {
          _Step.amount => _AmountView(
              key: const ValueKey('amount'),
              contact: widget.contact,
              amountStr: _amountStr,
              balance: _balance,
              canProceed: _canProceed,
              onKey: _onKey,
              onSet: _onSetAmount,
              onNext: () {
                HapticFeedback.mediumImpact();
                setState(() => _step = _Step.confirm);
              },
              onBack: () => Navigator.of(context).pop(),
            ),
          _Step.confirm => _ConfirmView(
              key: const ValueKey('confirm'),
              contact: widget.contact,
              amount: _amount,
              balance: _balance,
              noteCtrl: _noteCtrl,
              onConfirm: _confirmTransfer,
              onBack: () {
                HapticFeedback.selectionClick();
                setState(() => _step = _Step.amount);
              },
            ),
          _Step.processing => const _ProcessingView(
              key: ValueKey('processing'),
            ),
          _Step.receipt => _ReceiptView(
              key: const ValueKey('receipt'),
              contact: widget.contact,
              amount: _amount,
              successCtrl: _successCtrl,
              onDone: _done,
            ),
        },
      ),
    );
  }
}

// ── Amount view ───────────────────────────────────────────────────────────────

class _AmountView extends StatelessWidget {
  final AppContact contact;
  final String amountStr;
  final int balance;
  final bool canProceed;
  final ValueChanged<String> onKey;
  final ValueChanged<String> onSet;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _AmountView({
    super.key,
    required this.contact,
    required this.amountStr,
    required this.balance,
    required this.canProceed,
    required this.onKey,
    required this.onSet,
    required this.onNext,
    required this.onBack,
  });

  int get _amount => int.tryParse(amountStr) ?? 0;

  @override
  Widget build(BuildContext context) {
    final overBalance = _amount > balance;
    final pad = MediaQuery.of(context).padding;

    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E0900), Color(0xFF1C1400), Color(0xFF251A00)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Subtle decorative circles
            const Positioned(top: -50, right: -40, child: _BgCircle(120)),
            const Positioned(top: 80, left: -60, child: _BgCircle(100)),
            SafeArea(
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(Sp.xs, Sp.xs, Sp.base, 0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: onBack,
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white70, size: 20),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Sp.sm, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(Rd.pill),
                            border: Border.all(
                                color:
                                    AppColors.accent.withValues(alpha: 0.25)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.stars_rounded,
                                  size: 12, color: AppColors.accent),
                              const SizedBox(width: 4),
                              Text('$balance pts',
                                  style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.accent, fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sp.lg),
                  // Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: contact.avatarColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: contact.avatarColor.withValues(alpha: 0.55),
                          width: 2.5),
                      boxShadow: [
                        BoxShadow(
                            color: contact.avatarColor.withValues(alpha: 0.30),
                            blurRadius: 24,
                            spreadRadius: 2),
                      ],
                    ),
                    child: Center(
                      child: Text(contact.initials,
                          style: AppTextStyles.cardTitle.copyWith(
                              color: contact.avatarColor, fontSize: 30)),
                    ),
                  )
                      .animate()
                      .scale(
                          begin: const Offset(0.7, 0.7),
                          duration: 400.ms,
                          curve: Curves.easeOutBack)
                      .fade(duration: 300.ms),
                  const SizedBox(height: Sp.md),
                  Text('Sending to',
                      style:
                          AppTextStyles.bodySm.copyWith(color: Colors.white38)),
                  const SizedBox(height: 2),
                  Text(contact.name,
                      style: AppTextStyles.cardTitle
                          .copyWith(color: Colors.white, fontSize: 20)),
                  if (contact.username != null) ...[
                    const SizedBox(height: 2),
                    Text('@${contact.username}',
                        style: AppTextStyles.bodySm
                            .copyWith(color: Colors.white38)),
                  ],
                  // Amount display
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Text(
                      amountStr.isEmpty ? '—' : amountStr,
                      key: ValueKey(amountStr),
                      style: AppTextStyles.priceLg.copyWith(
                        fontSize: 72,
                        letterSpacing: -2,
                        color: overBalance
                            ? AppColors.error
                            : (canProceed ? AppColors.accent : Colors.white70),
                      ),
                    ),
                  ),
                  Text('pts',
                      style:
                          AppTextStyles.bodyLg.copyWith(color: Colors.white30)),
                  const SizedBox(height: Sp.md),
                  // Error or quick chips
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: overBalance
                        ? Padding(
                            key: const ValueKey('over'),
                            padding:
                                const EdgeInsets.symmetric(horizontal: Sp.xl),
                            child: Text(
                              'Exceeds balance of $balance pts',
                              style: AppTextStyles.bodySm
                                  .copyWith(color: AppColors.error),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Row(
                            key: const ValueKey('chips'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [100, 500, 1000].map((pts) {
                              final isOver = pts > balance;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Sp.xs, vertical: Sp.md),
                                child: GestureDetector(
                                  onTap: isOver
                                      ? null
                                      : () => onSet(pts.toString()),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Sp.md, vertical: Sp.xs),
                                    decoration: BoxDecoration(
                                      color: isOver
                                          ? Colors.white.withValues(alpha: 0.05)
                                          : AppColors.accent
                                              .withValues(alpha: 0.15),
                                      borderRadius:
                                          BorderRadius.circular(Rd.pill),
                                      border: Border.all(
                                          color: isOver
                                              ? Colors.white12
                                              : AppColors.accent
                                                  .withValues(alpha: 0.35)),
                                    ),
                                    child: Text('$pts pts',
                                        style: AppTextStyles.labelSm.copyWith(
                                          color: isOver
                                              ? Colors.white24
                                              : AppColors.accent,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        )),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const Spacer(),
                  // Numpad
                  _Numpad(onKey: onKey),
                  const SizedBox(height: Sp.lg),
                  // Continue button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sp.base),
                    child: GestureDetector(
                      onTap: canProceed ? onNext : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(vertical: Sp.md + 2),
                        decoration: BoxDecoration(
                          gradient: canProceed ? AppColors.goldGradient : null,
                          color: canProceed
                              ? null
                              : Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(Rd.xl),
                          boxShadow: canProceed
                              ? [
                                  BoxShadow(
                                      color: AppColors.accent
                                          .withValues(alpha: 0.40),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6))
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text('Continue',
                              style: AppTextStyles.labelLg.copyWith(
                                color:
                                    canProceed ? Colors.white : Colors.white24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              )),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: pad.bottom + Sp.md),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BgCircle extends StatelessWidget {
  final double size;
  const _BgCircle(this.size);
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent.withValues(alpha: 0.04),
          border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.08), width: 1),
        ),
      );
}

// ── Numpad ────────────────────────────────────────────────────────────────────

class _Numpad extends StatelessWidget {
  final ValueChanged<String> onKey;

  const _Numpad({required this.onKey});

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', '⌫'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Sp.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              if (key.isEmpty) {
                return const SizedBox(width: 88, height: 64);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sp.sm),
                child: _NumKey(label: key, onTap: () => onKey(key)),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _NumKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NumKey({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isBackspace = label == '⌫';
    return Material(
      color: Colors.white.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(Rd.xxl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Rd.xxl),
        splashColor: AppColors.accent.withValues(alpha: 0.18),
        highlightColor: Colors.white.withValues(alpha: 0.04),
        child: SizedBox(
          width: 96,
          height: 68,
          child: Center(
            child: isBackspace
                ? const Icon(Icons.backspace_outlined,
                    size: 24, color: Colors.white60)
                : Text(label,
                    style: AppTextStyles.cardTitle.copyWith(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w400)),
          ),
        ),
      ),
    );
  }
}

// ── Confirm view ──────────────────────────────────────────────────────────────

class _ConfirmView extends StatelessWidget {
  final AppContact contact;
  final int amount;
  final int balance;
  final TextEditingController noteCtrl;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  const _ConfirmView({
    super.key,
    required this.contact,
    required this.amount,
    required this.balance,
    required this.noteCtrl,
    required this.onConfirm,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const user = MockData.currentUser;
    final senderInitials = user.fullName
        .trim()
        .split(' ')
        .take(2)
        .map((p) => p[0])
        .join()
        .toUpperCase();
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          toolbarHeight: 64,
          backgroundColor: const Color(0xFF1C1400),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
          ),
          title: Text('Review Transfer',
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white)),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Sp.base, Sp.lg, Sp.base, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Transfer flow card ────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A1000), Color(0xFF2C1E00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(Rd.xxl),
                    border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.22)),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.14),
                          blurRadius: 32,
                          offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      // Decorative corner circles
                      Positioned(top: -30, right: -20, child: _BgCircle(110)),
                      Positioned(bottom: -20, left: -30, child: _BgCircle(90)),
                      Padding(
                        padding: const EdgeInsets.all(Sp.xl),
                        child: Column(
                          children: [
                            // Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Sp.md, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(Rd.pill),
                                border: Border.all(
                                    color: AppColors.accent
                                        .withValues(alpha: 0.22)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.lock_rounded,
                                      size: 10, color: AppColors.accent),
                                  const SizedBox(width: 4),
                                  Text('ENCRYPTED TRANSFER',
                                      style: AppTextStyles.labelSm.copyWith(
                                          color: AppColors.accent,
                                          fontSize: 9,
                                          letterSpacing: 1.2)),
                                ],
                              ),
                            ),
                            const SizedBox(height: Sp.xl),
                            // Sender → Amount pill → Receiver
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: _TransferParty(
                                    initials: senderInitials,
                                    name: 'You',
                                    sub: '@${user.username}',
                                    color: AppColors.accent,
                                  ),
                                ),
                                // Center amount pill
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Sp.sm, vertical: Sp.xs),
                                      decoration: BoxDecoration(
                                        gradient: AppColors.goldGradient,
                                        borderRadius:
                                            BorderRadius.circular(Rd.pill),
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.accent
                                                  .withValues(alpha: 0.40),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4)),
                                        ],
                                      ),
                                      child: Text('$amount pts',
                                          style: AppTextStyles.labelSm.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 11,
                                          )),
                                    ),
                                    const SizedBox(height: 4),
                                    Icon(Icons.arrow_forward_rounded,
                                        color: AppColors.accent
                                            .withValues(alpha: 0.50),
                                        size: 16),
                                  ],
                                ),
                                Expanded(
                                  child: _TransferParty(
                                    initials: contact.initials,
                                    name: contact.name.split(' ').first,
                                    sub: contact.username != null
                                        ? '@${contact.username}'
                                        : contact.phone,
                                    color: contact.avatarColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Sp.xl),
                            Divider(
                                color: Colors.white.withValues(alpha: 0.08)),
                            const SizedBox(height: Sp.md),
                            // Remaining balance
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Remaining balance',
                                    style: AppTextStyles.bodySm
                                        .copyWith(color: Colors.white38)),
                                Text('${balance - amount} pts',
                                    style: AppTextStyles.bodyMd.copyWith(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Sp.md),
                // ── Transaction detail pills ──────────────────────────────
                Row(
                  children: [
                    _DetailPill(
                        icon: Icons.bolt_rounded,
                        label: 'Instant',
                        color: const Color(0xFF34D399)),
                    const SizedBox(width: Sp.sm),
                    _DetailPill(
                        icon: Icons.money_off_rounded,
                        label: 'No Fees',
                        color: const Color(0xFF60A5FA)),
                    const SizedBox(width: Sp.sm),
                    _DetailPill(
                        icon: Icons.shield_rounded,
                        label: 'Secure',
                        color: AppColors.accent),
                  ],
                ),
                const SizedBox(height: Sp.xl),
                // ── Note field ────────────────────────────────────────────
                Text('ADD A NOTE  (OPTIONAL)',
                    style: AppTextStyles.labelSm.copyWith(
                        color: colors.textTertiary,
                        fontSize: 10,
                        letterSpacing: 0.8)),
                const SizedBox(height: Sp.sm),
                Container(
                  decoration: BoxDecoration(
                    color: colors.bgSecondary,
                    borderRadius: BorderRadius.circular(Rd.xl),
                    border: Border.all(color: colors.divider),
                  ),
                  child: TextField(
                    controller: noteCtrl,
                    maxLines: 2,
                    maxLength: 60,
                    style: AppTextStyles.bodyMd
                        .copyWith(color: colors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'e.g. Thanks for lunch! 🍜',
                      hintStyle: AppTextStyles.bodySm
                          .copyWith(color: colors.textTertiary),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            left: Sp.md, right: Sp.sm, top: Sp.sm),
                        child: Icon(Icons.edit_note_rounded,
                            color: colors.textTertiary, size: 20),
                      ),
                      prefixIconConstraints: const BoxConstraints(),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(
                          Sp.sm, Sp.md, Sp.base, Sp.md),
                      counterStyle: AppTextStyles.labelSm
                          .copyWith(color: colors.textTertiary, fontSize: 10),
                    ),
                  ),
                ),
                const SizedBox(height: Sp.xl),
                // ── Confirm button ────────────────────────────────────────
                GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: Sp.md + 2),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(Rd.xl),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.40),
                            blurRadius: 20,
                            offset: const Offset(0, 6)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send_rounded,
                            color: Colors.white, size: 18),
                        const SizedBox(width: Sp.sm),
                        Text('Confirm Transfer',
                            style: AppTextStyles.labelLg.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3)),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 300.ms)
                    .slideY(begin: 0.05, end: 0, delay: 200.ms),
                const SizedBox(height: Sp.sm),
                TextButton(
                  onPressed: onBack,
                  child: Text('Go Back',
                      style: AppTextStyles.bodyMd
                          .copyWith(color: colors.textTertiary)),
                ),
                SizedBox(height: bottomPad + Sp.md),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DetailPill(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Sp.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Rd.lg),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 3),
            Text(label,
                style: AppTextStyles.labelSm.copyWith(
                    color: colors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _TransferParty extends StatelessWidget {
  final String initials;
  final String name;
  final String sub;
  final Color color;

  const _TransferParty({
    required this.initials,
    required this.name,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.45), width: 2),
            boxShadow: [
              BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 14,
                  spreadRadius: 1),
            ],
          ),
          child: Center(
            child: Text(initials,
                style: AppTextStyles.labelMd
                    .copyWith(color: color, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: Sp.xs),
        Text(name,
            style: AppTextStyles.bodyMd
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        Text(sub,
            style: AppTextStyles.bodySm.copyWith(color: Colors.white38),
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

// ── Processing view ───────────────────────────────────────────────────────────

class _ProcessingView extends StatefulWidget {
  const _ProcessingView({super.key});

  @override
  State<_ProcessingView> createState() => _ProcessingViewState();
}

class _ProcessingViewState extends State<_ProcessingView> {
  int _msgIdx = 0;
  Timer? _timer;

  static const _messages = [
    'Verifying balance',
    'Encrypting transfer',
    'Sending points',
    'Almost done',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (mounted) setState(() => _msgIdx = (_msgIdx + 1) % _messages.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _pulsingRing({required Duration delay, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.22),
          width: 1.5,
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .scale(
          begin: const Offset(0.3, 0.3),
          end: const Offset(1.6, 1.6),
          duration: 1800.ms,
          curve: Curves.easeOut,
          delay: delay,
        )
        .fade(
          begin: 0.9,
          end: 0.0,
          duration: 1800.ms,
          delay: delay,
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dot grid background
          Positioned.fill(
            child: Opacity(
              opacity: 0.045,
              child: CustomPaint(painter: _DotGridPainter()),
            ),
          ),
          // Pulsing rings - staggered
          _pulsingRing(delay: Duration.zero, size: 160),
          _pulsingRing(delay: 600.ms, size: 160),
          _pulsingRing(delay: 1200.ms, size: 160),
          // Outer static ring
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
          ),
          // Center gold coin
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.50),
                  blurRadius: 32,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: const Icon(
              Icons.swap_horiz_rounded,
              color: Colors.white,
              size: 36,
            ),
          )
              .animate()
              .scale(
                duration: 600.ms,
                curve: Curves.easeOutBack,
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.06, 1.06),
                duration: 1200.ms,
                curve: Curves.easeInOut,
              ),
          // Status text pinned below center
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Processing Transfer',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: Sp.sm),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.4),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: Row(
                    key: ValueKey(_msgIdx),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                          strokeWidth: 1.5,
                        ),
                      ),
                      const SizedBox(width: Sp.sm),
                      Text(
                        '${_messages[_msgIdx]}...',
                        style: AppTextStyles.bodySm.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
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

// ── Receipt view ──────────────────────────────────────────────────────────────

class _ReceiptView extends StatefulWidget {
  final AppContact contact;
  final int amount;
  final AnimationController successCtrl;
  final VoidCallback onDone;

  const _ReceiptView({
    super.key,
    required this.contact,
    required this.amount,
    required this.successCtrl,
    required this.onDone,
  });

  @override
  State<_ReceiptView> createState() => _ReceiptViewState();
}

class _ReceiptViewState extends State<_ReceiptView> {
  final _receiptKey = GlobalKey();
  bool _saving = false;
  bool _saved = false;

  Future<void> _saveToGallery() async {
    setState(() => _saving = true);
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Gallery permission denied'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Rd.lg)),
              ),
            );
          }
          return;
        }
      }
      final boundary = _receiptKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('capture failed');
      await Gal.putImageBytes(byteData.buffer.asUint8List());
      if (mounted) {
        setState(() => _saved = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Receipt saved to gallery'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Rd.lg)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not save receipt'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Rd.lg)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const user = MockData.currentUser;
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = now.hour;
    final timeStr =
        '${h > 12 ? h - 12 : h == 0 ? 12 : h}:${now.minute.toString().padLeft(2, '0')} ${h < 12 ? 'AM' : 'PM'}';
    final dateStr = '${now.day} ${months[now.month - 1]}, $timeStr';
    final txnId = now.millisecondsSinceEpoch % 100000;

    return Column(
      children: [
        // ── Capturable receipt area ──────────────────────────────────────
        Expanded(
          child: RepaintBoundary(
            key: _receiptKey,
            child: Container(
              color: colors.bgPrimary,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Wave gradient header
                    ClipPath(
                      clipper: _HeaderWaveClipper(),
                      child: Container(
                        height: 300,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF0A0600),
                              Color(0xFF1C1400),
                              Color(0xFF2C1E00),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: SafeArea(
                          bottom: false,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Sp.base, vertical: Sp.sm),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ID : $txnId',
                                        style: AppTextStyles.bodySm.copyWith(
                                            color: Colors.white38,
                                            fontSize: 11)),
                                    Text(dateStr,
                                        style: AppTextStyles.bodySm.copyWith(
                                            color: Colors.white38,
                                            fontSize: 11)),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              ScaleTransition(
                                scale: CurvedAnimation(
                                  parent: widget.successCtrl,
                                  curve: Curves.easeOutBack,
                                ),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: AppColors.success
                                        .withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.success
                                          .withValues(alpha: 0.50),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.success
                                            .withValues(alpha: 0.30),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.check_rounded,
                                      color: AppColors.success, size: 36),
                                ),
                              ),
                              const SizedBox(height: Sp.md),
                              Text(
                                '${widget.amount} pts',
                                style: AppTextStyles.priceLg.copyWith(
                                  color: AppColors.accent,
                                  fontSize: 50,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sent to ${widget.contact.name.split(' ').first}',
                                style: AppTextStyles.bodyMd
                                    .copyWith(color: Colors.white54),
                              ),
                              const SizedBox(height: Sp.xxxl),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Transaction rows
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          Sp.base, Sp.xs, Sp.base, 0),
                      child: Column(
                        children: [
                          _ReceiptLineItem(
                            color: AppColors.accent,
                            icon: Icons.account_circle_rounded,
                            label: user.fullName,
                            sub: 'Sender · @${user.username}',
                            value: '${widget.amount} pts',
                          ),
                          _ReceiptLineItem(
                            color: widget.contact.avatarColor,
                            initials: widget.contact.initials,
                            label: widget.contact.name,
                            sub: widget.contact.username != null
                                ? 'Recipient · @${widget.contact.username}'
                                : 'Recipient · ${widget.contact.phone}',
                            value: 'Received',
                            valueColor: AppColors.success,
                          ),
                          _ReceiptLineItem(
                            color: const Color(0xFF60A5FA),
                            icon: Icons.access_time_rounded,
                            label: 'Transaction Time',
                            sub: dateStr,
                            value: 'Instant',
                            valueColor: const Color(0xFF60A5FA),
                          ),
                          _ReceiptLineItem(
                            color: AppColors.success,
                            icon: Icons.shield_rounded,
                            label: 'Status',
                            sub: 'Encrypted · No fees',
                            value: 'Completed',
                            valueColor: AppColors.success,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // ── Action buttons ───────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(
            Sp.base,
            Sp.sm,
            Sp.base,
            MediaQuery.of(context).padding.bottom + Sp.md,
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: _saved
                    ? OutlinedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                        label: const Text('Saved to Gallery'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.success,
                          disabledForegroundColor: AppColors.success,
                          side: BorderSide(
                              color: AppColors.success.withValues(alpha: 0.50)),
                          padding: const EdgeInsets.symmetric(vertical: Sp.md),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Rd.xl)),
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: _saving ? null : _saveToGallery,
                        icon: _saving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    color: AppColors.accent, strokeWidth: 2),
                              )
                            : const Icon(Icons.download_rounded, size: 18),
                        label: Text(_saving ? 'Saving…' : 'Save Receipt'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.accent,
                          side: BorderSide(
                              color: AppColors.accent.withValues(alpha: 0.50)),
                          padding: const EdgeInsets.symmetric(vertical: Sp.md),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Rd.xl)),
                        ),
                      ),
              ),
              const SizedBox(height: Sp.sm),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: widget.onDone,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: Sp.md),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Rd.xl)),
                  ),
                  child: const Text('Done'),
                ),
              ),
              const SizedBox(height: Sp.xs),
              TextButton(
                onPressed: () => HapticFeedback.selectionClick(),
                child: Text(
                  'Something wrong? Get Help',
                  style: AppTextStyles.bodySm
                      .copyWith(color: AppColors.accentDeep),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReceiptLineItem extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final String? initials;
  final String label;
  final String sub;
  final String value;
  final Color? valueColor;
  final bool isLast;

  const _ReceiptLineItem({
    required this.color,
    this.icon,
    this.initials,
    required this.label,
    required this.sub,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Sp.md),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Rd.lg),
                  border: Border.all(color: color.withValues(alpha: 0.22)),
                ),
                child: Center(
                  child: initials != null
                      ? Text(initials!,
                          style: AppTextStyles.labelMd.copyWith(
                              color: color, fontWeight: FontWeight.w700))
                      : Icon(icon, color: color, size: 20),
                ),
              ),
              const SizedBox(width: Sp.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: AppTextStyles.bodyMd.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600)),
                    Text(sub,
                        style: AppTextStyles.bodySm
                            .copyWith(color: colors.textTertiary)),
                  ],
                ),
              ),
              Text(value,
                  style: AppTextStyles.bodyMd.copyWith(
                      color: valueColor ?? colors.textPrimary,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        if (!isLast) Divider(color: colors.divider, height: 1),
      ],
    );
  }
}

class _HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width * 0.25, size.height,
      size.width * 0.5, size.height - 25,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height - 50,
      size.width, size.height - 15,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}

// ── Painters ──────────────────────────────────────────────────────────────────

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.accent;
    const gap = 26.0;
    const r = 1.5;
    for (double x = gap; x < size.width; x += gap) {
      for (double y = gap; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

