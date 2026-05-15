import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../theme/app_theme_extension.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final bool showPasswordToggle;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? errorText;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.errorText,
    this.textInputAction,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;
  bool _focused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _focusNode = FocusNode()..addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.showPasswordToggle ? _obscure : widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      style: TextStyle(color: colors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: _focused ? colors.accent : colors.textTertiary,
          fontSize: _focused ? 12 : 15,
        ),
        filled: true,
        fillColor: colors.bgTertiary,
        prefixIcon: widget.prefixIcon != null
            ? IconTheme(
                data: IconThemeData(
                  color: _focused ? colors.accent : colors.textTertiary,
                  size: 20,
                ),
                child: widget.prefixIcon!,
              )
            : null,
        suffixIcon: widget.showPasswordToggle
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                  color: colors.textTertiary,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
        errorText: widget.errorText,
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Rd.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Rd.md),
          borderSide: widget.errorText != null
              ? const BorderSide(color: AppColors.error, width: 1.5)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Rd.md),
          borderSide: BorderSide(color: colors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Rd.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Rd.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Sp.base,
          vertical: Sp.base,
        ),
      ),
    );
  }
}
