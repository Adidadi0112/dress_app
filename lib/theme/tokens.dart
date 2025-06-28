
import 'package:flutter/material.dart';

/// Design tokens for the Wardrobe Journal app
/// This file contains all the design tokens used throughout the app
/// including colors, spacing, typography, radii, and elevations.

/// Color Tokens
class ColorTokens {
  // Enhanced Base Pastel Colors with better saturation
  static const Color rosePetal = Color(0xFFF5E6ED);
  static const Color lavenderMist = Color(0xFFE8E4FF);
  static const Color mintFoam = Color(0xFFE6F7F1);
  static const Color peachBloom = Color(0xFFFFF2E6);
  static const Color skyBlush = Color(0xFFE6F4FF);
  static const Color midInk = Color(0xFF2D2D35);

  // Enhanced Light Theme Colors
  static const Color lightBackground = Color(0xFFFDFDFD);
  static const Color lightSurface = Color(0xFFF9F9FB);
  static const Color lightSurfaceSecondary = Color(0xFFF5F5F7);
  static const Color lightPrimary = Color(0xFFE91E63);
  static const Color lightPrimaryVariant = Color(0xFFF48FB1);
  static const Color lightSecondary = Color(0xFF7C4DFF);
  static const Color lightSecondaryVariant = Color(0xFFB39DDB);
  static const Color lightAccent = Color(0xFF00BCD4);
  static const Color lightAccentVariant = Color(0xFF80DEEA);
  static const Color lightText = Color(0xFF1A1A20);
  static const Color lightTextSecondary = Color(0xFF6B6B7D);
  static const Color lightTextTertiary = Color(0xFF9E9EAF);
  static const Color lightBorder = Color(0xFFE8E8EE);
  static const Color lightBorderVariant = Color(0xFFF2F2F4);

  // Enhanced Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F0F14);
  static const Color darkSurface = Color(0xFF1A1A22);
  static const Color darkSurfaceSecondary = Color(0xFF252530);
  static const Color darkPrimary = Color(0xFFFF6B9D);
  static const Color darkPrimaryVariant = Color(0xFFAD5389);
  static const Color darkSecondary = Color(0xFF9C88FF);
  static const Color darkSecondaryVariant = Color(0xFF7986CB);
  static const Color darkAccent = Color(0xFF4DD0E1);
  static const Color darkAccentVariant = Color(0xFF26A69A);
  static const Color darkText = Color(0xFFF8F9FA);
  static const Color darkTextSecondary = Color(0xFFB8BCC8);
  static const Color darkTextTertiary = Color(0xFF8E9196);
  static const Color darkBorder = Color(0xFF33333F);
  static const Color darkBorderVariant = Color(0xFF2A2A36);

  // Enhanced Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFC8E6C9);
  static const Color successDark = Color(0xFF2E7D32);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFFCDD2);
  static const Color errorDark = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFE0B2);
  static const Color warningDark = Color(0xFFF57C00);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFBBDEFB);
  static const Color infoDark = Color(0xFF1976D2);

  // Brand gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF7C4DFF),
    Color(0xFF3F51B5),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF00BCD4),
    Color(0xFF009688),
  ];

  // Utility function to ensure WCAG AA contrast
  static Color ensureContrast(Color background, Color foreground) {
    // Calculate luminance
    double bgLuminance = background.computeLuminance();
    double fgLuminance = foreground.computeLuminance();

    // Calculate contrast ratio
    double contrastRatio = (bgLuminance > fgLuminance)
        ? (bgLuminance + 0.05) / (fgLuminance + 0.05)
        : (fgLuminance + 0.05) / (bgLuminance + 0.05);

    // WCAG AA requires 4.5:1 for normal text
    if (contrastRatio < 4.5) {
      // Adjust foreground color to meet contrast requirements
      if (bgLuminance > 0.5) {
        // Dark text on light background
        return _darkenColor(foreground, (4.5 - contrastRatio) / 10);
      } else {
        // Light text on dark background
        return _lightenColor(foreground, (4.5 - contrastRatio) / 10);
      }
    }

    return foreground;
  }

  // Helper to darken a color
  static Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  // Helper to lighten a color
  static Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  // Create gradient
  static LinearGradient createGradient(List<Color> colors, {
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
    );
  }
}

/// Enhanced Spacing Tokens (4-pt grid)
class SpacingTokens {
  static const double space1 = 1.0;
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space10 = 10.0;
  static const double space12 = 12.0;
  static const double space14 = 14.0;
  static const double space16 = 16.0;
  static const double space18 = 18.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space28 = 28.0;
  static const double space32 = 32.0;
  static const double space36 = 36.0;
  static const double space40 = 40.0;
  static const double space44 = 44.0;
  static const double space48 = 48.0;
  static const double space52 = 52.0;
  static const double space56 = 56.0;
  static const double space60 = 60.0;
  static const double space64 = 64.0;
  static const double space72 = 72.0;
  static const double space80 = 80.0;
  static const double space96 = 96.0;
  static const double space112 = 112.0;
  static const double space128 = 128.0;
  static const double space144 = 144.0;
  static const double space160 = 160.0;
}

/// Enhanced Border Radius Tokens
class RadiusTokens {
  static const double radiusNone = 0.0;
  static const double radiusXs = 2.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 10.0;
  static const double radiusLg = 14.0;
  static const double radiusXl = 18.0;
  static const double radius2xl = 24.0;
  static const double radius3xl = 32.0;
  static const double radiusCircular = 999.0;
}

/// Enhanced Elevation Tokens
class ElevationTokens {
  static List<BoxShadow> none = [];

  static List<BoxShadow> subtle = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> low = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 10,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 15,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> high = [
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 20,
      offset: const Offset(0, 10),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> elevated = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 25,
      offset: const Offset(0, 15),
      spreadRadius: 0,
    ),
  ];

  // Colored shadows for buttons and interactive elements
  static List<BoxShadow> coloredShadow(Color color, {double opacity = 0.3}) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: 12,
        offset: const Offset(0, 6),
        spreadRadius: 0,
      ),
    ];
  }

  // Neumorphic elevation for cards
  static List<BoxShadow> neumorphic(Color baseColor, {bool isPressed = false}) {
    final Color lightenedColor = Color.lerp(baseColor, Colors.white, 0.7)!;
    final Color darkenedColor = Color.lerp(baseColor, Colors.black, 0.15)!;

    if (isPressed) {
      return [
        BoxShadow(
          color: darkenedColor,
          offset: const Offset(-2, -2),
          blurRadius: 4,
        ),
        BoxShadow(
          color: lightenedColor,
          offset: const Offset(2, 2),
          blurRadius: 4,
        ),
      ];
    }

    return [
      BoxShadow(
        color: lightenedColor,
        offset: const Offset(-4, -4),
        blurRadius: 8,
      ),
      BoxShadow(
        color: darkenedColor,
        offset: const Offset(4, 4),
        blurRadius: 8,
      ),
    ];
  }
}

/// Enhanced Typography Scale Tokens
class TypographyTokens {
  // Font Families
  static const String primaryFontFamily = 'Inter';
  static const String displayFontFamily = 'Playfair Display';

  // Font Weights
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // Font Sizes
  static const double fontXs = 12.0;
  static const double fontSm = 14.0;
  static const double fontBase = 16.0;
  static const double fontMd = 16.0;
  static const double fontLg = 18.0;
  static const double fontXl = 20.0;
  static const double font2xl = 24.0;
  static const double font3xl = 30.0;
  static const double font4xl = 36.0;
  static const double font5xl = 48.0;
  static const double font6xl = 60.0;
  static const double font7xl = 72.0;
  static const double font8xl = 96.0;
  static const double font9xl = 128.0;

  // Line Heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightSnug = 1.3;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.6;
  static const double lineHeightLoose = 1.8;

  // Letter Spacing
  static const double letterSpacingTighter = -0.8;
  static const double letterSpacingTight = -0.4;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.4;
  static const double letterSpacingWider = 0.8;
  static const double letterSpacingWidest = 1.6;
}

/// Animation Tokens
class AnimationTokens {
  // Duration
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 700);

  // Curves
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticIn = Curves.elasticIn;
  static const Curve elasticOut = Curves.elasticOut;
}
