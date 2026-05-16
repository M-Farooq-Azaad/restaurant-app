import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 340,
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
            actions: [
              IconButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Share link copied!'),
                      backgroundColor: AppColors.accentDeep,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Rd.lg),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.ios_share_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _AboutHeader(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Sp.base, Sp.xl, Sp.base, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── The app ──
                  _SectionLabel('THE APP'),
                  const SizedBox(height: Sp.sm),
                  const _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.tag_rounded,
                        iconColor: Color(0xFF6366F1),
                        label: 'Version',
                        value: '1.0.0 (build 42)',
                      ),
                      _InfoRow(
                        icon: Icons.update_rounded,
                        iconColor: AppColors.success,
                        label: 'Last Updated',
                        value: 'May 2026',
                      ),
                      _InfoRow(
                        icon: Icons.devices_rounded,
                        iconColor: Color(0xFF0EA5E9),
                        label: 'Platform',
                        value: 'iOS & Android',
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: Sp.xl),

                  // ── Mission ──
                  _SectionLabel('OUR MISSION'),
                  const SizedBox(height: Sp.sm),
                  _MissionCard(),

                  const SizedBox(height: Sp.xl),

                  // ── What's new ──
                  _SectionLabel("WHAT'S NEW"),
                  const SizedBox(height: Sp.sm),
                  _ChangelogCard(),

                  const SizedBox(height: Sp.xl),

                  // ── Highlights ──
                  _SectionLabel('HIGHLIGHTS'),
                  const SizedBox(height: Sp.sm),
                  _StatsGrid(),

                  const SizedBox(height: Sp.xl),

                  // ── Meet the team ──
                  _SectionLabel('MEET THE TEAM'),
                  const SizedBox(height: Sp.sm),
                  _TeamRow(),

                  const SizedBox(height: Sp.xl),

                  // ── Rate us ──
                  _SectionLabel('ENJOYING THE APP?'),
                  const SizedBox(height: Sp.sm),
                  _RateUsCard(onRate: () => _showComingSoon(context)),

                  const SizedBox(height: Sp.xl),

                  // ── Follow us ──
                  _SectionLabel('FOLLOW US'),
                  const SizedBox(height: Sp.sm),
                  _SocialRow(),

                  const SizedBox(height: Sp.xl),

                  // ── Legal ──
                  _SectionLabel('LEGAL'),
                  const SizedBox(height: Sp.sm),
                  _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.privacy_tip_outlined,
                        iconColor: const Color(0xFF0EA5E9),
                        label: 'Privacy Policy',
                        onTap: () => _showComingSoon(context),
                      ),
                      _InfoRow(
                        icon: Icons.description_outlined,
                        iconColor: AppColors.warning,
                        label: 'Terms of Service',
                        onTap: () => _showComingSoon(context),
                      ),
                      _InfoRow(
                        icon: Icons.code_rounded,
                        iconColor: AppColors.textTertiary,
                        label: 'Open Source Licenses',
                        onTap: () => _showComingSoon(context),
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: Sp.xl),
                  _MadeWithLove(),
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

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Coming soon'),
        backgroundColor: AppColors.accentDeep,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rd.lg),
        ),
      ),
    );
  }
}

// ── Animated Header ───────────────────────────────────────────────────────────

class _AboutHeader extends StatefulWidget {
  @override
  State<_AboutHeader> createState() => _AboutHeaderState();
}

class _AboutHeaderState extends State<_AboutHeader>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _rotateCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _entryCtrl;

  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;
  late final Animation<double> _scaleIn;

  @override
  void initState() {
    super.initState();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
    _scaleIn = Tween<double>(begin: 0.80, end: 1.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    _rotateCtrl.dispose();
    _shimmerCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0E0A00), Color(0xFF1C1400), Color(0xFF3D2E00)],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // ── Floating orbs ──
          _FloatingOrb(ctrl: _floatCtrl, size: 200, top: -60, right: -50, phase: 0),
          _FloatingOrb(ctrl: _floatCtrl, size: 130, bottom: -40, left: -30, phase: math.pi * 0.6),
          _FloatingOrb(ctrl: _floatCtrl, size: 80, top: 60, right: 40, phase: math.pi, alpha: 0.05),
          _FloatingOrb(ctrl: _floatCtrl, size: 50, bottom: 60, right: 100, phase: math.pi * 1.4, alpha: 0.04),

          // ── Shimmer sweep ──
          AnimatedBuilder(
            animation: _shimmerCtrl,
            builder: (_, __) => Positioned(
              top: 0,
              bottom: 0,
              left: -80 + _shimmerCtrl.value * (MediaQuery.of(context).size.width + 160),
              child: Transform.rotate(
                angle: 0.25,
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.accent.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Scattered dots ──
          ..._buildDots(),

          // ── Content ──
          SafeArea(
            bottom: false,
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(Sp.base, 52, Sp.base, Sp.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo stack: outer rotating ring + pulse glow + icon
                      ScaleTransition(
                        scale: _scaleIn,
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer rotating dashed ring
                              AnimatedBuilder(
                                animation: _rotateCtrl,
                                builder: (_, __) => Transform.rotate(
                                  angle: _rotateCtrl.value * 2 * math.pi,
                                  child: CustomPaint(
                                    size: const Size(108, 108),
                                    painter: _DashedRingPainter(
                                      color: AppColors.accent.withValues(alpha: 0.35),
                                      strokeWidth: 1.2,
                                      dashCount: 16,
                                    ),
                                  ),
                                ),
                              ),
                              // Pulse glow ring
                              AnimatedBuilder(
                                animation: _pulseCtrl,
                                builder: (_, __) => Container(
                                  width: 88 + _pulseCtrl.value * 8,
                                  height: 88 + _pulseCtrl.value * 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.accent.withValues(
                                          alpha: 0.18 + _pulseCtrl.value * 0.22,
                                        ),
                                        blurRadius: 20 + _pulseCtrl.value * 16,
                                        spreadRadius: 2 + _pulseCtrl.value * 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Icon box with float
                              AnimatedBuilder(
                                animation: _floatCtrl,
                                builder: (_, child) => Transform.translate(
                                  offset: Offset(
                                    0,
                                    math.sin(_floatCtrl.value * math.pi) * 4,
                                  ),
                                  child: child,
                                ),
                                child: Container(
                                  width: 76,
                                  height: 76,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.goldGradient,
                                    borderRadius: BorderRadius.circular(Rd.xxl),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.accent.withValues(alpha: 0.50),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '🍽️',
                                      style: TextStyle(fontSize: 36),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: Sp.lg),

                      // App name with shimmer
                      AnimatedBuilder(
                        animation: _shimmerCtrl,
                        builder: (_, __) => ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => LinearGradient(
                            colors: const [
                              Colors.white,
                              AppColors.accent,
                              Colors.white,
                            ],
                            stops: [
                              (_shimmerCtrl.value - 0.35).clamp(0.0, 1.0),
                              _shimmerCtrl.value.clamp(0.0, 1.0),
                              (_shimmerCtrl.value + 0.35).clamp(0.0, 1.0),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'RestaurantApp',
                            style: AppTextStyles.cardTitle.copyWith(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Crafted for food lovers',
                        style: AppTextStyles.bodySm.copyWith(
                          color: Colors.white54,
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(height: Sp.lg),

                      // Stat pills row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StatPill(emoji: '🏷️', text: 'v1.0.0'),
                          const SizedBox(width: Sp.sm),
                          _StatPill(emoji: '⭐', text: '4.9 Rating'),
                          const SizedBox(width: Sp.sm),
                          _StatPill(emoji: '🚀', text: 'Since 2026'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDots() {
    final positions = <({double? top, double? bottom, double? left, double? right})>[
      (top: 40.0, bottom: null, left: 30.0, right: null),
      (top: 80.0, bottom: null, left: 80.0, right: null),
      (top: 30.0, bottom: null, left: null, right: 120.0),
      (top: null, bottom: 50.0, left: 60.0, right: null),
      (top: null, bottom: 80.0, left: null, right: 60.0),
    ];
    return positions.asMap().entries.map((e) {
      final i = e.key;
      final p = e.value;
      return AnimatedBuilder(
        animation: _pulseCtrl,
        builder: (_, __) {
          final opacity = 0.10 +
              math.sin(_pulseCtrl.value * math.pi + i * 1.2) * 0.10;
          return Positioned(
            top: p.top,
            left: p.left,
            right: p.right,
            bottom: p.bottom,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: opacity),
              ),
            ),
          );
        },
      );
    }).toList();
  }
}

// ── Dashed ring painter ───────────────────────────────────────────────────────

class _DashedRingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;

  const _DashedRingPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;
    final dashAngle = (2 * math.pi) / dashCount;
    final gapFraction = 0.40;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final sweepAngle = dashAngle * (1 - gapFraction);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.dashCount != dashCount;
}

// ── Stat pill ────────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final String emoji;
  final String text;
  const _StatPill({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sp.md, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(Rd.pill),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.30),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 5),
          Text(
            text,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.accent,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Floating orb ─────────────────────────────────────────────────────────────

class _FloatingOrb extends StatelessWidget {
  final AnimationController ctrl;
  final double size;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double phase;
  final double alpha;

  const _FloatingOrb({
    required this.ctrl,
    required this.size,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.phase,
    this.alpha = 0.08,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final dy = math.sin(ctrl.value * math.pi + phase) * 12;
        return Positioned(
          top: top != null ? top! + dy : null,
          bottom: bottom != null ? bottom! - dy : null,
          left: left,
          right: right,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withValues(alpha: alpha),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: alpha + 0.06),
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Mission card ──────────────────────────────────────────────────────────────

class _MissionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sp.base),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1C1400), Color(0xFF3D2E00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Rd.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(Rd.md),
                ),
                child: const Center(
                  child: Text('🎯', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: Sp.md),
              Text(
                'What drives us',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: Sp.md),
          Text(
            '"We believe every meal should be a moment worth remembering. Our mission is to connect great food with the people who love it — effortlessly, every single day."',
            style: AppTextStyles.bodyMd.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.65,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: Sp.md),
          Divider(color: AppColors.accent.withValues(alpha: 0.20), height: 1),
          const SizedBox(height: Sp.md),
          Wrap(
            spacing: Sp.sm,
            runSpacing: Sp.sm,
            children: const [
              _MissionPill(emoji: '🌍', label: 'Global vision'),
              _MissionPill(emoji: '🤝', label: 'Community first'),
              _MissionPill(emoji: '✨', label: 'Quality always'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MissionPill extends StatelessWidget {
  final String emoji;
  final String label;
  const _MissionPill({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sp.sm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(Rd.pill),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 11)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.accent,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Changelog card ────────────────────────────────────────────────────────────

class _ChangelogCard extends StatelessWidget {
  static const _entries = [
    (
      version: 'v1.0.0',
      date: 'May 2026',
      tag: 'Latest',
      color: AppColors.success,
      note: 'Full launch — menu browsing, loyalty rewards, order tracking, dark mode & saved addresses.',
    ),
    (
      version: 'v0.9.0',
      date: 'Apr 2026',
      tag: 'Beta',
      color: AppColors.warning,
      note: 'Added favourites, payment methods, notifications and Help Center.',
    ),
    (
      version: 'v0.8.0',
      date: 'Mar 2026',
      tag: 'Alpha',
      color: Color(0xFF6366F1),
      note: 'Core ordering flow, cart, and payment integration established.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xl),
        border: Border.all(color: colors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_entries.length, (i) {
          final e = _entries[i];
          final isLast = i == _entries.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sp.base,
                  vertical: Sp.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline dot + line
                    Column(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: e.color,
                            boxShadow: [
                              BoxShadow(
                                color: e.color.withValues(alpha: 0.40),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 1.5,
                            height: 48,
                            color: colors.divider,
                          ),
                      ],
                    ),
                    const SizedBox(width: Sp.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                e.version,
                                style: AppTextStyles.labelMd.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: Sp.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: e.color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(Rd.pill),
                                  border: Border.all(
                                    color: e.color.withValues(alpha: 0.30),
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  e.tag,
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: e.color,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                e.date,
                                style: AppTextStyles.labelSm.copyWith(
                                  color: colors.textTertiary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            e.note,
                            style: AppTextStyles.bodySm.copyWith(
                              color: colors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ── Stats grid ────────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  static const _stats = [
    (emoji: '🍽️', value: '60+', label: 'Menu Items'),
    (emoji: '⭐', value: '4.9', label: 'App Rating'),
    (emoji: '🛵', value: '30 min', label: 'Avg Delivery'),
    (emoji: '🏆', value: '3 Tiers', label: 'Loyalty Tiers'),
    (emoji: '😊', value: '10K+', label: 'Happy Customers'),
    (emoji: '🎁', value: '500+', label: 'Rewards Claimed'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: Sp.sm,
      crossAxisSpacing: Sp.sm,
      childAspectRatio: 2.1,
      children: _stats.map((s) {
        return Container(
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: BorderRadius.circular(Rd.xl),
            border: Border.all(color: colors.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: Sp.md, vertical: Sp.sm),
          child: Row(
            children: [
              Text(s.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: Sp.sm),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.value,
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.accentDeep,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      s.label,
                      style: AppTextStyles.labelSm.copyWith(
                        color: colors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Team row ─────────────────────────────────────────────────────────────────

class _TeamRow extends StatelessWidget {
  static const _team = [
    (emoji: '👨‍💻', name: 'Alex Chen', role: 'Lead Dev', color: Color(0xFF6366F1)),
    (emoji: '🎨', name: 'Sarah Kim', role: 'UI Design', color: Color(0xFFEC4899)),
    (emoji: '🍳', name: 'Marco Rossi', role: 'Menu Curator', color: AppColors.warning),
    (emoji: '📊', name: 'Priya Patel', role: 'Product', color: AppColors.success),
    (emoji: '🛡️', name: 'Tom Wright', role: 'Security', color: Color(0xFF0EA5E9)),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _team.length,
        separatorBuilder: (_, __) => const SizedBox(width: Sp.sm),
        itemBuilder: (_, i) {
          final m = _team[i];
          return Container(
            width: 88,
            padding: const EdgeInsets.symmetric(vertical: Sp.md, horizontal: Sp.sm),
            decoration: BoxDecoration(
              color: colors.bgSecondary,
              borderRadius: BorderRadius.circular(Rd.xl),
              border: Border.all(color: colors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: m.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: m.color.withValues(alpha: 0.30),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(m.emoji, style: const TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  m.name.split(' ').first,
                  style: AppTextStyles.labelSm.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                Text(
                  m.role,
                  style: AppTextStyles.labelSm.copyWith(
                    color: colors.textTertiary,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Rate us card ──────────────────────────────────────────────────────────────

class _RateUsCard extends StatefulWidget {
  final VoidCallback onRate;
  const _RateUsCard({required this.onRate});

  @override
  State<_RateUsCard> createState() => _RateUsCardState();
}

class _RateUsCardState extends State<_RateUsCard> {
  int _tapped = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Sp.base),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xl),
        border: Border.all(color: colors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('🌟', style: TextStyle(fontSize: 28)),
              const SizedBox(width: Sp.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Love using the app?',
                      style: AppTextStyles.labelMd.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Your rating helps us grow and improve.',
                      style: AppTextStyles.bodySm.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Sp.md),
          // Interactive star row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < (_tapped == 0 ? 5 : _tapped);
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _tapped = i + 1);
                  Future.delayed(const Duration(milliseconds: 300), widget.onRate);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(
                    filled ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 34,
                    color: filled ? AppColors.accent : colors.divider,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: Sp.md),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                widget.onRate();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: Sp.md),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(Rd.xl),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Leave a Review on App Store',
                    style: AppTextStyles.labelMd.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Social row ────────────────────────────────────────────────────────────────

class _SocialRow extends StatelessWidget {
  static const _socials = [
    (icon: Icons.photo_camera_outlined, label: 'Instagram', color: Color(0xFFE1306C)),
    (icon: Icons.chat_bubble_outline_rounded, label: 'Twitter', color: Color(0xFF1DA1F2)),
    (icon: Icons.thumb_up_outlined, label: 'Facebook', color: Color(0xFF1877F2)),
    (icon: Icons.play_circle_outline_rounded, label: 'TikTok', color: Color(0xFF010101)),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: List.generate(_socials.length, (i) {
        final s = _socials[i];
        return Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${s.label}…'),
                  backgroundColor: AppColors.accentDeep,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Rd.lg),
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: i == _socials.length - 1 ? 0 : Sp.sm),
              padding: const EdgeInsets.symmetric(vertical: Sp.md),
              decoration: BoxDecoration(
                color: colors.bgSecondary,
                borderRadius: BorderRadius.circular(Rd.xl),
                border: Border.all(color: colors.divider),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(s.icon, size: 22, color: s.color),
                  const SizedBox(height: 4),
                  Text(
                    s.label,
                    style: AppTextStyles.labelSm.copyWith(
                      color: colors.textTertiary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Made with love ────────────────────────────────────────────────────────────

class _MadeWithLove extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Sp.base),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(Rd.xl),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(Rd.md),
            ),
            child: const Center(
              child: Text('❤️', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: Sp.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Made with love',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.accentDeep,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '© 2026 RestaurantApp. All rights reserved.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: colors.textTertiary,
                    fontSize: 11,
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

// ── Shared ────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(left: Sp.xs),
      child: Text(
        text,
        style: AppTextStyles.labelSm.copyWith(
          color: colors.textTertiary,
          fontSize: 10,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xl),
        border: Border.all(color: colors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.value,
    this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasTap = onTap != null;
    return Column(
      children: [
        InkWell(
          onTap: hasTap
              ? () {
                  HapticFeedback.selectionClick();
                  onTap!();
                }
              : null,
          borderRadius: BorderRadius.vertical(
            bottom: isLast ? const Radius.circular(Rd.xl) : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sp.base,
              vertical: Sp.md,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(Rd.md),
                  ),
                  child: Center(child: Icon(icon, size: 18, color: iconColor)),
                ),
                const SizedBox(width: Sp.md),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (value != null)
                  Text(
                    value!,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                if (hasTap) ...[
                  const SizedBox(width: Sp.xs),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: colors.textTertiary,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: Sp.base + 36 + Sp.md),
            child: Divider(height: 1, color: colors.divider),
          ),
      ],
    );
  }
}
