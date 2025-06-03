import 'package:flutter/material.dart';
import 'package:dress_app/theme/tokens.dart';

/// A custom button widget that follows the design system
///
/// This button uses the theme's primary color and automatically adapts to light and dark themes.
class MyButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool isOutlined;
  final bool isSmall;
  final IconData? icon;
  final bool isLoading;

  const MyButton({
    super.key,
    required this.onTap,
    required this.title,
    this.isOutlined = false,
    this.isSmall = false,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? SpacingTokens.space12 : SpacingTokens.space16,
          horizontal: isSmall ? SpacingTokens.space16 : SpacingTokens.space24,
        ),
        margin: const EdgeInsets.symmetric(horizontal: SpacingTokens.space16),
        decoration: BoxDecoration(
          color: isOutlined
              ? Colors.transparent
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
          border: isOutlined
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                )
              : null,
          boxShadow: isOutlined ? null : ElevationTokens.subtle,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isOutlined
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onPrimary,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: isSmall ? 16 : 20,
                        color: isOutlined
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                      SizedBox(width: SpacingTokens.space8),
                    ],
                    Text(
                      title,
                      style: TextStyle(
                        color: isOutlined
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onPrimary,
                        fontWeight: TypographyTokens.medium,
                        fontSize: isSmall
                            ? TypographyTokens.fontSm
                            : TypographyTokens.fontMd,
                        letterSpacing: TypographyTokens.letterSpacingWide,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
