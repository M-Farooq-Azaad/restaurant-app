import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> with TickerProviderStateMixin {
  int _tab = 0;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _scanLineCtrl;
  late final AnimationController _successCtrl;
  _ScanState _scanState = _ScanState.idle;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _scanLineCtrl.dispose();
    _successCtrl.dispose();
    super.dispose();
  }

  Future<void> _simulateScan() async {
    HapticFeedback.mediumImpact();
    setState(() => _scanState = _ScanState.scanning);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    HapticFeedback.heavyImpact();
    setState(() => _scanState = _ScanState.success);
    _successCtrl.forward(from: 0);
  }

  void _confirmScan() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop();
  }

  void _cancelScan() {
    HapticFeedback.selectionClick();
    setState(() {
      _scanState = _ScanState.idle;
      _successCtrl.reset();
    });
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
              'QR Code',
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Sp.base),
              child: Column(
                children: [
                  const SizedBox(height: Sp.md),
                  _TabSwitcher(
                    selected: _tab,
                    onChanged: (i) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _tab = i;
                        if (i == 1) {
                          _scanState = _ScanState.idle;
                          _successCtrl.reset();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: Sp.xl),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.04),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: _tab == 0
                        ? _MyQrTab(
                            key: const ValueKey('myqr'),
                            shimmerCtrl: _shimmerCtrl,
                          )
                        : _ScanTab(
                            key: const ValueKey('scan'),
                            scanLineCtrl: _scanLineCtrl,
                            successCtrl: _successCtrl,
                            scanState: _scanState,
                            onSimulateScan: _simulateScan,
                            onConfirm: _confirmScan,
                            onCancel: _cancelScan,
                          ),
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

enum _ScanState { idle, scanning, success }

// ── Tab Switcher ──────────────────────────────────────────────────────────────

class _TabSwitcher extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _TabSwitcher({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xxl),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        children: [
          _TabBtn(
            label: 'My QR Code',
            icon: Icons.qr_code_2_rounded,
            isSelected: selected == 0,
            onTap: () => onChanged(0),
          ),
          _TabBtn(
            label: 'Scan QR',
            icon: Icons.qr_code_scanner_rounded,
            isSelected: selected == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabBtn({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.goldGradient : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(Rd.xl),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : colors.textTertiary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.bodySm.copyWith(
                  color: isSelected ? Colors.white : colors.textTertiary,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── My QR Tab ─────────────────────────────────────────────────────────────────

class _MyQrTab extends StatelessWidget {
  final AnimationController shimmerCtrl;

  const _MyQrTab({super.key, required this.shimmerCtrl});

  @override
  Widget build(BuildContext context) {
    const user = MockData.currentUser;
    return Column(
      children: [
        // Animated shimmer border card
        AnimatedBuilder(
          animation: shimmerCtrl,
          builder: (_, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1C1400),
                    Color(0xFF2D2000),
                    Color(0xFF1A1200),
                  ],
                ),
                borderRadius: BorderRadius.circular(Rd.xxl),
                border: Border.all(
                  color: AppColors.accent.withValues(
                    alpha: 0.20 + 0.15 * shimmerCtrl.value,
                  ),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(
                      alpha: 0.10 + 0.08 * shimmerCtrl.value,
                    ),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(Sp.xl),
            child: Column(
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: AppTextStyles.cardTitle.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sp.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.20),
                                borderRadius: BorderRadius.circular(Rd.sm),
                                border: Border.all(
                                  color:
                                      AppColors.accent.withValues(alpha: 0.40),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.stars_rounded,
                                    size: 10,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Gold Member',
                                    style: AppTextStyles.labelSm.copyWith(
                                      color: AppColors.accent,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Restaurant logo mark
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Icon(
                        Icons.restaurant_rounded,
                        color: AppColors.accent,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Sp.xl),
                // QR code with decorative frame
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer decorative ring
                    Container(
                      width: 232,
                      height: 232,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Rd.xl),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          width: 4,
                        ),
                      ),
                    ),
                    // QR white card
                    Container(
                      padding: const EdgeInsets.all(Sp.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Rd.lg),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CustomPaint(
                        size: const Size(200, 200),
                        painter: _FakeQrPainter(),
                      ),
                    ),
                    // Center logo watermark on QR
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.30),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.restaurant_rounded,
                        size: 18,
                        color: AppColors.accentDeep,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Sp.lg),
                // ID with scannable hint
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .fade(
                          begin: 0.3,
                          end: 1.0,
                          duration: 1200.ms,
                        ),
                    const SizedBox(width: Sp.xs),
                    Text(
                      'ID: ${user.id.toUpperCase()}',
                      style: AppTextStyles.bodySm.copyWith(
                        color: Colors.white38,
                        letterSpacing: 1.8,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Sp.lg),
                Divider(color: Colors.white.withValues(alpha: 0.10)),
                const SizedBox(height: Sp.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _QrStat(label: 'Points', value: '${user.totalPoints}'),
                    _QrStatDivider(),
                    const _QrStat(label: 'Tier', value: 'Gold'),
                    _QrStatDivider(),
                    const _QrStat(label: 'Since', value: '2026'),
                  ],
                ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.04, end: 0, duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: Sp.lg),
        // Hint text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 13,
              color: context.colors.textTertiary,
            ),
            const SizedBox(width: Sp.xs),
            Flexible(
              child: Text(
                'Show this code at the counter to earn or redeem points.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySm.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Sp.xl),
        // Action buttons row
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => HapticFeedback.selectionClick(),
                icon: const Icon(Icons.share_rounded, size: 17),
                label: const Text('Share QR'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentDeep,
                  side: BorderSide(
                    color: AppColors.accent.withValues(alpha: 0.50),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: Sp.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Rd.xl),
                  ),
                ),
              ),
            ),
            const SizedBox(width: Sp.md),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => HapticFeedback.selectionClick(),
                icon: const Icon(Icons.download_rounded, size: 17),
                label: const Text('Save Image'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.colors.textSecondary,
                  side: BorderSide(
                    color: context.colors.divider,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: Sp.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Rd.xl),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QrStat extends StatelessWidget {
  final String label;
  final String value;

  const _QrStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.labelSm.copyWith(
            color: Colors.white38,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _QrStatDivider extends StatelessWidget {
  const _QrStatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: Colors.white.withValues(alpha: 0.10),
    );
  }
}

// ── Scan Tab ──────────────────────────────────────────────────────────────────

class _ScanTab extends StatelessWidget {
  final AnimationController scanLineCtrl;
  final AnimationController successCtrl;
  final _ScanState scanState;
  final VoidCallback onSimulateScan;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _ScanTab({
    super.key,
    required this.scanLineCtrl,
    required this.successCtrl,
    required this.scanState,
    required this.onSimulateScan,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 380),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      child: scanState == _ScanState.success
          ? _ScanSuccess(
              key: const ValueKey('success'),
              successCtrl: successCtrl,
              onConfirm: onConfirm,
              onCancel: onCancel,
            )
          : _ScanViewfinder(
              key: const ValueKey('viewfinder'),
              scanLineCtrl: scanLineCtrl,
              isScanning: scanState == _ScanState.scanning,
              onScan: onSimulateScan,
            ),
    );
  }
}

// ── Viewfinder ────────────────────────────────────────────────────────────────

class _ScanViewfinder extends StatelessWidget {
  final AnimationController scanLineCtrl;
  final bool isScanning;
  final VoidCallback onScan;

  const _ScanViewfinder({
    super.key,
    required this.scanLineCtrl,
    required this.isScanning,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const viewfinderSize = 280.0;
    const scanPadding = 28.0;

    return Column(
      children: [
        // Status label
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isScanning
              ? Row(
                  key: const ValueKey('scanning'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
                        strokeWidth: 1.5,
                      ),
                    ),
                    const SizedBox(width: Sp.xs),
                    Text(
                      'Scanning...',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                )
              : Text(
                  'Point camera at a QR code',
                  key: const ValueKey('idle'),
                  style: AppTextStyles.bodySm.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
        ),
        const SizedBox(height: Sp.xl),
        // Camera viewfinder
        Container(
          width: viewfinderSize,
          height: viewfinderSize,
          decoration: BoxDecoration(
            color: const Color(0xFF080600),
            borderRadius: BorderRadius.circular(Rd.xl),
            border: Border.all(
              color: isScanning
                  ? AppColors.accent.withValues(alpha: 0.35)
                  : AppColors.accent.withValues(alpha: 0.12),
              width: 1.5,
            ),
            boxShadow: isScanning
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Rd.xl - 1),
            child: Stack(
              children: [
                // Subtle grid overlay
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.04,
                    child: CustomPaint(painter: _GridPainter()),
                  ),
                ),
                // Corner brackets
                CustomPaint(
                  size: const Size(viewfinderSize, viewfinderSize),
                  painter: _CornerBracketsPainter(
                    isActive: isScanning,
                  ),
                ),
                // Faint ghost QR when idle
                if (!isScanning)
                  Center(
                    child: Opacity(
                      opacity: 0.07,
                      child: CustomPaint(
                        size: const Size(160, 160),
                        painter: _FakeQrPainter(),
                      ),
                    ),
                  ),
                // Scan line
                if (isScanning)
                  AnimatedBuilder(
                    animation: scanLineCtrl,
                    builder: (_, __) {
                      final t = scanLineCtrl.value;
                      return Positioned(
                        top: scanPadding +
                            (viewfinderSize - scanPadding * 2) * t,
                        left: scanPadding,
                        right: scanPadding,
                        child: Column(
                          children: [
                            Container(
                              height: 2.5,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    AppColors.accent.withValues(alpha: 0.70),
                                    AppColors.accent,
                                    AppColors.accent.withValues(alpha: 0.70),
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent.withValues(
                                      alpha: 0.60,
                                    ),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.accent.withValues(alpha: 0.08),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                // Amber tint while scanning
                if (isScanning)
                  Container(
                    color: AppColors.accent.withValues(alpha: 0.025),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Sp.xl),
        // Scan button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: isScanning ? null : onScan,
            icon: Icon(
              isScanning
                  ? Icons.radar_rounded
                  : Icons.qr_code_scanner_rounded,
              size: 20,
            ),
            label: Text(isScanning ? 'Scanning...' : 'Simulate Successful Scan'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              disabledBackgroundColor:
                  AppColors.accent.withValues(alpha: 0.45),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white60,
              padding: const EdgeInsets.symmetric(vertical: Sp.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Rd.xl),
              ),
            ),
          ),
        ),
        const SizedBox(height: Sp.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 12,
              color: colors.textTertiary,
            ),
            const SizedBox(width: 4),
            Text(
              'Camera integration coming in a future update.',
              style: AppTextStyles.labelSm.copyWith(
                color: colors.textTertiary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Scan Success ──────────────────────────────────────────────────────────────

class _ScanSuccess extends StatelessWidget {
  final AnimationController successCtrl;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _ScanSuccess({
    super.key,
    required this.successCtrl,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const green = Color(0xFF16A34A);

    return Column(
      children: [
        ScaleTransition(
          scale: CurvedAnimation(
            parent: successCtrl,
            curve: Curves.easeOutBack,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Sp.xl),
            decoration: BoxDecoration(
              color: colors.bgSecondary,
              borderRadius: BorderRadius.circular(Rd.xxl),
              border: Border.all(color: green.withValues(alpha: 0.35)),
              boxShadow: [
                BoxShadow(
                  color: green.withValues(alpha: 0.12),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Glow rings + check
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: green.withValues(alpha: 0.05),
                      ),
                    ),
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: green.withValues(alpha: 0.08),
                      ),
                    ),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: green.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: green.withValues(alpha: 0.30),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: green.withValues(alpha: 0.22),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: green,
                        size: 36,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Sp.md),
                Text(
                  'QR Scanned!',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sp.sm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(Rd.pill),
                    border:
                        Border.all(color: green.withValues(alpha: 0.25)),
                  ),
                  child: Text(
                    'Ready to confirm',
                    style: AppTextStyles.bodySm.copyWith(
                      color: green,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: Sp.lg),
                Divider(color: colors.divider),
                const SizedBox(height: Sp.md),
                _ResultRow(
                  icon: Icons.stars_rounded,
                  label: 'Earn 50 Loyalty Points',
                  color: AppColors.accent,
                ),
                const SizedBox(height: Sp.sm),
                _ResultRow(
                  icon: Icons.person_outline_rounded,
                  label:
                      'Log visit for ${MockData.currentUser.fullName}',
                  color: colors.textSecondary,
                ),
                const SizedBox(height: Sp.sm),
                _ResultRow(
                  icon: Icons.schedule_rounded,
                  label: 'Today, ${TimeOfDay.now().format(context)}',
                  color: colors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Sp.xl),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sp.base,
            vertical: Sp.md,
          ),
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: BorderRadius.circular(Rd.xl),
            border: Border.all(color: colors.divider),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.help_outline_rounded,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: Sp.sm),
              Expanded(
                child: Text(
                  'Are you sure you want to award 50 pts and log this visit?',
                  style: AppTextStyles.bodySm.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Sp.md),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.textSecondary,
                  side: BorderSide(color: colors.divider),
                  padding: const EdgeInsets.symmetric(vertical: Sp.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Rd.xl),
                  ),
                ),
                child: const Text('No, Cancel'),
              ),
            ),
            const SizedBox(width: Sp.md),
            Expanded(
              child: FilledButton(
                onPressed: onConfirm,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: Sp.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Rd.xl),
                  ),
                ),
                child: const Text('Yes, Confirm'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ResultRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: Sp.sm),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySm.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

// ── Painters ──────────────────────────────────────────────────────────────────

class _CornerBracketsPainter extends CustomPainter {
  final bool isActive;

  const _CornerBracketsPainter({this.isActive = false});

  @override
  void paint(Canvas canvas, Size size) {
    const margin = 24.0;
    const len = 32.0;
    const strokeW = 3.0;

    final paint = Paint()
      ..color = isActive
          ? AppColors.accent
          : AppColors.accent.withValues(alpha: 0.60)
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    void bracket(double ox, double oy, double sx, double sy) {
      canvas.drawLine(Offset(ox, oy), Offset(ox + sx * len, oy), paint);
      canvas.drawLine(Offset(ox, oy), Offset(ox, oy + sy * len), paint);
    }

    bracket(margin, margin, 1, 1);
    bracket(size.width - margin, margin, -1, 1);
    bracket(margin, size.height - margin, 1, -1);
    bracket(size.width - margin, size.height - margin, -1, -1);
  }

  @override
  bool shouldRepaint(covariant _CornerBracketsPainter old) =>
      old.isActive != isActive;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 0.5;
    const gap = 30.0;
    for (double x = gap; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = gap; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _FakeQrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final cell = size.width / 21;

    paint.color = Colors.white;
    canvas.drawRect(Offset.zero & size, paint);
    paint.color = Colors.black;

    void finder(int cx, int cy) {
      canvas.drawRect(
        Rect.fromLTWH(cx * cell, cy * cell, 7 * cell, 7 * cell),
        paint,
      );
      paint.color = Colors.white;
      canvas.drawRect(
        Rect.fromLTWH(
          (cx + 1) * cell,
          (cy + 1) * cell,
          5 * cell,
          5 * cell,
        ),
        paint,
      );
      paint.color = Colors.black;
      canvas.drawRect(
        Rect.fromLTWH(
          (cx + 2) * cell,
          (cy + 2) * cell,
          3 * cell,
          3 * cell,
        ),
        paint,
      );
    }

    finder(0, 0);
    finder(14, 0);
    finder(0, 14);

    for (int i = 8; i <= 12; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(
          Rect.fromLTWH(i * cell, 6 * cell, cell, cell),
          paint,
        );
        canvas.drawRect(
          Rect.fromLTWH(6 * cell, i * cell, cell, cell),
          paint,
        );
      }
    }

    const modules = [
      [8, 1], [9, 1], [11, 1], [13, 1],
      [8, 2], [10, 2], [12, 2],
      [8, 3], [9, 3], [11, 3], [13, 3],
      [9, 5], [10, 5], [12, 5], [13, 5],
      [8, 6], [11, 6],
      [1, 8], [3, 8], [5, 8], [6, 8],
      [2, 9], [4, 9],
      [1, 10], [3, 10], [5, 10],
      [2, 11], [4, 11], [6, 11],
      [1, 12], [3, 12], [5, 12],
      [8, 8], [10, 8], [11, 8], [13, 8],
      [9, 9], [12, 9],
      [8, 10], [10, 10], [13, 10],
      [9, 11], [11, 11],
      [8, 12], [10, 12], [12, 12],
      [15, 8], [17, 8], [19, 8],
      [16, 9], [18, 9], [20, 9],
      [15, 10], [17, 10], [20, 10],
      [16, 11], [19, 11],
      [7, 15], [9, 15], [11, 15],
      [8, 16], [10, 16],
      [7, 17], [9, 17], [11, 17],
      [8, 18], [10, 18],
      [15, 15], [17, 15], [19, 15],
      [16, 16], [18, 16], [20, 16],
      [15, 17], [17, 17], [20, 17],
      [16, 18], [19, 18],
      [15, 19], [17, 19], [19, 19],
      [7, 19], [9, 19], [11, 19],
      [8, 20], [10, 20],
    ];

    for (final m in modules) {
      canvas.drawRect(
        Rect.fromLTWH(m[0] * cell, m[1] * cell, cell, cell),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
