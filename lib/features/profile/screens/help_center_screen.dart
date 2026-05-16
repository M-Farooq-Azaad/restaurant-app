import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem(this.question, this.answer);
}

class _FaqCategory {
  final String id;
  final String label;
  final String emoji;
  final List<_FaqItem> items;
  const _FaqCategory({
    required this.id,
    required this.label,
    required this.emoji,
    required this.items,
  });
}

const _categories = [
  _FaqCategory(
    id: 'orders',
    label: 'Orders',
    emoji: '📦',
    items: [
      _FaqItem(
        'How do I track my order?',
        'Once your order is confirmed, go to Order History and tap your active order. You\'ll see a live map with your rider\'s location and an estimated arrival time.',
      ),
      _FaqItem(
        'Can I cancel or modify my order?',
        'You can cancel within 2 minutes of placing the order. After that, the kitchen starts preparing and cancellations aren\'t possible. To modify, cancel and re-place the order.',
      ),
      _FaqItem(
        'What if an item is missing from my order?',
        'Tap "Report Issue" on the order details page. Our support team will review and issue a refund or replacement within 24 hours.',
      ),
      _FaqItem(
        'How long does delivery take?',
        'Average delivery time is 25–35 minutes depending on your distance, weather, and order volume. You can see a live ETA once your order is out for delivery.',
      ),
    ],
  ),
  _FaqCategory(
    id: 'payments',
    label: 'Payments',
    emoji: '💳',
    items: [
      _FaqItem(
        'Which payment methods are accepted?',
        'We accept all major credit/debit cards (Visa, Mastercard, Amex), Apple Pay, Google Pay, and in-app wallet credits.',
      ),
      _FaqItem(
        'When will I be charged?',
        'Payment is captured when you place the order. For pre-orders, you\'re charged 1 hour before the scheduled delivery time.',
      ),
      _FaqItem(
        'How do refunds work?',
        'Approved refunds are returned to your original payment method within 3–5 business days. Wallet credits are issued instantly.',
      ),
    ],
  ),
  _FaqCategory(
    id: 'account',
    label: 'Account',
    emoji: '👤',
    items: [
      _FaqItem(
        'How do I reset my password?',
        'On the login screen, tap "Forgot Password" and enter your email. You\'ll receive a reset link within a few minutes. Check your spam folder if it doesn\'t arrive.',
      ),
      _FaqItem(
        'Can I have multiple delivery addresses?',
        'Yes! Go to Profile → Saved Addresses to add, edit, or remove addresses. You can save up to 5 addresses.',
      ),
      _FaqItem(
        'How do I delete my account?',
        'Account deletion requests can be sent to support@restaurantapp.com. Your account and data will be permanently deleted within 30 days.',
      ),
    ],
  ),
  _FaqCategory(
    id: 'loyalty',
    label: 'Loyalty',
    emoji: '🏆',
    items: [
      _FaqItem(
        'How do I earn points?',
        'You earn 10 points for every £1 spent. Bonus points are available on featured items, during happy hour, and on your birthday.',
      ),
      _FaqItem(
        'When do my points expire?',
        'Points expire after 12 months of account inactivity. Gold and Platinum tier members have points that never expire.',
      ),
      _FaqItem(
        'How do I redeem my points?',
        'At checkout, toggle "Use Points" to apply your balance. 100 points = £1 off. You can use points for up to 50% of the order total.',
      ),
    ],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  String _activeCategoryId = 'orders';
  String? _expandedQuestion;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_FaqItem> get _visibleItems {
    final cat = _categories.firstWhere((c) => c.id == _activeCategoryId);
    if (_query.isEmpty) return cat.items;
    final q = _query.toLowerCase();
    return cat.items
        .where(
          (i) =>
              i.question.toLowerCase().contains(q) ||
              i.answer.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.bgPrimary,
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
              'Help Center',
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Sp.base, Sp.xl, Sp.base, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroBanner(),
                  const SizedBox(height: Sp.xl),
                  _SearchBar(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: Sp.xl),
                  _CategoryTabs(
                    active: _activeCategoryId,
                    onSelect: (id) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _activeCategoryId = id;
                        _expandedQuestion = null;
                      });
                    },
                  ),
                  const SizedBox(height: Sp.base),
                  _FaqList(
                    items: _visibleItems,
                    expandedQuestion: _expandedQuestion,
                    onToggle: (q) {
                      HapticFeedback.selectionClick();
                      setState(
                        () =>
                            _expandedQuestion =
                                _expandedQuestion == q ? null : q,
                      );
                    },
                  ),
                  const SizedBox(height: Sp.xl),
                  _ContactSection(),
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

// ── Hero banner ───────────────────────────────────────────────────────────────

class _HeroBanner extends StatefulWidget {
  @override
  State<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<_HeroBanner>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _entryCtrl;
  late final AnimationController _shimmerCtrl;

  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;

  int _headlineIdx = 0;
  Timer? _headlineTimer;

  static const _headlines = [
    'How can we help you?',
    "We're here 24 / 7 for you",
    'Fast. Friendly. Resolved.',
  ];

  static const _stats = [
    (icon: '⚡', value: '< 1 hr', label: 'Response'),
    (icon: '⭐', value: '4.9★', label: 'Rating'),
    (icon: '✅', value: '98%', label: 'Resolved'),
  ];

  @override
  void initState() {
    super.initState();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    _headlineTimer = Timer.periodic(const Duration(milliseconds: 2600), (_) {
      if (mounted) {
        setState(
          () => _headlineIdx = (_headlineIdx + 1) % _headlines.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    _shimmerCtrl.dispose();
    _entryCtrl.dispose();
    _headlineTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideIn,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1C1400), Color(0xFF3D2E00), Color(0xFF1C1400)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(Rd.xxl),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.28),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // ── Floating orbs ──
              _FloatingOrb(
                ctrl: _floatCtrl,
                size: 170,
                top: -55,
                right: -30,
                phase: 0,
              ),
              _FloatingOrb(
                ctrl: _floatCtrl,
                size: 110,
                bottom: -35,
                left: -15,
                phase: math.pi / 2,
              ),
              _FloatingOrb(
                ctrl: _floatCtrl,
                size: 70,
                top: 20,
                right: 80,
                phase: math.pi,
                alpha: 0.05,
              ),

              // ── Shimmer line ──
              AnimatedBuilder(
                animation: _shimmerCtrl,
                builder: (_, __) {
                  return Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment(
                        -1.0 + _shimmerCtrl.value * 2.5,
                        0,
                      ),
                      child: Container(
                        width: 60,
                        height: 1.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.accent.withValues(alpha: 0.55),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ── Content ──
              Padding(
                padding: const EdgeInsets.fromLTRB(Sp.base, Sp.lg, Sp.base, Sp.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status badge
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: _pulseCtrl,
                          builder: (_, __) => Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.success,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.success.withValues(
                                    alpha: 0.25 + _pulseCtrl.value * 0.45,
                                  ),
                                  blurRadius: 4 + _pulseCtrl.value * 6,
                                  spreadRadius: _pulseCtrl.value * 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Support Online',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.success,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sp.sm,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(Rd.pill),
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.35),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            '24 / 7',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.accent,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Sp.md),

                    // Icon + cycling headline
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Animated icon box
                        AnimatedBuilder(
                          animation: _floatCtrl,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(
                              0,
                              math.sin(_floatCtrl.value * math.pi) * 3,
                            ),
                            child: child,
                          ),
                          child: Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.accent.withValues(alpha: 0.30),
                                  AppColors.accent.withValues(alpha: 0.12),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(Rd.lg),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.35),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '🤝',
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: Sp.md),

                        // Cycling headline
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (child, anim) =>
                                    FadeTransition(
                                  opacity: anim,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.25),
                                      end: Offset.zero,
                                    ).animate(anim),
                                    child: child,
                                  ),
                                ),
                                child: Text(
                                  _headlines[_headlineIdx],
                                  key: ValueKey(_headlineIdx),
                                  style: AppTextStyles.cardTitle.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Browse FAQs or reach out directly.',
                                style: AppTextStyles.bodySm.copyWith(
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Sp.lg),

                    // Divider
                    Divider(
                      height: 1,
                      color: AppColors.accent.withValues(alpha: 0.20),
                    ),

                    const SizedBox(height: Sp.md),

                    // Stats row
                    Row(
                      children: List.generate(_stats.length, (i) {
                        final s = _stats[i];
                        final isLast = i == _stats.length - 1;
                        return Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      s.icon,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      s.value,
                                      style: AppTextStyles.labelMd.copyWith(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      s.label,
                                      style: AppTextStyles.labelSm.copyWith(
                                        color: Colors.white38,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isLast)
                                Container(
                                  width: 1,
                                  height: 36,
                                  color: AppColors.accent.withValues(alpha: 0.18),
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Floating orb ──────────────────────────────────────────────────────────────

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
        final dy = math.sin(ctrl.value * math.pi + phase) * 10;
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

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.pill),
        border: Border.all(color: colors.divider),
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
          const SizedBox(width: Sp.base),
          Icon(Icons.search_rounded, size: 20, color: colors.textTertiary),
          const SizedBox(width: Sp.sm),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTextStyles.bodyMd.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search FAQs…',
                hintStyle: AppTextStyles.bodyMd.copyWith(
                  color: colors.textTertiary,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onChanged('');
              },
              child: Padding(
                padding: const EdgeInsets.only(right: Sp.sm),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: colors.textTertiary,
                ),
              ),
            ),
          const SizedBox(width: Sp.sm),
        ],
      ),
    );
  }
}

// ── Category tabs ─────────────────────────────────────────────────────────────

class _CategoryTabs extends StatelessWidget {
  final String active;
  final ValueChanged<String> onSelect;

  const _CategoryTabs({required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: Sp.sm),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final isSelected = cat.id == active;
          return GestureDetector(
            onTap: () => onSelect(cat.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                horizontal: Sp.base,
                vertical: Sp.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentDeep : context.colors.bgSecondary,
                borderRadius: BorderRadius.circular(Rd.pill),
                border: Border.all(
                  color: isSelected
                      ? AppColors.accentDeep
                      : context.colors.divider,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.accentDeep.withValues(alpha: 0.30),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(cat.emoji, style: const TextStyle(fontSize: 15)),
                  const SizedBox(width: 6),
                  Text(
                    cat.label,
                    style: AppTextStyles.labelMd.copyWith(
                      color: isSelected ? Colors.white : context.colors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── FAQ list ──────────────────────────────────────────────────────────────────

class _FaqList extends StatelessWidget {
  final List<_FaqItem> items;
  final String? expandedQuestion;
  final ValueChanged<String> onToggle;

  const _FaqList({
    required this.items,
    required this.expandedQuestion,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Sp.xxl),
        child: Center(
          child: Column(
            children: [
              const Text('🔍', style: TextStyle(fontSize: 40)),
              const SizedBox(height: Sp.md),
              Text(
                'No results found',
                style: AppTextStyles.cardTitle.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: Sp.xs),
              Text(
                'Try a different keyword or browse a category.',
                style: AppTextStyles.bodySm.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isExpanded = expandedQuestion == item.question;
          final isLast = i == items.length - 1;
          return _FaqTile(
            item: item,
            isExpanded: isExpanded,
            isLast: isLast,
            onTap: () => onToggle(item.question),
          );
        }),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final _FaqItem item;
  final bool isExpanded;
  final bool isLast;
  final VoidCallback onTap;

  const _FaqTile({
    required this.item,
    required this.isExpanded,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(
            top: Radius.zero,
            bottom: (isLast && !isExpanded)
                ? const Radius.circular(Rd.xl)
                : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sp.base,
              vertical: Sp.md,
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isExpanded
                        ? AppColors.accentSoft
                        : colors.bgTertiary,
                    borderRadius: BorderRadius.circular(Rd.md),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 16,
                      color: isExpanded
                          ? AppColors.accentDeep
                          : colors.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(width: Sp.md),
                Expanded(
                  child: Text(
                    item.question,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: isExpanded
                          ? AppColors.accentDeep
                          : colors.textPrimary,
                      fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: Sp.sm),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: isExpanded ? AppColors.accentDeep : colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isExpanded
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(
                    Sp.base,
                    0,
                    Sp.base,
                    Sp.md,
                  ),
                  padding: const EdgeInsets.all(Sp.md),
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(Rd.lg),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    item.answer,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.accentDeep,
                      height: 1.55,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sp.base),
            child: Divider(height: 1, color: colors.divider),
          ),
      ],
    );
  }
}

// ── Contact section ───────────────────────────────────────────────────────────

class _ContactSection extends StatelessWidget {
  static const _options = [
    (
      icon: Icons.chat_bubble_outline_rounded,
      color: AppColors.success,
      title: 'Live Chat',
      subtitle: 'Typically replies in < 5 min',
    ),
    (
      icon: Icons.email_outlined,
      color: Color(0xFF6366F1),
      title: 'Email Us',
      subtitle: 'support@restaurantapp.com',
    ),
    (
      icon: Icons.phone_outlined,
      color: AppColors.warning,
      title: 'Call Us',
      subtitle: 'Mon–Fri, 9 AM – 9 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Sp.xs, bottom: Sp.sm),
          child: Text(
            'STILL NEED HELP?',
            style: AppTextStyles.labelSm.copyWith(
              color: colors.textTertiary,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
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
            children: List.generate(_options.length, (i) {
              final opt = _options[i];
              final isLast = i == _options.length - 1;
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening ${opt.title}…'),
                          backgroundColor: AppColors.accentDeep,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Rd.lg),
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.vertical(
                      bottom: isLast
                          ? const Radius.circular(Rd.xl)
                          : Radius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sp.base,
                        vertical: Sp.md,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: opt.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(Rd.md),
                            ),
                            child: Center(
                              child: Icon(
                                opt.icon,
                                size: 20,
                                color: opt.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: Sp.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  opt.title,
                                  style: AppTextStyles.bodyLg.copyWith(
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  opt.subtitle,
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: colors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: colors.textTertiary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Padding(
                      padding: const EdgeInsets.only(left: Sp.base + 42 + Sp.md),
                      child: Divider(height: 1, color: colors.divider),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
