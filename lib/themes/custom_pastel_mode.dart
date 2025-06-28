import 'package:flutter/material.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:google_fonts/google_fonts.dart';

/// Creates a custom pastel theme based on user-selected colors
ThemeData createCustomPastelTheme({
  required Color primaryColor,
  required Color secondaryColor,
  required Color accentColor,
  required bool isDarkMode,
}) {
  // Ensure colors have pastel quality
  final Color adjustedPrimary = _ensurePastelQuality(primaryColor);
  final Color adjustedSecondary = _ensurePastelQuality(secondaryColor);
  final Color adjustedAccent = _ensurePastelQuality(accentColor);

  // Base colors for text and backgrounds
  final Color textColor =
      isDarkMode ? ColorTokens.darkText : ColorTokens.midInk;
  final Color backgroundColor =
      isDarkMode ? ColorTokens.darkBackground : ColorTokens.lightBackground;
  final Color surfaceColor =
      isDarkMode ? ColorTokens.darkSurface : ColorTokens.lightSurface;
  final Color borderColor =
      isDarkMode ? ColorTokens.darkBorder : ColorTokens.lightBorder;
  final Color textSecondaryColor = isDarkMode
      ? ColorTokens.darkTextSecondary
      : ColorTokens.lightTextSecondary;

  // Create theme
  return ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,

    // Color Scheme
    colorScheme: ColorScheme(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primary: adjustedPrimary,
      onPrimary: ColorTokens.ensureContrast(adjustedPrimary, textColor),
      primaryContainer: adjustedPrimary.withOpacity(0.7),
      onPrimaryContainer: ColorTokens.ensureContrast(
          adjustedPrimary.withOpacity(0.7), textColor),
      secondary: adjustedSecondary,
      onSecondary: ColorTokens.ensureContrast(adjustedSecondary, textColor),
      secondaryContainer: adjustedSecondary.withOpacity(0.7),
      onSecondaryContainer: ColorTokens.ensureContrast(
          adjustedSecondary.withOpacity(0.7), textColor),
      tertiary: adjustedAccent,
      onTertiary: ColorTokens.ensureContrast(adjustedAccent, textColor),
      tertiaryContainer: adjustedAccent.withOpacity(0.7),
      onTertiaryContainer: ColorTokens.ensureContrast(
          adjustedAccent.withOpacity(0.7), textColor),
      error: ColorTokens.error,
      onError: ColorTokens.midInk,
      errorContainer: ColorTokens.error.withOpacity(0.7),
      onErrorContainer: ColorTokens.midInk,
      background: backgroundColor,
      onBackground: textColor,
      surface: surfaceColor,
      onSurface: textColor,
      surfaceVariant: surfaceColor.withOpacity(0.7),
      onSurfaceVariant: textSecondaryColor,
      outline: borderColor,
      outlineVariant: borderColor.withOpacity(0.5),
      shadow: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
      scrim: Colors.black.withOpacity(isDarkMode ? 0.5 : 0.3),
      inverseSurface:
          isDarkMode ? ColorTokens.lightSurface : ColorTokens.darkSurface,
      onInverseSurface:
          isDarkMode ? ColorTokens.lightText : ColorTokens.darkText,
      inversePrimary:
          isDarkMode ? ColorTokens.lightPrimary : ColorTokens.darkPrimary,
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: textColor,
        size: 24,
        weight: 1.0, // 1px hairline stroke
      ),
      titleTextStyle: GoogleFonts.playfairDisplay(
        color: textColor,
        fontSize: TypographyTokens.fontXl,
        fontWeight: TypographyTokens.bold,
        letterSpacing: TypographyTokens.letterSpacingTight,
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusXl),
        side: BorderSide(
          color: borderColor,
          width: 1.0,
        ),
      ),
      margin: const EdgeInsets.all(SpacingTokens.space8),
      clipBehavior: Clip.antiAlias,
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: adjustedPrimary,
        foregroundColor: ColorTokens.ensureContrast(adjustedPrimary, textColor),
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: SpacingTokens.space24,
          vertical: SpacingTokens.space16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: TypographyTokens.fontMd,
          fontWeight: TypographyTokens.medium,
          letterSpacing: TypographyTokens.letterSpacingWide,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        side: BorderSide(color: borderColor, width: 1.0),
        padding: EdgeInsets.symmetric(
          horizontal: SpacingTokens.space24,
          vertical: SpacingTokens.space16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: TypographyTokens.fontMd,
          fontWeight: TypographyTokens.medium,
          letterSpacing: TypographyTokens.letterSpacingWide,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(
          horizontal: SpacingTokens.space16,
          vertical: SpacingTokens.space8,
        ),
        textStyle: GoogleFonts.inter(
          fontSize: TypographyTokens.fontMd,
          fontWeight: TypographyTokens.medium,
          letterSpacing: TypographyTokens.letterSpacingWide,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      contentPadding: EdgeInsets.all(SpacingTokens.space16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
        borderSide: BorderSide(color: borderColor, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
        borderSide: BorderSide(color: borderColor, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
        borderSide: BorderSide(color: adjustedPrimary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
        borderSide: BorderSide(color: ColorTokens.error, width: 1.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryColor,
        fontSize: TypographyTokens.fontMd,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondaryColor.withOpacity(0.7),
        fontSize: TypographyTokens.fontMd,
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(
      color: textColor,
      size: 24,
      weight: 1.0, // 1px hairline stroke
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarTheme(
      labelColor: textColor,
      unselectedLabelColor: textSecondaryColor,
      indicatorColor: adjustedPrimary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: TypographyTokens.fontMd,
        fontWeight: TypographyTokens.medium,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: TypographyTokens.fontMd,
        fontWeight: TypographyTokens.regular,
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: adjustedPrimary,
      foregroundColor: ColorTokens.ensureContrast(adjustedPrimary, textColor),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusCircular),
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      selectedItemColor: textColor,
      unselectedItemColor: textSecondaryColor,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: TypographyTokens.fontXs,
        fontWeight: TypographyTokens.medium,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: TypographyTokens.fontXs,
        fontWeight: TypographyTokens.regular,
      ),
      elevation: 0,
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: TypographyTokens.font4xl,
        fontWeight: TypographyTokens.bold,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingTight,
        height: TypographyTokens.lineHeightTight,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: TypographyTokens.font3xl,
        fontWeight: TypographyTokens.bold,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingTight,
        height: TypographyTokens.lineHeightTight,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: TypographyTokens.font2xl,
        fontWeight: TypographyTokens.regular,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingNormal,
        height: TypographyTokens.lineHeightTight,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: TypographyTokens.font2xl,
        fontWeight: TypographyTokens.semiBold,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingNormal,
        height: TypographyTokens.lineHeightTight,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: TypographyTokens.fontXl,
        fontWeight: TypographyTokens.semiBold,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingNormal,
        height: TypographyTokens.lineHeightTight,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: TypographyTokens.fontLg,
        fontWeight: TypographyTokens.semiBold,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingNormal,
        height: TypographyTokens.lineHeightTight,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: TypographyTokens.fontLg,
        fontWeight: TypographyTokens.semiBold,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingNormal,
        height: TypographyTokens.lineHeightTight,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: TypographyTokens.fontMd,
        fontWeight: TypographyTokens.semiBold,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingNormal,
        height: TypographyTokens.lineHeightTight,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: TypographyTokens.fontSm,
        fontWeight: TypographyTokens.semiBold,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingNormal,
        height: TypographyTokens.lineHeightTight,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: TypographyTokens.fontLg,
        fontWeight: TypographyTokens.regular,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingNormal,
        height: TypographyTokens.lineHeightNormal,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: TypographyTokens.fontMd,
        fontWeight: TypographyTokens.regular,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingNormal,
        height: TypographyTokens.lineHeightNormal,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: TypographyTokens.fontSm,
        fontWeight: TypographyTokens.regular,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingNormal,
        height: TypographyTokens.lineHeightNormal,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: TypographyTokens.fontMd,
        fontWeight: TypographyTokens.medium,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingWide,
        height: TypographyTokens.lineHeightTight,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: TypographyTokens.fontSm,
        fontWeight: TypographyTokens.medium,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingWide,
        height: TypographyTokens.lineHeightTight,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: TypographyTokens.fontXs,
        fontWeight: TypographyTokens.medium,
        color: textColor,
        letterSpacing: TypographyTokens.letterSpacingWide,
        height: TypographyTokens.lineHeightTight,
      ),
    ),
  );
}

/// Helper function to ensure a color has pastel quality
Color _ensurePastelQuality(Color color) {
  final HSLColor hsl = HSLColor.fromColor(color);

  // Pastel colors typically have high lightness and moderate saturation
  double adjustedSaturation = hsl.saturation;
  double adjustedLightness = hsl.lightness;

  // Adjust saturation to be in the pastel range (0.15-0.4)
  if (adjustedSaturation > 0.4) {
    adjustedSaturation = 0.4;
  } else if (adjustedSaturation < 0.15) {
    adjustedSaturation = 0.15;
  }

  // Adjust lightness to be in the pastel range (0.75-0.9)
  if (adjustedLightness < 0.75) {
    adjustedLightness = 0.75;
  } else if (adjustedLightness > 0.9) {
    adjustedLightness = 0.9;
  }

  return HSLColor.fromAHSL(
    hsl.alpha,
    hsl.hue,
    adjustedSaturation,
    adjustedLightness,
  ).toColor();
}
