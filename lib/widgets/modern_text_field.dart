
import 'package:flutter/material.dart';
import 'package:dress_app/theme/tokens.dart';

class ModernTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const ModernTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.focusNode,
    this.textInputAction, required String label, required String? Function(dynamic value) validator,
  }) : super(key: key);

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AnimationTokens.normal,
      vsync: this,
    );
    _focusAnimation = CurvedAnimation(
      parent: _animationController,
      curve: AnimationTokens.easeInOut,
    );
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasError = widget.errorText != null;

    return AnimatedBuilder(
      animation: _focusAnimation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: (hasError ? ColorTokens.error : theme.primaryColor)
                              .withOpacity(0.15),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText,
                onChanged: widget.onChanged,
                onFieldSubmitted: widget.onSubmitted,
                onTap: widget.onTap,
                readOnly: widget.readOnly,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                enabled: widget.enabled,
                textInputAction: widget.textInputAction,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  errorText: widget.errorText,
                  prefixIcon: widget.prefixIcon != null
                      ? Padding(
                          padding: EdgeInsets.only(left: SpacingTokens.space4),
                          child: widget.prefixIcon,
                        )
                      : null,
                  suffixIcon: widget.suffixIcon,
                  filled: true,
                  fillColor: _isFocused
                      ? (isDark
                          ? ColorTokens.darkSurface
                          : ColorTokens.lightSurface)
                      : (isDark
                          ? ColorTokens.darkSurfaceSecondary
                          : ColorTokens.lightSurfaceSecondary),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: SpacingTokens.space16,
                    vertical: SpacingTokens.space16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
                    borderSide: BorderSide(
                      color: isDark
                          ? ColorTokens.darkBorderVariant
                          : ColorTokens.lightBorderVariant,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
                    borderSide: BorderSide(
                      color: hasError ? ColorTokens.error : theme.primaryColor,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
                    borderSide: BorderSide(
                      color: ColorTokens.error,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
                    borderSide: BorderSide(
                      color: ColorTokens.error,
                      width: 2,
                    ),
                  ),
                  labelStyle: theme.inputDecorationTheme.labelStyle?.copyWith(
                    color: _isFocused
                        ? (hasError ? ColorTokens.error : theme.primaryColor)
                        : (isDark
                            ? ColorTokens.darkTextSecondary
                            : ColorTokens.lightTextSecondary),
                  ),
                  hintStyle: theme.inputDecorationTheme.hintStyle,
                  errorStyle: theme.textTheme.bodySmall?.copyWith(
                    color: ColorTokens.error,
                  ),
                ),
              ),
            ),
            if (widget.helperText != null && widget.errorText == null)
              Padding(
                padding: EdgeInsets.only(
                  left: SpacingTokens.space16,
                  top: SpacingTokens.space4,
                ),
                child: Text(
                  widget.helperText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? ColorTokens.darkTextTertiary
                        : ColorTokens.lightTextTertiary,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
