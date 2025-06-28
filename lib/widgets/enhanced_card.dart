
import 'package:flutter/material.dart';
import 'package:dress_app/theme/tokens.dart';

class EnhancedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<Color>? gradient;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final bool isPressed;

  const EnhancedCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.gradient,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
    this.isPressed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final defaultBackgroundColor = backgroundColor ?? theme.cardColor;
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(RadiusTokens.radiusXl);
    final defaultElevation = elevation ?? (isDark ? 4.0 : 2.0);

    Widget cardContent = Container(
      padding: padding ?? EdgeInsets.all(SpacingTokens.space16),
      decoration: BoxDecoration(
        gradient: gradient != null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient!,
              )
            : null,
        color: gradient == null ? defaultBackgroundColor : null,
        borderRadius: defaultBorderRadius,
        border: border ?? Border.all(
          color: isDark 
              ? ColorTokens.darkBorderVariant 
              : ColorTokens.lightBorderVariant,
          width: 1,
        ),
        boxShadow: isPressed
            ? ElevationTokens.neumorphic(defaultBackgroundColor, isPressed: true)
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                  blurRadius: defaultElevation * 2,
                  offset: Offset(0, defaultElevation),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Container(
        margin: margin ?? EdgeInsets.all(SpacingTokens.space8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: defaultBorderRadius,
            child: cardContent,
          ),
        ),
      );
    }

    return Container(
      margin: margin ?? EdgeInsets.all(SpacingTokens.space8),
      child: cardContent,
    );
  }
}
