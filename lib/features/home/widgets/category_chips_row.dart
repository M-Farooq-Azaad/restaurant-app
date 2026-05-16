import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';

class CategoryChipsRow extends StatefulWidget {
  const CategoryChipsRow({super.key});

  @override
  State<CategoryChipsRow> createState() => _CategoryChipsRowState();
}

class _CategoryChipsRowState extends State<CategoryChipsRow> {
  int _selected = 0;

  static const _chips = [
    ('All', '🍽️'),
    ('Burgers', '🍔'),
    ('Pizza', '🍕'),
    ('Pasta', '🍝'),
    ('Drinks', '🥤'),
    ('Desserts', '🍰'),
    ('Salads', '🥗'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Sp.base),
        itemCount: _chips.length,
        itemBuilder: (_, i) {
          final isSelected = _selected == i;
          final chip = _chips[i];
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selected = i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(right: Sp.sm),
              padding: const EdgeInsets.symmetric(
                  horizontal: Sp.md, vertical: Sp.xs),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.goldGradient : null,
                color: isSelected ? null : colors.bgSecondary,
                borderRadius: BorderRadius.circular(Rd.pill),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : colors.divider,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.30),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(chip.$2, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 5),
                  Text(
                    chip.$1,
                    style: AppTextStyles.labelMd.copyWith(
                      color:
                          isSelected ? Colors.white : colors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
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
