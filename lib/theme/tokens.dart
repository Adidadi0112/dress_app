import 'package:flutter/material.dart';

/// Design tokens for the Wardrobe Journal app
/// This file contains all the design tokens used throughout the app
/// including colors, spacing, typography, radii, and elevations.

/// Color Tokens
class ColorTokens {
  // Base Pastel Colors
  static const Color rosePetal = Color(0xFFF8E8EE);
  static const Color lavenderMist = Color(0xFFEAE6FF);
  static const Color mintFoam = Color(0xFFE9F7F4);
  static const Color midInk = Color(0xFF3A3A40);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFCFCFC);
  static const Color lightSurface = Color(0xFFF8F8F8);
  static const Color lightPrimary = rosePetal;
  static const Color lightSecondary = lavenderMist;
  static const Color lightAccent = mintFoam;
  static const Color lightText = midInk;
  static const Color lightTextSecondary = Color(0xFF6E6E78);
  static const Color lightBorder = Color(0xFFEAEAEA);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF1A1A1F);
  static const Color darkSurface = Color(0xFF2A2A30);
  static const Color darkPrimary = Color(0xFF9E8C94); // Darker rose petal
  static const Color darkSecondary = Color(0xFF8C89B0); // Darker lavender
  static const Color darkAccent = Color(0xFF7EADA5); // Darker mint
  static const Color darkText = Color(0xFFF0F0F0);
  static const Color darkTextSecondary = Color(0xFFB0B0B8);
  static const Color darkBorder = Color(0xFF3A3A40);

  // Semantic Colors
  static const Color success = Color(0xFFAFD0BF);
  static const Color error = Color(0xFFECB8B8);
  static const Color warning = Color(0xFFF8E3C5);
  static const Color info = Color(0xFFB8D8EC);

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
}

/// Spacing Tokens (4-pt grid)
class SpacingTokens {
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space56 = 56.0;
  static const double space64 = 64.0;
  static const double space80 = 80.0;
  static const double space96 = 96.0;
  static const double space128 = 128.0;
}

/// Border Radius Tokens
class RadiusTokens {
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusCircular = 999.0;
}

/// Elevation Tokens
class ElevationTokens {
  static List<BoxShadow> none = [];

  static List<BoxShadow> subtle = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> low = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> high = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  // Neumorphic elevation for primary cards
  static List<BoxShadow> neumorphic(Color baseColor) {
    final Color lightenedColor = Color.lerp(baseColor, Colors.white, 0.8)!;
    final Color darkenedColor = Color.lerp(baseColor, Colors.black, 0.2)!;

    return [
      // Inner shadow (top-left)
      BoxShadow(
        color: lightenedColor,
        offset: const Offset(-3, -3),
        blurRadius: 6,
      ),
      // Inner shadow (bottom-right)
      BoxShadow(
        color: darkenedColor,
        offset: const Offset(3, 3),
        blurRadius: 6,
      ),
    ];
  }
}

/// Typography Scale Tokens
class TypographyTokens {
  // Font Families - Using Google Fonts instead of local fonts
  static const String primaryFontFamily = 'Inter';
  static const String displayFontFamily = 'Playfair Display';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Font Sizes
  static const double fontXs = 12.0;
  static const double fontSm = 14.0;
  static const double fontMd = 16.0;
  static const double fontLg = 18.0;
  static const double fontXl = 20.0;
  static const double font2xl = 24.0;
  static const double font3xl = 30.0;
  static const double font4xl = 36.0;

  // Line Heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.8;

  // Letter Spacing
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;
}
