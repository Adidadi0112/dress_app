import 'package:flutter/material.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.inter().fontFamily,
  brightness: Brightness.dark,

  // Color Scheme
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: ColorTokens.darkPrimary,
    onPrimary: ColorTokens.darkText,
    primaryContainer: ColorTokens.darkPrimary.withOpacity(0.7),
    onPrimaryContainer: ColorTokens.darkText,
    secondary: ColorTokens.darkSecondary,
    onSecondary: ColorTokens.darkText,
    secondaryContainer: ColorTokens.darkSecondary.withOpacity(0.7),
    onSecondaryContainer: ColorTokens.darkText,
    tertiary: ColorTokens.darkAccent,
    onTertiary: ColorTokens.darkText,
    tertiaryContainer: ColorTokens.darkAccent.withOpacity(0.7),
    onTertiaryContainer: ColorTokens.darkText,
    error: ColorTokens.error.withOpacity(0.8),
    onError: ColorTokens.midInk,
    errorContainer: ColorTokens.error.withOpacity(0.6),
    onErrorContainer: ColorTokens.midInk,
    background: ColorTokens.darkBackground,
    onBackground: ColorTokens.darkText,
    surface: ColorTokens.darkSurface,
    onSurface: ColorTokens.darkText,
    surfaceVariant: ColorTokens.darkSurface.withOpacity(0.7),
    onSurfaceVariant: ColorTokens.darkTextSecondary,
    outline: ColorTokens.darkBorder,
    outlineVariant: ColorTokens.darkBorder.withOpacity(0.5),
    shadow: Colors.black.withOpacity(0.3),
    scrim: Colors.black.withOpacity(0.5),
    inverseSurface: ColorTokens.lightSurface,
    onInverseSurface: ColorTokens.lightText,
    inversePrimary: ColorTokens.lightPrimary,
  ),

  // AppBar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: ColorTokens.darkBackground,
    foregroundColor: ColorTokens.darkText,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: ColorTokens.darkText,
      size: 24,
      weight: 1.0, // 1px hairline stroke
    ),
    titleTextStyle: GoogleFonts.playfairDisplay(
      color: ColorTokens.darkText,
      fontSize: TypographyTokens.fontXl,
      fontWeight: TypographyTokens.bold,
      letterSpacing: TypographyTokens.letterSpacingTight,
    ),
  ),

  // Card Theme
  cardTheme: CardThemeData(
    color: ColorTokens.darkSurface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusXl),
      side: BorderSide(
        color: ColorTokens.darkBorder,
        width: 1.0,
      ),
    ),
    margin: EdgeInsets.all(SpacingTokens.space8),
    clipBehavior: Clip.antiAlias,
  ),

  // Button Themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorTokens.darkPrimary,
      foregroundColor: ColorTokens.darkText,
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
      foregroundColor: ColorTokens.darkText,
      side: BorderSide(color: ColorTokens.darkBorder, width: 1.0),
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
      foregroundColor: ColorTokens.darkText,
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
    fillColor: ColorTokens.darkSurface,
    contentPadding: EdgeInsets.all(SpacingTokens.space16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: BorderSide(color: ColorTokens.darkBorder, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: BorderSide(color: ColorTokens.darkBorder, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: BorderSide(color: ColorTokens.darkPrimary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide:
          BorderSide(color: ColorTokens.error.withOpacity(0.8), width: 1.0),
    ),
    labelStyle: GoogleFonts.inter(
      color: ColorTokens.darkTextSecondary,
      fontSize: TypographyTokens.fontMd,
    ),
    hintStyle: GoogleFonts.inter(
      color: ColorTokens.darkTextSecondary.withOpacity(0.7),
      fontSize: TypographyTokens.fontMd,
    ),
  ),

  // Icon Theme
  iconTheme: IconThemeData(
    color: ColorTokens.darkText,
    size: 24,
    weight: 1.0, // 1px hairline stroke
  ),

  // Tab Bar Theme
  tabBarTheme: TabBarThemeData(
    labelColor: ColorTokens.darkText,
    unselectedLabelColor: ColorTokens.darkTextSecondary,
    indicatorColor: ColorTokens.darkPrimary,
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
    backgroundColor: ColorTokens.darkPrimary,
    foregroundColor: ColorTokens.darkText,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusCircular),
    ),
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: ColorTokens.darkBackground,
    selectedItemColor: ColorTokens.darkText,
    unselectedItemColor: ColorTokens.darkTextSecondary,
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
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingTight,
      height: TypographyTokens.lineHeightTight,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: TypographyTokens.font3xl,
      fontWeight: TypographyTokens.bold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingTight,
      height: TypographyTokens.lineHeightTight,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: TypographyTokens.font2xl,
      fontWeight: TypographyTokens.regular,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.font2xl,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontXl,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.regular,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.regular,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.regular,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.medium,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightTight,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.medium,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightTight,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontXs,
      fontWeight: TypographyTokens.medium,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightTight,
    ),
  ),
);
