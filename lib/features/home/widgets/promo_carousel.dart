import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../mock/mock_data.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final _controller = PageController(viewportFraction: 0.88);
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % MockData.promos.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const promos = MockData.promos;
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            itemCount: promos.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sp.xs),
              child: _PromoCard(promo: promos[i]),
            ),
          ),
        ),
        const SizedBox(height: Sp.md),
        SmoothPageIndicator(
          controller: _controller,
          count: promos.length,
          effect: const WormEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppColors.accent,
            dotColor: AppColors.accentSoft,
          ),
        ),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  final PromoItem promo;

  const _PromoCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [promo.bgStart, promo.bgEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Rd.xl),
        boxShadow: [
          BoxShadow(
            color: promo.bgEnd.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Rd.xl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Unique decorative SVG pattern per card
            CustomPaint(
              painter: _PromoPainter(promo.pattern),
            ),
            // Emoji
            Positioned(
              right: Sp.xl,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  promo.emoji,
                  style: const TextStyle(fontSize: 64),
                ),
              ),
            ),
            // Text content
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sp.xl,
                vertical: Sp.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sp.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(Rd.sm),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      promo.tag,
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: Sp.sm),
                  Text(
                    promo.title,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    promo.subtitle,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
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

// ── Painters ──────────────────────────────────────────────────────────────────

class _PromoPainter extends CustomPainter {
  final PromoPattern pattern;

  const _PromoPainter(this.pattern);

  @override
  void paint(Canvas canvas, Size size) {
    switch (pattern) {
      case PromoPattern.burst:
        _paintBurst(canvas, size);
      case PromoPattern.bubbles:
        _paintBubbles(canvas, size);
      case PromoPattern.diamonds:
        _paintDiamonds(canvas, size);
      case PromoPattern.waves:
        _paintWaves(canvas, size);
    }
  }

  // Sunburst radiating lines from bottom-right corner
  void _paintBurst(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final cx = size.width + 10;
    final cy = size.height + 10;
    const lineCount = 20;
    const radius = 320.0;

    for (int i = 0; i < lineCount; i++) {
      final angle = math.pi + (i / lineCount) * (math.pi / 1.6);
      final dx = cx + radius * math.cos(angle);
      final dy = cy + radius * math.sin(angle);
      canvas.drawLine(Offset(cx, cy), Offset(dx, dy), paint);
    }

    // Concentric arcs
    final arcPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (final r in [60.0, 110.0, 170.0, 240.0]) {
      canvas.drawCircle(Offset(cx, cy), r, arcPaint);
    }
  }

  // Scattered bubbles — playful, asymmetric
  void _paintBubbles(Canvas canvas, Size size) {
    final specs = [
      (Offset(size.width * 0.72, size.height * 0.18), 48.0, 0.06),
      (Offset(size.width * 0.88, size.height * 0.55), 32.0, 0.05),
      (Offset(size.width * 0.60, size.height * 0.75), 22.0, 0.07),
      (Offset(size.width * 0.95, size.height * 0.10), 16.0, 0.04),
      (Offset(size.width * 0.50, size.height * 0.92), 40.0, 0.04),
      (Offset(size.width * 0.78, size.height * 0.88), 18.0, 0.06),
    ];

    for (final (center, radius, alpha) in specs) {
      // Filled bubble
      canvas.drawCircle(
        center,
        radius,
        Paint()..color = Colors.white.withValues(alpha: alpha),
      );
      // Ring
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = Colors.white.withValues(alpha: alpha + 0.03)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );
    }
  }

  // Diamond grid — geometric, premium
  void _paintDiamonds(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const spacing = 28.0;
    const half = spacing / 2;
    final cols = (size.width / spacing).ceil() + 2;
    final rows = (size.height / spacing).ceil() + 2;

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final cx = col * spacing + (row.isOdd ? half : 0);
        final cy = row * spacing * 0.6;
        final path = Path()
          ..moveTo(cx, cy - half * 0.75)
          ..lineTo(cx + half * 0.75, cy)
          ..lineTo(cx, cy + half * 0.75)
          ..lineTo(cx - half * 0.75, cy)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  // Flowing wave curves — elegant, organic
  void _paintWaves(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const waveCount = 6;
    final waveHeight = size.height / (waveCount + 1);

    for (int i = 0; i < waveCount; i++) {
      final y = waveHeight * (i + 1);
      final amplitude = 14.0 + i * 3;
      final path = Path();
      path.moveTo(-20, y);

      double x = -20;
      while (x < size.width + 40) {
        final cp1x = x + 20;
        final cp1y = y - amplitude;
        final cp2x = x + 40;
        final cp2y = y + amplitude;
        final endX = x + 60;
        path.cubicTo(cp1x, cp1y, cp2x, cp2y, endX, y);
        x += 60;
      }

      canvas.drawPath(path, paint);
    }

    // Extra thick accent wave
    final accentPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.0
      ..strokeCap = StrokeCap.round;

    final accentPath = Path();
    accentPath.moveTo(-20, size.height * 0.55);
    accentPath.cubicTo(
      size.width * 0.3, size.height * 0.25,
      size.width * 0.6, size.height * 0.85,
      size.width + 20, size.height * 0.45,
    );
    canvas.drawPath(accentPath, accentPaint);
  }

  @override
  bool shouldRepaint(_PromoPainter old) => old.pattern != pattern;
}
