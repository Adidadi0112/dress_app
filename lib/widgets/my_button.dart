import 'package:flutter/material.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A custom button widget that follows the design system
///
/// This button uses the theme's primary color and includes a gentle spring animation
/// when pressed. It automatically adapts to light and dark themes.
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
        margin: EdgeInsets.symmetric(horizontal: SpacingTokens.space8),
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
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.03, 1.03),
          duration: 150.ms,
          curve: Curves.easeInOut,
        )
        .then(delay: 2000.ms); // Only animate on hover/press in a real app
  }
}
