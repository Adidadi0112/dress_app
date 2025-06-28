
import 'package:flutter/material.dart';
import 'package:dress_app/theme/tokens.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final List<Color>? gradient;
  final Color? textColor;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double? elevation;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? width;
  final double? height;

  const GradientButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.textColor,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AnimationTokens.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AnimationTokens.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final defaultGradient = widget.gradient ?? 
        (isDark ? ColorTokens.primaryGradient : ColorTokens.primaryGradient);
    final defaultTextColor = widget.textColor ?? Colors.white;
    final defaultBorderRadius = widget.borderRadius ?? 
        BorderRadius.circular(RadiusTokens.radiusLg);
    final defaultPadding = widget.padding ?? 
        EdgeInsets.symmetric(
          horizontal: SpacingTokens.space24, 
          vertical: SpacingTokens.space16,
        );

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _handleTapDown : null,
      onTapUp: widget.onPressed != null ? _handleTapUp : null,
      onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.onPressed == null
                      ? [Colors.grey.shade400, Colors.grey.shade500]
                      : defaultGradient,
                ),
                borderRadius: defaultBorderRadius,
                boxShadow: _isPressed || widget.onPressed == null
                    ? []
                    : ElevationTokens.coloredShadow(
                        defaultGradient.first,
                        opacity: 0.3,
                      ),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: defaultBorderRadius,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  borderRadius: defaultBorderRadius,
                  child: Padding(
                    padding: defaultPadding,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.leadingIcon != null) ...[
                          widget.leadingIcon!,
                          SizedBox(width: SpacingTokens.space8),
                        ],
                        if (widget.isLoading)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                defaultTextColor,
                              ),
                            ),
                          )
                        else
                          Text(
                            widget.text,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: defaultTextColor,
                              fontWeight: TypographyTokens.semiBold,
                            ),
                          ),
                        if (widget.trailingIcon != null) ...[
                          SizedBox(width: SpacingTokens.space8),
                          widget.trailingIcon!,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
