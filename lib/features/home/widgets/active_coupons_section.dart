import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../mock/mock_data.dart';
import 'section_header.dart';

class ActiveCouponsSection extends StatelessWidget {
  const ActiveCouponsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Active Coupons', onSeeAll: () {}),
        const SizedBox(height: Sp.md),
        SizedBox(
          height: 116,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Sp.base),
            itemCount: MockData.coupons.length,
            itemBuilder: (_, i) => _CouponCard(coupon: MockData.coupons[i]),
          ),
        ),
      ],
    );
  }
}

class _CouponCard extends StatelessWidget {
  final MockCoupon coupon;

  const _CouponCard({required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: Sp.md),
      decoration: BoxDecoration(
        color: coupon.bgColor,
        borderRadius: BorderRadius.circular(Rd.xl),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.22),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Decorative circle
          Positioned(
            right: -24,
            bottom: -24,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: -30,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Sp.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Sp.sm, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(Rd.sm),
                        border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.30)),
                      ),
                      child: Text(
                        coupon.code,
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.accent,
                          fontSize: 9,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.local_offer_rounded,
                        size: 14, color: AppColors.accent),
                  ],
                ),
                const Spacer(),
                Text(
                  coupon.title,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  coupon.subtitle,
                  style: AppTextStyles.bodySm.copyWith(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Sp.xs),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 11, color: AppColors.warning),
                    const SizedBox(width: 3),
                    Text(
                      coupon.expiryLabel,
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.warning,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
