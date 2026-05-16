import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';

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

  static const _earnMethods = [
    (
      '🛒',
      'Place an Order',
      'Earn 10 pts for every \$1 spent',
      '+10 pts / \$1',
    ),
    (
      '👥',
      'Refer a Friend',
      'Friend joins & places first order',
      '+500 pts',
    ),
    ('⭐', 'Leave a Review', 'Review any dish after your order', '+50 pts'),
    ('🎂', 'Birthday Bonus', 'Celebrate your special day with us', '+200 pts'),
    ('📸', 'Share on Social', 'Tag us in your food photo', '+100 pts'),
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
        Text(
          'How to Earn',
          style: AppTextStyles.cardTitle.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: Sp.md),
        ..._earnMethods.map(
          (m) => _EarnMethodCard(
            emoji: m.$1,
            title: m.$2,
            subtitle: m.$3,
            points: m.$4,
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
}

class _EarnMethodCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String points;

  const _EarnMethodCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: Sp.md),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(Rd.md),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sp.sm,
              vertical: Sp.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(Rd.sm),
            ),
            child: Text(
              points,
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.accentDeep,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
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
