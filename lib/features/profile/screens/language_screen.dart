import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme_extension.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedCode = 'en';

  static const _languages = [
    _Language(code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧'),
    _Language(code: 'ur', name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰'),
    _Language(code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦'),
    _Language(code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷'),
    _Language(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
    _Language(code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳'),
  ];

  void _select(String code) {
    if (code == _selectedCode) return;
    HapticFeedback.selectionClick();
    if (code != 'en') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Additional languages coming soon'),
          backgroundColor: AppColors.accentDeep,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Rd.lg),
          ),
        ),
      );
      return;
    }
    setState(() => _selectedCode = code);
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
              'Language',
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Sp.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Sp.sm),
                  Text(
                    'SELECT LANGUAGE',
                    style: AppTextStyles.labelSm.copyWith(
                      color: colors.textTertiary,
                      fontSize: 10,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: Sp.sm),
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
                      children: List.generate(_languages.length, (i) {
                        final lang = _languages[i];
                        final isSelected = lang.code == _selectedCode;
                        final isLast = i == _languages.length - 1;
                        return _LanguageTile(
                          language: lang,
                          isSelected: isSelected,
                          isLast: isLast,
                          onTap: () => _select(lang.code),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: Sp.xl),
                  Container(
                    padding: const EdgeInsets.all(Sp.base),
                    decoration: BoxDecoration(
                      color: AppColors.accentSoft,
                      borderRadius: BorderRadius.circular(Rd.xl),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.30),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: AppColors.accentDeep,
                        ),
                        const SizedBox(width: Sp.sm),
                        Expanded(
                          child: Text(
                            'More languages will be available in a future update.',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.accentDeep,
                            ),
                          ),
                        ),
                      ],
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

// ── Models ────────────────────────────────────────────────────────────────────

class _Language {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const _Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

// ── Language tile ─────────────────────────────────────────────────────────────

class _LanguageTile extends StatelessWidget {
  final _Language language;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(
            top: Radius.zero,
            bottom: isLast ? const Radius.circular(Rd.xl) : Radius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sp.base,
              vertical: Sp.md,
            ),
            child: Row(
              children: [
                Text(language.flag, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: Sp.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.name,
                        style: AppTextStyles.bodyLg.copyWith(
                          color: isSelected
                              ? AppColors.accentDeep
                              : colors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      Text(
                        language.nativeName,
                        style: AppTextStyles.bodySm.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.accent : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accent
                          : colors.textTertiary.withValues(alpha: 0.40),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 13,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: Sp.base + 24 + Sp.md),
            child: Divider(height: 1, color: colors.divider),
          ),
      ],
    );
  }
}
