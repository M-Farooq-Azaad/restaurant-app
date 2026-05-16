import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../mock/mock_data.dart';
import 'section_header.dart';

class RecentOrdersSection extends StatelessWidget {
  const RecentOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Recent Orders', onSeeAll: () {}),
        const SizedBox(height: Sp.md),
        SizedBox(
          height: 148,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Sp.base),
            itemCount: MockData.recentOrders.length,
            itemBuilder: (_, i) =>
                _RecentOrderCard(order: MockData.recentOrders[i]),
          ),
        ),
      ],
    );
  }
}

class _RecentOrderCard extends StatelessWidget {
  final MockRecentOrder order;

  const _RecentOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 210,
      margin: const EdgeInsets.only(right: Sp.md),
      padding: const EdgeInsets.all(Sp.md),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(order.emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: Sp.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ${order.orderNumber}',
                      style: AppTextStyles.itemTitle
                          .copyWith(color: colors.textPrimary),
                    ),
                    Text(
                      order.dateLabel,
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
          const SizedBox(height: Sp.xs),
          Text(
            order.itemNames.first,
            style:
                AppTextStyles.bodySm.copyWith(color: colors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: AppTextStyles.price
                        .copyWith(color: colors.textPrimary, fontSize: 15),
                  ),
                  Text(
                    '+${order.pointsEarned} pts earned',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.accent,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Sp.md, vertical: Sp.xs),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(Rd.pill),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.30),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    'Reorder',
                    style: AppTextStyles.labelSm.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
