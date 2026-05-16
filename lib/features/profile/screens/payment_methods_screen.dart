import 'dart:math' show pi, cos, sin;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../mock/mock_data.dart';

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
      holderName: MockData.currentUser.fullName.toUpperCase(),
      last4: '4242',
      expiry: '08/27',
      isDefault: true,
      themeIndex: 0,
    ),
    _PaymentMethod(
      id: '2',
      type: _CardType.mastercard,
      holderName: MockData.currentUser.fullName.toUpperCase(),
      last4: '5555',
      expiry: '12/26',
      isDefault: false,
      themeIndex: 1,
    ),
    _PaymentMethod(
      id: '3',
      type: _CardType.cash,
      holderName: '',
      last4: '',
      expiry: '',
      isDefault: false,
      themeIndex: 0,
    ),
  ];

  void _setDefault(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      for (final m in _methods) {
        m.isDefault = m.id == id;
      }
    });
    _showSnackBar('Default payment method updated');
  }

  void _delete(String id) {
    setState(() => _methods.removeWhere((m) => m.id == id));
    _showSnackBar('Payment method removed');
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

  void _confirmDelete(_PaymentMethod method) {
    HapticFeedback.mediumImpact();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rd.xl),
        ),
        title: Text(
          'Remove Card',
          style: AppTextStyles.cardTitle.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        content: Text(
          method.type == _CardType.cash
              ? 'Remove Cash on Delivery option?'
              : 'Remove ${method.type.name[0].toUpperCase()}${method.type.name.substring(1)} ending in ${method.last4}? This cannot be undone.',
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
              _delete(method.id);
            },
            child: Text(
              'Remove',
              style: AppTextStyles.labelMd.copyWith(color: AppColors.error),
            ),
          ),
        ],
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
          _confirmDelete(method);
        },
      ),
    );
  }

  void _showAddForm() {
    final cardCount = _methods.where((m) => m.type != _CardType.cash).length;
    final nextTheme = cardCount % 10;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddPaymentFormSheet(
        themeIndex: nextTheme,
        onSave: (method) {
          setState(() => _methods.insert(_methods.length - 1, method));
          _showSnackBar('Card added successfully');
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
              'Payment Methods',
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Sp.base, Sp.base, Sp.base, 0),
              child: Column(
                children: [
                  const SizedBox(height: Sp.sm),
                  if (_methods.isEmpty) const _EmptyState(),
                  ...List.generate(_methods.length, (i) {
                    final method = _methods[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Sp.base),
                      child: method.type == _CardType.cash
                          ? _CashCard(
                              method: method,
                              onTap: () => _showOptions(method),
                            )
                          : _CreditCardWidget(
                              method: method,
                              onTap: () => _showOptions(method),
                            ),
                    );
                  }),
                  const SizedBox(height: Sp.sm),
                  PrimaryButton(
                    label: 'Add Payment Method',
                    onPressed: _showAddForm,
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

// ── Model ─────────────────────────────────────────────────────────────────────

enum _CardType { visa, mastercard, cash }

class _PaymentMethod {
  final String id;
  final _CardType type;
  final String holderName;
  final String last4;
  final String expiry;
  bool isDefault;
  final int themeIndex;

  _PaymentMethod({
    required this.id,
    required this.type,
    required this.holderName,
    required this.last4,
    required this.expiry,
    required this.isDefault,
    required this.themeIndex,
  });
}

// ── Card themes ───────────────────────────────────────────────────────────────

class _CardTheme {
  final LinearGradient gradient;
  final Color shadow;

  const _CardTheme({required this.gradient, required this.shadow});
}

const _cardThemes = <_CardTheme>[
  // 0: Ocean Blue — twin circles
  _CardTheme(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1E3A8A), Color(0xFF2563EB), Color(0xFF3B82F6)],
    ),
    shadow: Color(0xFF1E3A8A),
  ),
  // 1: Midnight Slate — arc rings
  _CardTheme(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
    ),
    shadow: Color(0xFF0F172A),
  ),
  // 2: Royal Violet — diagonal band
  _CardTheme(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4C1D95), Color(0xFF6D28D9), Color(0xFF8B5CF6)],
    ),
    shadow: Color(0xFF4C1D95),
  ),
  // 3: Forest Green — wave
  _CardTheme(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF064E3B), Color(0xFF065F46), Color(0xFF059669)],
    ),
    shadow: Color(0xFF064E3B),
  ),
  // 4: Crimson Rose — dot cloud
  _CardTheme(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFF881337), Color(0xFFBE185D), Color(0xFFE11D48)],
    ),
    shadow: Color(0xFF881337),
  ),
  // 5: Amber Gold — triple bubbles
  _CardTheme(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF78350F), Color(0xFFB45309), Color(0xFFD97706)],
    ),
    shadow: Color(0xFF78350F),
  ),
  // 6: Deep Teal — rotated diamonds
  _CardTheme(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
      colors: [Color(0xFF134E4A), Color(0xFF0F766E), Color(0xFF0D9488)],
    ),
    shadow: Color(0xFF134E4A),
  ),
  // 7: Navy Indigo — fan lines
  _CardTheme(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF1E1B4B), Color(0xFF3730A3), Color(0xFF4F46E5)],
    ),
    shadow: Color(0xFF1E1B4B),
  ),
  // 8: Jade — diagonal stripes
  _CardTheme(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF14532D), Color(0xFF15803D), Color(0xFF16A34A)],
    ),
    shadow: Color(0xFF14532D),
  ),
  // 9: Purple Haze — concentric ring halos
  _CardTheme(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFF3B0764), Color(0xFF6B21A8), Color(0xFF9333EA)],
    ),
    shadow: Color(0xFF3B0764),
  ),
];

// ── Credit card widget ────────────────────────────────────────────────────────

class _CreditCardWidget extends StatelessWidget {
  final _PaymentMethod method;
  final VoidCallback onTap;

  const _CreditCardWidget({required this.method, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = _cardThemes[method.themeIndex % _cardThemes.length];
    final expParts = method.expiry.split('/');
    final expiryLabel = '${expParts[0]} / ${expParts[1]}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 210,
        decoration: BoxDecoration(
          gradient: theme.gradient,
          borderRadius: BorderRadius.circular(Rd.xxl),
          boxShadow: [
            BoxShadow(
              color: theme.shadow.withValues(alpha: 0.50),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: theme.shadow.withValues(alpha: 0.20),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Rd.xxl),
          child: Stack(
            children: [
              // Pattern layer
              Positioned.fill(
                child: CustomPaint(
                  painter: _CardPatternPainter(method.themeIndex),
                ),
              ),
              // Card content
              Padding(
                padding: const EdgeInsets.fromLTRB(Sp.xl, Sp.lg, Sp.xl, Sp.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Debit',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.80),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const Spacer(),
                        if (method.isDefault) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              borderRadius: BorderRadius.circular(Rd.pill),
                            ),
                            child: Text(
                              'Default',
                              style: AppTextStyles.labelSm.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: Sp.sm),
                        ],
                        _NetworkLogo(type: method.type),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '**** **** **** ${method.last4}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: Sp.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            method.holderName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: Sp.base),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'VALID THRU',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.55),
                                fontSize: 8,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              expiryLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ],
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

// ── Card pattern painter ──────────────────────────────────────────────────────

class _CardPatternPainter extends CustomPainter {
  final int pattern;

  const _CardPatternPainter(this.pattern);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.fill;
    switch (pattern % 10) {
      case 0:
        _twinCircles(canvas, size, p);
      case 1:
        _arcRings(canvas, size, p);
      case 2:
        _diagonalBand(canvas, size, p);
      case 3:
        _wave(canvas, size, p);
      case 4:
        _dotCloud(canvas, size, p);
      case 5:
        _tripleBubbles(canvas, size, p);
      case 6:
        _rotatedDiamonds(canvas, size, p);
      case 7:
        _fanLines(canvas, size, p);
      case 8:
        _diagonalStripes(canvas, size, p);
      case 9:
        _ringHalos(canvas, size, p);
    }
  }

  // 0: Two large filled circles on the right side
  void _twinCircles(Canvas c, Size s, Paint p) {
    p.color = Colors.white.withValues(alpha: 0.10);
    c.drawCircle(Offset(s.width + 30, s.height * 0.50), 130, p);
    p.color = Colors.white.withValues(alpha: 0.07);
    c.drawCircle(Offset(s.width - 40, s.height * 0.32), 80, p);
  }

  // 1: Concentric arc strokes from top-right corner
  void _arcRings(Canvas c, Size s, Paint p) {
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 1.2;
    final center = Offset(s.width, 0);
    for (int i = 0; i < 5; i++) {
      p.color = Colors.white.withValues(alpha: 0.06 + i * 0.02);
      c.drawArc(
        Rect.fromCircle(center: center, radius: 60.0 + i * 50),
        pi * 0.5,
        pi * 0.5,
        false,
        p,
      );
    }
  }

  // 2: Diagonal band sweeping across the right portion
  void _diagonalBand(Canvas c, Size s, Paint p) {
    p.color = Colors.white.withValues(alpha: 0.10);
    final path = Path()
      ..moveTo(s.width * 0.30, 0)
      ..lineTo(s.width, 0)
      ..lineTo(s.width * 0.70, s.height)
      ..lineTo(0, s.height)
      ..close();
    c.drawPath(path, p);
    p.color = Colors.white.withValues(alpha: 0.06);
    final path2 = Path()
      ..moveTo(s.width * 0.60, 0)
      ..lineTo(s.width, 0)
      ..lineTo(s.width, s.height * 0.55)
      ..close();
    c.drawPath(path2, p);
  }

  // 3: Bezier wave filling the lower half
  void _wave(Canvas c, Size s, Paint p) {
    p.color = Colors.white.withValues(alpha: 0.09);
    final path = Path()
      ..moveTo(0, s.height * 0.58)
      ..cubicTo(
        s.width * 0.28,
        s.height * 0.38,
        s.width * 0.62,
        s.height * 0.74,
        s.width,
        s.height * 0.50,
      )
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    c.drawPath(path, p);
    p.color = Colors.white.withValues(alpha: 0.05);
    final path2 = Path()
      ..moveTo(0, s.height * 0.76)
      ..cubicTo(
        s.width * 0.22,
        s.height * 0.62,
        s.width * 0.78,
        s.height * 0.90,
        s.width,
        s.height * 0.72,
      )
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    c.drawPath(path2, p);
  }

  // 4: Scattered small-to-medium circles
  void _dotCloud(Canvas c, Size s, Paint p) {
    const dots = [
      [0.80, 0.15, 32.0, 0.09],
      [0.96, 0.48, 22.0, 0.07],
      [0.68, 0.72, 42.0, 0.06],
      [0.88, 0.84, 16.0, 0.08],
      [0.54, 0.22, 18.0, 0.05],
      [0.93, 0.64, 26.0, 0.06],
      [0.62, 0.88, 14.0, 0.07],
      [0.76, 0.50, 10.0, 0.05],
    ];
    for (final d in dots) {
      p.color = Colors.white.withValues(alpha: d[3]);
      c.drawCircle(Offset(s.width * d[0], s.height * d[1]), d[2], p);
    }
  }

  // 5: Three large overlapping circles in a horizontal row
  void _tripleBubbles(Canvas c, Size s, Paint p) {
    p.color = Colors.white.withValues(alpha: 0.08);
    for (int i = 0; i < 3; i++) {
      c.drawCircle(
        Offset(s.width * (0.38 + i * 0.26), s.height * 0.52),
        65,
        p,
      );
    }
  }

  // 6: Two rotated diamonds (squares at 45°)
  void _rotatedDiamonds(Canvas c, Size s, Paint p) {
    p.color = Colors.white.withValues(alpha: 0.09);
    c.save();
    c.translate(s.width * 0.78, s.height * 0.50);
    c.rotate(pi / 4);
    c.drawRect(Rect.fromCenter(center: Offset.zero, width: 120, height: 120), p);
    c.restore();

    p.color = Colors.white.withValues(alpha: 0.05);
    c.save();
    c.translate(s.width * 0.48, s.height * 0.50);
    c.rotate(pi / 4);
    c.drawRect(Rect.fromCenter(center: Offset.zero, width: 82, height: 82), p);
    c.restore();
  }

  // 7: Radiating fan lines from top-right corner
  void _fanLines(Canvas c, Size s, Paint p) {
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 22;
    p.strokeCap = StrokeCap.butt;
    final origin = Offset(s.width * 1.04, -s.height * 0.08);
    const angles = [
      pi * 0.62,
      pi * 0.70,
      pi * 0.78,
      pi * 0.86,
      pi * 0.94,
      pi * 1.02,
    ];
    for (int i = 0; i < angles.length; i++) {
      p.color = Colors.white.withValues(alpha: 0.04 + i * 0.012);
      c.drawLine(
        origin,
        Offset(
          origin.dx + cos(angles[i]) * s.width * 2.2,
          origin.dy + sin(angles[i]) * s.height * 3.0,
        ),
        p,
      );
    }
  }

  // 8: Diagonal stripe bands at ~30° tilt
  void _diagonalStripes(Canvas c, Size s, Paint p) {
    p.color = Colors.white.withValues(alpha: 0.07);
    c.save();
    c.translate(s.width * 0.5, s.height * 0.5);
    c.rotate(-pi / 6);
    for (int i = -3; i <= 4; i++) {
      if (i.isOdd) {
        c.drawRect(
          Rect.fromLTWH(
            i * 38.0 - 14,
            -s.height * 1.5,
            22,
            s.height * 3,
          ),
          p,
        );
      }
    }
    c.restore();
  }

  // 9: Concentric ring outlines centered on the right
  void _ringHalos(Canvas c, Size s, Paint p) {
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 1.2;
    final center = Offset(s.width * 0.78, s.height * 0.50);
    for (int i = 0; i < 5; i++) {
      p.color = Colors.white.withValues(alpha: 0.05 + i * 0.02);
      c.drawCircle(center, 28.0 + i * 32, p);
    }
  }

  @override
  bool shouldRepaint(_CardPatternPainter old) => old.pattern != pattern;
}

// ── Network logo ──────────────────────────────────────────────────────────────

class _NetworkLogo extends StatelessWidget {
  final _CardType type;

  const _NetworkLogo({required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == _CardType.mastercard) {
      return SizedBox(
        width: 50,
        height: 32,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEB001B).withValues(alpha: 0.92),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF79E1B).withValues(alpha: 0.88),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Text(
      'VISA',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.95),
        fontSize: 22,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
        letterSpacing: 1.5,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.30),
            offset: const Offset(1, 1),
            blurRadius: 3,
          ),
        ],
      ),
    );
  }
}

// ── Cash on Delivery card ─────────────────────────────────────────────────────

class _CashCard extends StatelessWidget {
  final _PaymentMethod method;
  final VoidCallback onTap;

  const _CashCard({required this.method, required this.onTap});

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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Rd.md),
              ),
              child: const Center(
                child: Icon(
                  Icons.payments_outlined,
                  size: 24,
                  color: AppColors.success,
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
                        'Cash on Delivery',
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
                    'Pay when your order arrives',
                    style: AppTextStyles.bodySm.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.more_vert_rounded, size: 20, color: colors.textTertiary),
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
    final name = method.type == _CardType.cash
        ? 'Cash on Delivery'
        : '${method.type.name[0].toUpperCase()}${method.type.name.substring(1)} ••${method.last4}';
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
              name,
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
      title: Text(label, style: AppTextStyles.bodyLg.copyWith(color: color)),
      onTap: onTap,
    );
  }
}

// ── Add payment form sheet ────────────────────────────────────────────────────

class _AddPaymentFormSheet extends StatefulWidget {
  final int themeIndex;
  final void Function(_PaymentMethod) onSave;

  const _AddPaymentFormSheet({
    required this.themeIndex,
    required this.onSave,
  });

  @override
  State<_AddPaymentFormSheet> createState() => _AddPaymentFormSheetState();
}

class _AddPaymentFormSheetState extends State<_AddPaymentFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _numberCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _numberCtrl.dispose();
    _nameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  _CardType _detectType(String number) {
    final digits = number.replaceAll(' ', '');
    if (digits.startsWith('4')) return _CardType.visa;
    if (digits.startsWith('5')) return _CardType.mastercard;
    return _CardType.visa;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();
    final digits = _numberCtrl.text.replaceAll(' ', '');
    final last4 = digits.substring(digits.length - 4);
    final method = _PaymentMethod(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _detectType(_numberCtrl.text),
      holderName: _nameCtrl.text.trim().toUpperCase(),
      last4: last4,
      expiry: _expiryCtrl.text.trim(),
      isDefault: false,
      themeIndex: widget.themeIndex,
    );
    widget.onSave(method);
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
              'Add Card',
              style: AppTextStyles.cardTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: Sp.base),
            _PayFormField(
              label: 'CARD NUMBER',
              controller: _numberCtrl,
              hint: '1234 5678 9012 3456',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: [_CardNumberFormatter()],
              validator: (v) {
                final digits = (v ?? '').replaceAll(' ', '');
                if (digits.length != 16) return 'Enter a valid 16-digit number';
                return null;
              },
            ),
            const SizedBox(height: Sp.sm),
            _PayFormField(
              label: 'NAME ON CARD',
              controller: _nameCtrl,
              hint: 'e.g. Farooq Jutt',
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: Sp.sm),
            Row(
              children: [
                Expanded(
                  child: _PayFormField(
                    label: 'EXPIRY',
                    controller: _expiryCtrl,
                    hint: 'MM/YY',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [_ExpiryFormatter()],
                    validator: (v) {
                      if (v == null || v.length != 5) return 'MM/YY required';
                      final mm = int.tryParse(v.substring(0, 2)) ?? 0;
                      if (mm < 1 || mm > 12) return 'Invalid month';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: Sp.sm),
                Expanded(
                  child: _PayFormField(
                    label: 'CVV',
                    controller: _cvvCtrl,
                    hint: '•••',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    obscureText: true,
                    validator: (v) =>
                        v == null || v.length < 3 ? 'Enter CVV' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sp.base),
            PrimaryButton(label: 'Add Card', onPressed: _save),
          ],
        ),
      ),
    );
  }
}

class _PayFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;

  const _PayFormField({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
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
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            validator: validator,
            obscureText: obscureText,
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
              hintStyle: TextStyle(color: colors.textTertiary, fontSize: 15),
              errorStyle: const TextStyle(color: AppColors.error, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Input formatters ──────────────────────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    if (digits.length > 16) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '');
    if (digits.length > 4) return oldValue;
    String formatted = digits;
    if (digits.length >= 2) {
      formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
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
          Icon(
            Icons.credit_card_off_outlined,
            size: 56,
            color: colors.textTertiary,
          ),
          const SizedBox(height: Sp.base),
          Text(
            'No payment methods',
            style: AppTextStyles.cardTitle.copyWith(color: colors.textSecondary),
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
