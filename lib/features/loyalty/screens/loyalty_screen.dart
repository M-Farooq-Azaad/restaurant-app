import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';
import 'send_points_screen.dart';

class LoyaltyScreen extends StatefulWidget {
  const LoyaltyScreen({super.key});

  @override
  State<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: Column(
        children: [
          _LoyaltyHeader(
            selectedTab: _tab,
            onTabChanged: (i) {
              HapticFeedback.selectionClick();
              setState(() => _tab = i);
            },
          ),
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: const [_EarnTab(), _RedeemTab(), _HistoryTab()],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ──────────────────────────────────────────────────────────────────

class _LoyaltyHeader extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const _LoyaltyHeader({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    const user = MockData.currentUser;
    const nextThreshold = 4000;
    final progress = (user.totalPoints / nextThreshold).clamp(0.0, 1.0);
    final remaining = nextThreshold - user.totalPoints;
    final tierName = MockData.tierNames[user.tierId] ?? 'Bronze';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1C1400), Color(0xFF3D2E00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned(top: -40, right: -30, child: _GoldCircle(size: 160)),
          const Positioned(bottom: 48, right: 80, child: _GoldCircle(size: 100)),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Sp.base, Sp.md, Sp.base, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rewards',
                        style: AppTextStyles.cardTitle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      _TierBadge(tierName: tierName),
                    ],
                  ),
                  const SizedBox(height: Sp.xl),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${user.totalPoints}',
                        style: AppTextStyles.priceLg.copyWith(
                          fontSize: 52,
                          color: AppColors.accent,
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(width: Sp.sm),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'points',
                          style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.accentSoft,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Sp.md),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Rd.pill),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accent,
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: Sp.xs),
                  Text(
                    remaining > 0
                        ? '$remaining pts to Platinum tier'
                        : 'Platinum tier reached! 🏆',
                    style: AppTextStyles.bodySm.copyWith(color: Colors.white54),
                  ),
                  const SizedBox(height: Sp.xl),
                  _TabRow(selected: selectedTab, onChanged: onTabChanged),
                  const SizedBox(height: Sp.base),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabRow extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _TabRow({required this.selected, required this.onChanged});

  static const _tabs = ['Earn', 'Redeem', 'History'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_tabs.length, (i) {
        final isSelected = selected == i;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(right: i < _tabs.length - 1 ? Sp.sm : 0),
              padding: const EdgeInsets.symmetric(vertical: Sp.sm),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.goldGradient : null,
                color: isSelected
                    ? null
                    : Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Rd.lg),
              ),
              child: Center(
                child: Text(
                  _tabs[i],
                  style: AppTextStyles.labelMd.copyWith(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Earn Tab ────────────────────────────────────────────────────────────────

class _EarnTab extends StatelessWidget {
  const _EarnTab();

  static const _recentTransfers = [
    _MockTransfer(
      name: 'Sarah Kim',
      initials: 'SK',
      avatarColor: Color(0xFFEC4899),
      points: 200,
      isSent: true,
      timeLabel: 'Today, 2:30 PM',
    ),
    _MockTransfer(
      name: 'Alex Chen',
      initials: 'AC',
      avatarColor: Color(0xFF3B82F6),
      points: 150,
      isSent: false,
      timeLabel: 'Yesterday',
    ),
    _MockTransfer(
      name: 'Marco Rossi',
      initials: 'MR',
      avatarColor: Color(0xFF8B5CF6),
      points: 500,
      isSent: true,
      timeLabel: '2 days ago',
    ),
  ];

  static const _earnMethods = [
    (
      '🛒',
      'Place an Order',
      'Earn 10 pts for every \$1 spent',
      '+10 pts / \$1',
      Color(0xFFD97706),
    ),
    (
      '👥',
      'Refer a Friend',
      'Friend joins & places first order',
      '+500 pts',
      Color(0xFF8B5CF6),
    ),
    (
      '⭐',
      'Leave a Review',
      'Review any dish after your order',
      '+50 pts',
      Color(0xFF3B82F6),
    ),
    (
      '🎂',
      'Birthday Bonus',
      'Celebrate your special day with us',
      '+200 pts',
      Color(0xFFEC4899),
    ),
    (
      '📸',
      'Share on Social',
      'Tag us in your food photo',
      '+100 pts',
      Color(0xFFF97316),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: Sp.base,
        vertical: Sp.xl,
      ),
      children: [
        _SendReceiveActions(
          onSend: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SendPointsScreen()),
          ),
          onReceive: () => _showReceiveSheet(context),
        ),
        const SizedBox(height: Sp.xl),
        const _RecentTransfersSection(transfers: _recentTransfers),
        const SizedBox(height: Sp.xl),
        Text(
          'How to Earn',
          style: AppTextStyles.cardTitle.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: Sp.md),
        ..._earnMethods.indexed.map(
          (e) => _EarnMethodCard(
            emoji: e.$2.$1,
            title: e.$2.$2,
            subtitle: e.$2.$3,
            points: e.$2.$4,
            iconColor: e.$2.$5,
            index: e.$1,
          ),
        ),
        const SizedBox(height: Sp.xl),
        Text(
          'Tier Benefits',
          style: AppTextStyles.cardTitle.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: Sp.md),
        const _TierBenefitsTable(),
      ],
    );
  }

  void _showReceiveSheet(BuildContext context) {
    const user = MockData.currentUser;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ReceiveSheet(userId: user.id, username: user.username),
    );
  }
}

class _EarnMethodCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String points;
  final Color iconColor;
  final int index;

  const _EarnMethodCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.iconColor,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: Sp.md),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Rd.xl),
        child: InkWell(
          borderRadius: BorderRadius.circular(Rd.xl),
          splashColor: iconColor.withValues(alpha: 0.06),
          onTap: () => HapticFeedback.selectionClick(),
          child: Padding(
            padding: const EdgeInsets.all(Sp.base),
            child: Row(
              children: [
                // Color-coded icon box
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        iconColor.withValues(alpha: 0.18),
                        iconColor.withValues(alpha: 0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(Rd.lg),
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: Sp.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.itemTitle.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodyMd.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Sp.sm),
                // Points badge with matching color
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sp.sm,
                    vertical: Sp.xs,
                  ),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(Rd.sm),
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    points,
                    style: AppTextStyles.labelSm.copyWith(
                      color: iconColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (index * 60).ms)
        .slideX(
          begin: 0.05,
          end: 0,
          duration: 300.ms,
          delay: (index * 60).ms,
          curve: Curves.easeOut,
        );
  }
}

class _TierBenefitsTable extends StatelessWidget {
  const _TierBenefitsTable();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const user = MockData.currentUser;

    final tiers = [
      (
        '🥉',
        'Bronze',
        '0 pts',
        <String>['Base earn rate', 'Birthday bonus'],
        'tier_bronze',
      ),
      (
        '🥈',
        'Silver',
        '1,000 pts',
        <String>[
          'Base earn rate',
          'Birthday bonus',
          'Free delivery once/month',
        ],
        'tier_silver',
      ),
      (
        '🥇',
        'Gold',
        '2,000 pts',
        <String>[
          '1.5× earn rate',
          'Birthday bonus',
          'Free delivery twice/month',
          'Priority seating',
        ],
        'tier_gold',
      ),
      (
        '💎',
        'Platinum',
        '4,000 pts',
        <String>[
          '2× earn rate',
          'Birthday bonus',
          'Unlimited free delivery',
          'Private dining access',
          "Chef's table invite",
        ],
        'tier_platinum',
      ),
    ];

    final tierOrder = [
      'tier_bronze',
      'tier_silver',
      'tier_gold',
      'tier_platinum',
    ];
    final currentTierIndex = tierOrder.indexOf(user.tierId);

    return Column(
      children: tiers.asMap().entries.map((entry) {
        final i = entry.key;
        final tier = entry.value;
        final isCurrent = tier.$5 == user.tierId;
        final isUnlocked = i <= currentTierIndex;

        return Container(
          margin: const EdgeInsets.only(bottom: Sp.md),
          padding: const EdgeInsets.all(Sp.base),
          decoration: BoxDecoration(
            color: isCurrent ? const Color(0xFF1C1400) : colors.bgSecondary,
            borderRadius: BorderRadius.circular(Rd.xl),
            border: Border.all(
              color: isCurrent ? AppColors.accent : colors.divider,
              width: isCurrent ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tier.$1, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: Sp.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          tier.$2,
                          style: AppTextStyles.itemTitle.copyWith(
                            color: isCurrent
                                ? AppColors.accent
                                : colors.textPrimary,
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: Sp.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              borderRadius: BorderRadius.circular(Rd.pill),
                            ),
                            child: Text(
                              'CURRENT',
                              style: AppTextStyles.labelSm.copyWith(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          tier.$3,
                          style: AppTextStyles.labelSm.copyWith(
                            color: isCurrent
                                ? AppColors.accentSoft
                                : colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sp.sm),
                    ...tier.$4.map(
                      (benefit) => Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Row(
                          children: [
                            Icon(
                              isUnlocked
                                  ? Icons.check_circle_rounded
                                  : Icons.lock_outline_rounded,
                              size: 13,
                              color: isUnlocked
                                  ? (isCurrent
                                      ? AppColors.accent
                                      : AppColors.success)
                                  : colors.textTertiary,
                            ),
                            const SizedBox(width: Sp.xs),
                            Expanded(
                              child: Text(
                                benefit,
                                style: AppTextStyles.bodyMd.copyWith(
                                  color: isCurrent
                                      ? Colors.white70
                                      : (isUnlocked
                                          ? colors.textSecondary
                                          : colors.textTertiary),
                                ),
                              ),
                            ),
                          ],
                        ),
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

// ── Redeem Tab ──────────────────────────────────────────────────────────────

class _RedeemTab extends StatelessWidget {
  const _RedeemTab();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const user = MockData.currentUser;
    const rewards = MockData.loyaltyRewards;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Sp.base, Sp.xl, Sp.base, Sp.md),
          child: Row(
            children: [
              Text(
                'Available Rewards',
                style: AppTextStyles.cardTitle.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sp.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(Rd.pill),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      size: 13,
                      color: AppColors.accentDeep,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${user.totalPoints} pts',
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.accentDeep,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(
              Sp.base,
              0,
              Sp.base,
              Sp.xxxl,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Sp.md,
              mainAxisSpacing: Sp.md,
              childAspectRatio: 0.78,
            ),
            itemCount: rewards.length,
            itemBuilder: (_, i) => _RewardCard(
              reward: rewards[i],
              userPoints: user.totalPoints,
            ),
          ),
        ),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  final LoyaltyReward reward;
  final int userPoints;

  const _RewardCard({required this.reward, required this.userPoints});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final canRedeem = userPoints >= reward.pointsCost;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xl),
        border: Border.all(
          color: canRedeem ? AppColors.accentSoft : colors.divider,
          width: canRedeem ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 88,
            decoration: BoxDecoration(
              color: canRedeem ? AppColors.accentSoft : colors.bgTertiary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Rd.xl),
              ),
            ),
            child: Center(
              child: Text(
                reward.emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Sp.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: AppTextStyles.itemTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  reward.subtitle,
                  style: AppTextStyles.bodySm.copyWith(
                    color: colors.textTertiary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Sp.sm),
                GestureDetector(
                  onTap: canRedeem
                      ? () {
                          HapticFeedback.mediumImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${reward.title} redeemed!'),
                              backgroundColor: AppColors.accentDeep,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Rd.lg),
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: canRedeem ? AppColors.goldGradient : null,
                      color: canRedeem ? null : colors.bgTertiary,
                      borderRadius: BorderRadius.circular(Rd.pill),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          canRedeem
                              ? Icons.stars_rounded
                              : Icons.lock_outline_rounded,
                          size: 12,
                          color: canRedeem ? Colors.white : colors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${reward.pointsCost} pts',
                          style: AppTextStyles.labelSm.copyWith(
                            color:
                                canRedeem ? Colors.white : colors.textTertiary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
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

// ── History Tab ─────────────────────────────────────────────────────────────

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const history = MockData.loyaltyHistory;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: Sp.base, vertical: Sp.xl),
      itemCount: history.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Sp.md),
            child: Text(
              'Point History',
              style: AppTextStyles.cardTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
          );
        }
        return _TransactionTile(transaction: history[i - 1]);
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final LoyaltyTransaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEarned = transaction.isEarned;
    final pointsColor = isEarned ? AppColors.success : AppColors.error;
    final pointsText =
        isEarned ? '+${transaction.points}' : '${transaction.points}';

    return Container(
      margin: const EdgeInsets.only(bottom: Sp.md),
      padding: const EdgeInsets.all(Sp.base),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(Rd.xl),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isEarned
                  ? AppColors.success.withValues(alpha: 0.10)
                  : AppColors.error.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(Rd.md),
            ),
            child: Center(
              child: Icon(
                isEarned
                    ? Icons.add_circle_outline_rounded
                    : Icons.remove_circle_outline_rounded,
                color: pointsColor,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: Sp.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: AppTextStyles.itemTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.subtitle,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: colors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  transaction.dateLabel,
                  style: AppTextStyles.labelSm.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            pointsText,
            style: AppTextStyles.price.copyWith(color: pointsColor),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ──────────────────────────────────────────────────────────

class _GoldCircle extends StatelessWidget {
  final double size;

  const _GoldCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent.withValues(alpha: 0.06),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.14),
          width: 1,
        ),
      ),
    );
  }
}

class _TierBadge extends StatelessWidget {
  final String tierName;

  const _TierBadge({required this.tierName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sp.md,
        vertical: Sp.xs,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(Rd.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars_rounded, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            tierName.toUpperCase(),
            style: AppTextStyles.labelSm.copyWith(
              color: Colors.white,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Transfer data model ───────────────────────────────────────────────────────

class _MockTransfer {
  final String name;
  final String initials;
  final Color avatarColor;
  final int points;
  final bool isSent;
  final String timeLabel;

  const _MockTransfer({
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.points,
    required this.isSent,
    required this.timeLabel,
  });
}

// ── Send / Receive action buttons ─────────────────────────────────────────────

class _SendReceiveActions extends StatelessWidget {
  final VoidCallback onSend;
  final VoidCallback onReceive;

  const _SendReceiveActions({
    required this.onSend,
    required this.onReceive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionBtn(
            icon: Icons.send_rounded,
            label: 'Send Points',
            sublabel: 'To friends',
            gradient: AppColors.goldGradient,
            shadowColor: AppColors.accent,
            onTap: onSend,
          ).animate().fadeIn(duration: 350.ms).slideX(
                begin: -0.08,
                end: 0,
                duration: 350.ms,
                curve: Curves.easeOut,
              ),
        ),
        const SizedBox(width: Sp.md),
        Expanded(
          child: _ActionBtn(
            icon: Icons.call_received_rounded,
            label: 'Receive',
            sublabel: 'Share your ID',
            gradient: const LinearGradient(
              colors: [Color(0xFF059669), Color(0xFF047857)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shadowColor: const Color(0xFF059669),
            onTap: onReceive,
          ).animate().fadeIn(duration: 350.ms, delay: 80.ms).slideX(
                begin: 0.08,
                end: 0,
                duration: 350.ms,
                curve: Curves.easeOut,
                delay: 80.ms,
              ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Gradient gradient;
  final Color shadowColor;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.gradient,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Sp.xl,
          horizontal: Sp.md,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(Rd.xxl),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: Sp.md),
            Text(
              label,
              style: AppTextStyles.labelMd.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: AppTextStyles.labelSm.copyWith(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Recent Transfers section ──────────────────────────────────────────────────

class _RecentTransfersSection extends StatelessWidget {
  final List<_MockTransfer> transfers;

  const _RecentTransfersSection({required this.transfers});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transfers',
              style: AppTextStyles.cardTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => HapticFeedback.selectionClick(),
              child: Text(
                'See All',
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.accentDeep,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Sp.md),
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
            children: transfers.asMap().entries.map((e) {
              return _TransferTile(
                transfer: e.value,
                isLast: e.key == transfers.length - 1,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _TransferTile extends StatelessWidget {
  final _MockTransfer transfer;
  final bool isLast;

  const _TransferTile({required this.transfer, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSent = transfer.isSent;
    final pointsColor = isSent ? AppColors.error : AppColors.success;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sp.base,
            vertical: Sp.md,
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: transfer.avatarColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: transfer.avatarColor.withValues(alpha: 0.30),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        transfer.initials,
                        style: AppTextStyles.labelMd.copyWith(
                          color: transfer.avatarColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: pointsColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.bgSecondary,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        isSent
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        size: 10,
                        color: pointsColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Sp.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSent ? 'Sent to ${transfer.name}' : 'Received from ${transfer.name}',
                      style: AppTextStyles.itemTitle.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      transfer.timeLabel,
                      style: AppTextStyles.bodySm.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                isSent ? '−${transfer.points} pts' : '+${transfer.points} pts',
                style: AppTextStyles.labelMd.copyWith(
                  color: pointsColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: Sp.base + 46 + Sp.md),
            child: Divider(height: 1, color: colors.divider),
          ),
      ],
    );
  }
}

// ── Receive bottom sheet ──────────────────────────────────────────────────────

class _ReceiveSheet extends StatefulWidget {
  final String userId;
  final String username;

  const _ReceiveSheet({required this.userId, required this.username});

  @override
  State<_ReceiveSheet> createState() => _ReceiveSheetState();
}

class _ReceiveSheetState extends State<_ReceiveSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(Rd.xxl)),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF120D00), Color(0xFF1C1400), Color(0xFF2E2000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Decorative background circles
            const Positioned(top: -60, right: -40, child: _GoldCircle(size: 200)),
            const Positioned(top: 40, left: -60, child: _GoldCircle(size: 140)),
            const Positioned(bottom: 60, right: -30, child: _GoldCircle(size: 120)),
            // Content
            Padding(
              padding: EdgeInsets.fromLTRB(Sp.xl, Sp.base, Sp.xl, bottomPad + Sp.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(Rd.pill),
                    ),
                  ),
                  const SizedBox(height: Sp.xl),
                  // Icon badge
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.35),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.call_received_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.6, 0.6),
                        end: const Offset(1, 1),
                        duration: 400.ms,
                        curve: Curves.easeOutBack,
                      )
                      .fade(duration: 300.ms),
                  const SizedBox(height: Sp.md),
                  Text(
                    'Receive Points',
                    style: AppTextStyles.cardTitle.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: Sp.xs),
                  Text(
                    'Ask a friend to scan your QR to send you points.',
                    style: AppTextStyles.bodySm.copyWith(
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Sp.xl),
                  // QR card — white on dark, maximum contrast
                  AnimatedBuilder(
                    animation: _glowCtrl,
                    builder: (_, child) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Rd.xxl),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(
                                alpha: 0.22 + 0.16 * _glowCtrl.value),
                            blurRadius: 48,
                            spreadRadius: 4,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.30),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: child,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Sp.xl),
                      child: Column(
                        children: [
                          // QR with logo overlay
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Corner bracket decoration
                              SizedBox(
                                width: 196,
                                height: 196,
                                child: CustomPaint(
                                  painter: _QrFramePainter(),
                                ),
                              ),
                              // White QR code
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(Rd.md),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                    width: 1,
                                  ),
                                ),
                                child: CustomPaint(
                                  size: const Size(160, 160),
                                  painter: _QrPainter(),
                                ),
                              ),
                              // Center logo
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldGradient,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accent
                                          .withValues(alpha: 0.40),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.restaurant_rounded,
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Sp.lg),
                          // Divider
                          Container(
                            height: 1,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color(0xFFE5E7EB),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: Sp.md),
                          // Username row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.success
                                          .withValues(alpha: 0.5),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              )
                                  .animate(onPlay: (c) => c.repeat(reverse: true))
                                  .fade(begin: 0.3, end: 1.0, duration: 1200.ms),
                              const SizedBox(width: Sp.sm),
                              Text(
                                '@${widget.username}',
                                style: AppTextStyles.bodyMd.copyWith(
                                  color: const Color(0xFF1C1400),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.userId.toUpperCase(),
                            style: AppTextStyles.labelSm.copyWith(
                              color: const Color(0xFF9CA3AF),
                              letterSpacing: 2.0,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Sp.xl),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Username copied!'),
                                backgroundColor: AppColors.accentDeep,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Rd.lg),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(vertical: Sp.md),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(Rd.xl),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.copy_rounded,
                                    size: 16,
                                    color:
                                        Colors.white.withValues(alpha: 0.85)),
                                const SizedBox(width: Sp.xs),
                                Text(
                                  'Copy ID',
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: Sp.md),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(vertical: Sp.md),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              borderRadius: BorderRadius.circular(Rd.xl),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.accent.withValues(alpha: 0.35),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.share_rounded,
                                    size: 16, color: Colors.white),
                                const SizedBox(width: Sp.xs),
                                Text(
                                  'Share',
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _QrPainter extends CustomPainter {
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
            (cx + 1) * cell, (cy + 1) * cell, 5 * cell, 5 * cell),
        paint,
      );
      paint.color = Colors.black;
      canvas.drawRect(
        Rect.fromLTWH(
            (cx + 2) * cell, (cy + 2) * cell, 3 * cell, 3 * cell),
        paint,
      );
    }

    finder(0, 0);
    finder(14, 0);
    finder(0, 14);

    for (int i = 8; i <= 12; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(
            Rect.fromLTWH(i * cell, 6 * cell, cell, cell), paint);
        canvas.drawRect(
            Rect.fromLTWH(6 * cell, i * cell, cell, cell), paint);
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
          Rect.fromLTWH(m[0] * cell, m[1] * cell, cell, cell), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QrFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const len = 22.0;
    const thick = 3.0;
    const radius = 6.0;
    final paint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = thick
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void bracket(Offset corner, double dx, double dy) {
      final path = Path();
      // horizontal arm
      path.moveTo(corner.dx + dx * (len - radius), corner.dy);
      path.lineTo(corner.dx + dx * radius, corner.dy);
      path.arcToPoint(
        Offset(corner.dx, corner.dy + dy * radius),
        radius: const Radius.circular(radius),
        clockwise: dx * dy < 0,
      );
      // vertical arm
      path.lineTo(corner.dx, corner.dy + dy * (len - radius));
      canvas.drawPath(path, paint);
    }

    bracket(Offset.zero, 1, 1);
    bracket(Offset(size.width, 0), -1, 1);
    bracket(Offset(0, size.height), 1, -1);
    bracket(Offset(size.width, size.height), -1, -1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
