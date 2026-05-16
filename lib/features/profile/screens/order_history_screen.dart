import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';

// ── Models ────────────────────────────────────────────────────────────────────

enum _Status { onTheWay, preparing, delivered, cancelled }

class _OrderItem {
  final String name;
  final String emoji;
  final int qty;
  final double price;
  const _OrderItem({
    required this.name,
    required this.emoji,
    required this.qty,
    required this.price,
  });
}

class _Order {
  final String id;
  final _Status status;
  final DateTime placedAt;
  final List<_OrderItem> items;
  final double deliveryFee;
  final int pointsEarned;

  const _Order({
    required this.id,
    required this.status,
    required this.placedAt,
    required this.items,
    this.deliveryFee = 2.99,
    required this.pointsEarned,
  });

  double get subtotal =>
      items.fold(0.0, (s, i) => s + i.price * i.qty);
  double get total => subtotal + deliveryFee;
}

// ── Filter ────────────────────────────────────────────────────────────────────

enum _Filter { all, active, delivered, cancelled }

// ── Screen ────────────────────────────────────────────────────────────────────

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  _Filter _filter = _Filter.all;
  late final List<_Order> _orders;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _orders = [
      _Order(
        id: '4825',
        status: _Status.onTheWay,
        placedAt: now.subtract(const Duration(minutes: 22)),
        items: const [
          _OrderItem(name: 'Double Smash Burger', emoji: '🍔', qty: 2, price: 21.99),
          _OrderItem(name: 'Truffle Fries', emoji: '🍟', qty: 1, price: 6.99),
          _OrderItem(name: 'Espresso Martini', emoji: '🍹', qty: 2, price: 12.99),
        ],
        pointsEarned: 0,
      ),
      _Order(
        id: '4824',
        status: _Status.preparing,
        placedAt: now.subtract(const Duration(minutes: 8)),
        items: const [
          _OrderItem(name: 'Prosciutto & Arugula', emoji: '🍕', qty: 1, price: 24.99),
          _OrderItem(name: 'Classic Caesar', emoji: '🥗', qty: 1, price: 14.99),
          _OrderItem(name: 'Crème Brûlée', emoji: '🍮', qty: 2, price: 9.99),
          _OrderItem(name: 'Fresh Lemonade', emoji: '🥤', qty: 2, price: 5.99),
        ],
        pointsEarned: 0,
        deliveryFee: 0,
      ),
      _Order(
        id: '4821',
        status: _Status.delivered,
        placedAt: now.subtract(const Duration(hours: 5, minutes: 30)),
        items: const [
          _OrderItem(name: 'Signature Beef Burger', emoji: '🍔', qty: 1, price: 18.99),
          _OrderItem(name: 'Mango Passion Smoothie', emoji: '🥭', qty: 2, price: 8.99),
        ],
        pointsEarned: 189,
      ),
      _Order(
        id: '4820',
        status: _Status.delivered,
        placedAt: now.subtract(const Duration(days: 1, hours: 1)),
        items: const [
          _OrderItem(name: 'BBQ Chicken Pizza', emoji: '🍕', qty: 1, price: 20.99),
          _OrderItem(name: 'Creamy Carbonara', emoji: '🍝', qty: 1, price: 16.99),
          _OrderItem(name: 'Lava Chocolate Cake', emoji: '🍫', qty: 1, price: 10.99),
          _OrderItem(name: 'Berry Blast Smoothie', emoji: '🥤', qty: 2, price: 8.99),
        ],
        pointsEarned: 370,
      ),
      _Order(
        id: '4815',
        status: _Status.delivered,
        placedAt: now.subtract(const Duration(days: 3)),
        items: const [
          _OrderItem(name: 'Truffle Tagliatelle', emoji: '🍝', qty: 2, price: 27.99),
          _OrderItem(name: 'Grilled Salmon Bowl', emoji: '🥗', qty: 1, price: 24.99),
          _OrderItem(name: 'Tiramisu', emoji: '🍰', qty: 2, price: 10.99),
        ],
        pointsEarned: 462,
        deliveryFee: 0,
      ),
      _Order(
        id: '4801',
        status: _Status.cancelled,
        placedAt: now.subtract(const Duration(days: 5, hours: 3)),
        items: const [
          _OrderItem(name: 'Wagyu Beef Burger', emoji: '🍔', qty: 1, price: 34.99),
          _OrderItem(name: 'Truffle Cheese Burger', emoji: '🍔', qty: 1, price: 22.99),
        ],
        pointsEarned: 0,
      ),
      _Order(
        id: '4756',
        status: _Status.delivered,
        placedAt: now.subtract(const Duration(days: 7, hours: 2)),
        items: const [
          _OrderItem(name: 'Truffle Margherita', emoji: '🍕', qty: 1, price: 22.50),
          _OrderItem(name: 'Seafood Linguine', emoji: '🍝', qty: 1, price: 24.99),
          _OrderItem(name: 'Matcha Latte', emoji: '🍵', qty: 2, price: 6.99),
          _OrderItem(name: 'New York Cheesecake', emoji: '🍰', qty: 1, price: 9.99),
        ],
        pointsEarned: 225,
      ),
      _Order(
        id: '4633',
        status: _Status.delivered,
        placedAt: now.subtract(const Duration(days: 12)),
        items: const [
          _OrderItem(name: 'Seafood Linguine', emoji: '🍝', qty: 2, price: 24.99),
          _OrderItem(name: 'Rose Lychee Spritz', emoji: '🍹', qty: 2, price: 9.99),
        ],
        pointsEarned: 300,
        deliveryFee: 0,
      ),
    ];
  }

  List<_Order> get _filtered {
    return switch (_filter) {
      _Filter.all => _orders,
      _Filter.active =>
        _orders
            .where((o) =>
                o.status == _Status.onTheWay ||
                o.status == _Status.preparing)
            .toList(),
      _Filter.delivered =>
        _orders.where((o) => o.status == _Status.delivered).toList(),
      _Filter.cancelled =>
        _orders.where((o) => o.status == _Status.cancelled).toList(),
    };
  }

  void _reorder(String id) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Items added to cart'),
        backgroundColor: AppColors.accentDeep,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rd.lg),
        ),
      ),
    );
  }

  void _trackOrder(String id) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tracking order #$id'),
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
    final colors = context.colors;
    final filtered = _filtered;

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
              'Order History',
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
            ),
            centerTitle: true,
          ),

          // Filter chips
          SliverPersistentHeader(
            pinned: true,
            delegate: _FilterHeaderDelegate(
              filter: _filter,
              onChanged: (f) {
                HapticFeedback.selectionClick();
                setState(() => _filter = f);
              },
              bgColor: colors.bgPrimary,
              dividerColor: colors.divider,
              counts: {
                _Filter.all: _orders.length,
                _Filter.active: _orders
                    .where((o) =>
                        o.status == _Status.onTheWay ||
                        o.status == _Status.preparing)
                    .length,
                _Filter.delivered: _orders
                    .where((o) => o.status == _Status.delivered)
                    .length,
                _Filter.cancelled: _orders
                    .where((o) => o.status == _Status.cancelled)
                    .length,
              },
            ),
          ),

          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(filter: _filter),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                Sp.base,
                Sp.md,
                Sp.base,
                MediaQuery.of(context).padding.bottom + Sp.xl,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: Sp.md),
                    child: _OrderCard(
                      order: filtered[i],
                      onReorder: () => _reorder(filtered[i].id),
                      onTrack: () => _trackOrder(filtered[i].id),
                    ),
                  ),
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Filter header ─────────────────────────────────────────────────────────────

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final _Filter filter;
  final ValueChanged<_Filter> onChanged;
  final Color bgColor;
  final Color dividerColor;
  final Map<_Filter, int> counts;

  const _FilterHeaderDelegate({
    required this.filter,
    required this.onChanged,
    required this.bgColor,
    required this.dividerColor,
    required this.counts,
  });

  static const _defs = [
    (_Filter.all, 'All', Icons.receipt_long_rounded),
    (_Filter.active, 'Active', Icons.delivery_dining_rounded),
    (_Filter.delivered, 'Delivered', Icons.check_circle_outline_rounded),
    (_Filter.cancelled, 'Cancelled', Icons.cancel_outlined),
  ];

  @override
  double get minExtent => 80;
  @override
  double get maxExtent => 80;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final colors = context.colors;
    return Container(
      color: bgColor,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sp.base,
                vertical: Sp.sm,
              ),
              child: Row(
                children: _defs.map((def) {
                  final isSelected = filter == def.$1;
                  final count = counts[def.$1] ?? 0;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(def.$1),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accentDeep
                              : colors.bgSecondary,
                          borderRadius: BorderRadius.circular(Rd.lg),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accentDeep
                                : dividerColor,
                            width: 1.2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.accentDeep
                                        .withValues(alpha: 0.28),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              def.$3,
                              size: 15,
                              color: isSelected
                                  ? Colors.white
                                  : colors.textTertiary,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '$count',
                              style: AppTextStyles.bodyLg.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : colors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              def.$2.toUpperCase(),
                              style: AppTextStyles.labelSm.copyWith(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.80)
                                    : colors.textTertiary,
                                fontSize: 8,
                                letterSpacing: 0.6,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Divider(height: 1, color: dividerColor),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_FilterHeaderDelegate old) =>
      old.filter != filter ||
      old.counts != counts ||
      old.bgColor != bgColor ||
      old.dividerColor != dividerColor;
}

// ── Order card ────────────────────────────────────────────────────────────────

class _OrderCard extends StatefulWidget {
  final _Order order;
  final VoidCallback onReorder;
  final VoidCallback onTrack;

  const _OrderCard({
    required this.order,
    required this.onReorder,
    required this.onTrack,
  });

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _expanded = false;

  static const _statusMeta = {
    _Status.onTheWay: (
      label: 'On The Way',
      color: Color(0xFFF59E0B),
      icon: Icons.delivery_dining_rounded,
    ),
    _Status.preparing: (
      label: 'Preparing',
      color: Color(0xFF3B82F6),
      icon: Icons.restaurant_rounded,
    ),
    _Status.delivered: (
      label: 'Delivered',
      color: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
    ),
    _Status.cancelled: (
      label: 'Cancelled',
      color: AppColors.error,
      icon: Icons.cancel_outlined,
    ),
  };

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) {
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour < 12 ? 'AM' : 'PM';
      return 'Today, $h:$m $ampm';
    }
    if (diff.inDays == 1) {
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour < 12 ? 'AM' : 'PM';
      return 'Yesterday, $h:$m $ampm';
    }
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  bool get _isActive =>
      widget.order.status == _Status.onTheWay ||
      widget.order.status == _Status.preparing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final order = widget.order;
    final meta = _statusMeta[order.status]!;
    final hasMore = order.items.length > 3;
    final extraCount = order.items.length - 3;
    final visibleItems = _expanded ? order.items : order.items.take(3).toList();

    return Container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xl),
        border: Border.all(color: colors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Rd.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            if (_isActive) _ActiveProgressBar(status: order.status),
            Padding(
              padding: const EdgeInsets.fromLTRB(Sp.base, Sp.md, Sp.base, Sp.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id}',
                          style: AppTextStyles.bodyLg.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _dateLabel(order.placedAt),
                          style: AppTextStyles.bodySm.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sp.md,
                      vertical: Sp.xs,
                    ),
                    decoration: BoxDecoration(
                      color: meta.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(Rd.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(meta.icon, size: 13, color: meta.color),
                        const SizedBox(width: 5),
                        Text(
                          meta.label,
                          style: AppTextStyles.labelSm.copyWith(
                            color: meta.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colors.divider),

            // ── Items ──
            Padding(
              padding: const EdgeInsets.fromLTRB(Sp.base, Sp.md, Sp.base, 0),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...visibleItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: Sp.sm),
                        child: Row(
                          children: [
                            Text(item.emoji,
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: Sp.sm),
                            Expanded(
                              child: Text(
                                item.name,
                                style: AppTextStyles.bodySm.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              '×${item.qty}',
                              style: AppTextStyles.bodySm.copyWith(
                                color: colors.textTertiary,
                              ),
                            ),
                            const SizedBox(width: Sp.sm),
                            Text(
                              '\$${(item.price * item.qty).toStringAsFixed(2)}',
                              style: AppTextStyles.bodySm.copyWith(
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (hasMore)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Sp.md),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _expanded = !_expanded);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sp.md,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentSoft,
                              borderRadius: BorderRadius.circular(Rd.pill),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.35),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedRotation(
                                  turns: _expanded ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 260),
                                  curve: Curves.easeInOut,
                                  child: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 15,
                                    color: AppColors.accentDeep,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _expanded
                                      ? 'Show less'
                                      : '+ $extraCount more item${extraCount > 1 ? 's' : ''}',
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: AppColors.accentDeep,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: Sp.md),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: colors.divider),

            // ── Footer ──
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Sp.base,
                vertical: Sp.md,
              ),
              color: AppColors.accentSoft,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.accentDeep.withValues(alpha: 0.70),
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: AppTextStyles.bodyLg.copyWith(
                          color: AppColors.accentDeep,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (order.pointsEarned > 0) ...[
                    const SizedBox(width: Sp.md),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sp.sm,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(Rd.pill),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.40),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: AppColors.accentDeep,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '+${order.pointsEarned} pts',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.accentDeep,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  _isActive
                      ? _ActionChip(
                          label: 'Track Order',
                          icon: Icons.location_on_rounded,
                          color: meta.color,
                          onTap: widget.onTrack,
                        )
                      : order.status == _Status.delivered
                          ? _ActionChip(
                              label: 'Reorder',
                              icon: Icons.replay_rounded,
                              color: AppColors.accentDeep,
                              onTap: widget.onReorder,
                            )
                          : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Active progress bar ───────────────────────────────────────────────────────

class _ActiveProgressBar extends StatelessWidget {
  final _Status status;
  const _ActiveProgressBar({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPreparing = status == _Status.preparing;
    final steps = ['Order Placed', 'Preparing', 'On The Way', 'Delivered'];
    final current = isPreparing ? 1 : 2;

    return Container(
      padding: const EdgeInsets.fromLTRB(Sp.base, Sp.md, Sp.base, Sp.sm),
      decoration: BoxDecoration(
        color: isPreparing
            ? const Color(0xFF3B82F6).withValues(alpha: 0.06)
            : AppColors.warning.withValues(alpha: 0.06),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(steps.length, (i) {
              final isDone = i <= current;
              final isCurrent = i == current;
              final isLast = i == steps.length - 1;
              final dotColor = isDone
                  ? (isPreparing
                      ? const Color(0xFF3B82F6)
                      : AppColors.warning)
                  : context.colors.divider;
              return Expanded(
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: isCurrent ? 10 : 8,
                      height: isCurrent ? 10 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dotColor,
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: dotColor.withValues(alpha: 0.50),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i < current ? dotColor : context.colors.divider,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: Sp.xs),
          Row(
            children: List.generate(steps.length, (i) {
              final isCurrent = i == current;
              return Expanded(
                child: Text(
                  steps[i],
                  textAlign: i == 0
                      ? TextAlign.left
                      : i == steps.length - 1
                          ? TextAlign.right
                          : TextAlign.center,
                  style: AppTextStyles.labelSm.copyWith(
                    fontSize: 9,
                    letterSpacing: 0.2,
                    fontWeight:
                        isCurrent ? FontWeight.w700 : FontWeight.w400,
                    color: isCurrent
                        ? (isPreparing
                            ? const Color(0xFF3B82F6)
                            : AppColors.warning)
                        : context.colors.textTertiary,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: Sp.xs),
        ],
      ),
    );
  }
}

// ── Action chip ───────────────────────────────────────────────────────────────

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sp.md,
          vertical: Sp.xs + 2,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(Rd.pill),
          border: Border.all(
            color: color.withValues(alpha: 0.30),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTextStyles.labelMd.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final _Filter filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (emoji, title, subtitle) = switch (filter) {
      _Filter.active => ('🛵', 'No Active Orders', 'You have no orders in progress right now.'),
      _Filter.delivered => ('📦', 'No Delivered Orders', "Your delivered orders will appear here."),
      _Filter.cancelled => ('❌', 'No Cancelled Orders', "You haven't cancelled any orders."),
      _ => ('🍽️', 'No Orders Yet', 'Your order history will appear here once you place your first order.'),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sp.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.bgSecondary,
                shape: BoxShape.circle,
                border: Border.all(color: colors.divider),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(height: Sp.xl),
            Text(
              title,
              style: AppTextStyles.cardTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: Sp.sm),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
