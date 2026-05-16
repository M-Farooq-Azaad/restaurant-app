import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

enum _NotifType { order, promo, loyalty, system }

class _Notif {
  final String id;
  final _NotifType type;
  final String title;
  final String body;
  final DateTime time;
  bool isRead;

  _Notif({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });
}

class _NotifMeta {
  final IconData icon;
  final Color color;
  const _NotifMeta({required this.icon, required this.color});
}

// ── Screen ────────────────────────────────────────────────────────────────────

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final List<_Notif> _notifs;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _notifs = [
      _Notif(
        id: '1',
        type: _NotifType.order,
        title: 'Order On Its Way! 🚀',
        body: 'Your order #4821 has been picked up and is heading to you.',
        time: now.subtract(const Duration(minutes: 12)),
      ),
      _Notif(
        id: '2',
        type: _NotifType.promo,
        title: 'Weekend Special — 20% Off',
        body: 'Use code WEEKEND20 on any order this Saturday & Sunday.',
        time: now.subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      _Notif(
        id: '3',
        type: _NotifType.loyalty,
        title: 'You earned 150 points!',
        body: 'Great choice! Points added from your last order. Keep it up.',
        time: now.subtract(const Duration(hours: 5)),
      ),
      _Notif(
        id: '4',
        type: _NotifType.order,
        title: 'Order Delivered ✅',
        body: 'Order #4820 delivered successfully. Enjoy your meal!',
        time: now.subtract(const Duration(days: 1, hours: 1)),
        isRead: true,
      ),
      _Notif(
        id: '5',
        type: _NotifType.system,
        title: 'New payment method added',
        body: 'A Visa card ending in 4242 was added to your account.',
        time: now.subtract(const Duration(days: 1, hours: 3)),
        isRead: true,
      ),
      _Notif(
        id: '6',
        type: _NotifType.promo,
        title: 'Buy 2 Get 1 Free 🎉',
        body: 'Order any 2 mains today and get a dessert on us — limited time!',
        time: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
      _Notif(
        id: '7',
        type: _NotifType.loyalty,
        title: 'Gold tier unlocked! 🏆',
        body: "You've crossed 1,000 points. Welcome to Gold membership!",
        time: now.subtract(const Duration(days: 3)),
        isRead: true,
      ),
      _Notif(
        id: '8',
        type: _NotifType.order,
        title: 'Order Confirmed',
        body: 'Order #4819 is confirmed. Estimated prep time: 20 mins.',
        time: now.subtract(const Duration(days: 5)),
        isRead: true,
      ),
      _Notif(
        id: '9',
        type: _NotifType.system,
        title: 'Profile updated',
        body: 'Your profile information was updated successfully.',
        time: now.subtract(const Duration(days: 6)),
        isRead: true,
      ),
      _Notif(
        id: '10',
        type: _NotifType.promo,
        title: 'Ramadan Special Menu 🌙',
        body: 'Explore our exclusive Ramadan deals available all month long.',
        time: now.subtract(const Duration(days: 9)),
        isRead: true,
      ),
    ];
  }

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  void _markAllRead() {
    HapticFeedback.selectionClick();
    setState(() {
      for (final n in _notifs) {
        n.isRead = true;
      }
    });
  }

  void _dismiss(String id) {
    HapticFeedback.mediumImpact();
    setState(() => _notifs.removeWhere((n) => n.id == id));
  }

  void _markRead(String id) {
    setState(() => _notifs.firstWhere((n) => n.id == id).isRead = true);
  }

  Map<String, List<_Notif>> get _grouped {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));

    final buckets = <String, List<_Notif>>{
      'Today': [],
      'Yesterday': [],
      'This Week': [],
      'Earlier': [],
    };

    for (final n in _notifs) {
      final d = DateTime(n.time.year, n.time.month, n.time.day);
      if (!d.isBefore(today)) {
        buckets['Today']!.add(n);
      } else if (d == yesterday) {
        buckets['Yesterday']!.add(n);
      } else if (d.isAfter(weekAgo)) {
        buckets['This Week']!.add(n);
      } else {
        buckets['Earlier']!.add(n);
      }
    }

    buckets.removeWhere((_, v) => v.isEmpty);
    return buckets;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final grouped = _grouped;

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
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Notifications',
                  style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
                ),
                if (_unreadCount > 0) ...[
                  const SizedBox(width: Sp.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(Rd.pill),
                    ),
                    child: Text(
                      '$_unreadCount',
                      style: AppTextStyles.labelSm.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            centerTitle: true,
            actions: [
              if (_unreadCount > 0)
                TextButton(
                  onPressed: _markAllRead,
                  child: Text(
                    'Read all',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.accent,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),

          if (_notifs.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                Sp.base,
                Sp.sm,
                Sp.base,
                MediaQuery.of(context).padding.bottom + Sp.xl,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final key = grouped.keys.elementAt(i);
                    return _NotifGroup(
                      label: key,
                      notifs: grouped[key]!,
                      onDismiss: _dismiss,
                      onTap: _markRead,
                    );
                  },
                  childCount: grouped.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Group card ────────────────────────────────────────────────────────────────

class _NotifGroup extends StatelessWidget {
  final String label;
  final List<_Notif> notifs;
  final ValueChanged<String> onDismiss;
  final ValueChanged<String> onTap;

  const _NotifGroup({
    required this.label,
    required this.notifs,
    required this.onDismiss,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: Sp.md, bottom: Sp.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: Sp.xs, bottom: Sp.sm),
            child: Text(
              label.toUpperCase(),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Rd.xl),
              child: Column(
                children: List.generate(notifs.length * 2 - 1, (i) {
                  if (i.isOdd) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 3 + Sp.base + 38 + Sp.md,
                      ),
                      child: Divider(height: 1, color: colors.divider),
                    );
                  }
                  final notifIndex = i ~/ 2;
                  final notif = notifs[notifIndex];
                  final isFirst = notifIndex == 0;
                  final isLast = notifIndex == notifs.length - 1;
                  return Dismissible(
                    key: ValueKey(notif.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => onDismiss(notif.id),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: Sp.lg),
                      color: AppColors.error.withValues(alpha: 0.10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Remove',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.error,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: _NotifTile(
                      notif: notif,
                      isFirst: isFirst,
                      isLast: isLast,
                      onTap: () => onTap(notif.id),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Notification tile ─────────────────────────────────────────────────────────

class _NotifTile extends StatelessWidget {
  final _Notif notif;
  final VoidCallback onTap;

  final bool isFirst;
  final bool isLast;

  const _NotifTile({
    required this.notif,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  static _NotifMeta _meta(_NotifType type) => switch (type) {
    _NotifType.order => const _NotifMeta(
        icon: Icons.receipt_long_rounded,
        color: AppColors.success,
      ),
    _NotifType.promo => const _NotifMeta(
        icon: Icons.local_offer_rounded,
        color: AppColors.warning,
      ),
    _NotifType.loyalty => const _NotifMeta(
        icon: Icons.workspace_premium_rounded,
        color: AppColors.accent,
      ),
    _NotifType.system => const _NotifMeta(
        icon: Icons.info_outline_rounded,
        color: Color(0xFF6366F1),
      ),
  };

  String _timeLabel(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final meta = _meta(notif.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(Rd.xl) : Radius.zero,
          bottom: isLast ? const Radius.circular(Rd.xl) : Radius.zero,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // Animated left accent bar — unread indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: 3,
              color: notif.isRead ? Colors.transparent : meta.color,
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sp.base,
                  vertical: Sp.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Circular icon
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: meta.color.withValues(alpha: 0.12),
                      ),
                      child: Icon(meta.icon, size: 18, color: meta.color),
                    ),
                    const SizedBox(width: Sp.md),
                    // Text block
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  notif.title,
                                  style: AppTextStyles.bodyMd.copyWith(
                                    color: colors.textPrimary,
                                    fontWeight: notif.isRead
                                        ? FontWeight.w400
                                        : FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: Sp.sm),
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  _timeLabel(notif.time),
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: colors.textTertiary,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notif.body,
                            style: AppTextStyles.bodySm.copyWith(
                              color: colors.textSecondary,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Unread dot
                    if (!notif.isRead) ...[
                      const SizedBox(width: Sp.sm),
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: meta.color,
                          boxShadow: [
                            BoxShadow(
                              color: meta.color.withValues(alpha: 0.40),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
              child: Icon(
                Icons.notifications_off_outlined,
                size: 34,
                color: colors.textTertiary,
              ),
            ),
            const SizedBox(height: Sp.xl),
            Text(
              'All Caught Up',
              style: AppTextStyles.cardTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: Sp.sm),
            Text(
              'No notifications right now.\nCheck back later for updates.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
