import 'package:flutter/material.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.inter().fontFamily,
  brightness: Brightness.light,

  // Color Scheme
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: ColorTokens.lightPrimary,
    onPrimary: ColorTokens.midInk,
    primaryContainer: ColorTokens.rosePetal.withOpacity(0.7),
    onPrimaryContainer: ColorTokens.midInk,
    secondary: ColorTokens.lightSecondary,
    onSecondary: ColorTokens.midInk,
    secondaryContainer: ColorTokens.lavenderMist.withOpacity(0.7),
    onSecondaryContainer: ColorTokens.midInk,
    tertiary: ColorTokens.lightAccent,
    onTertiary: ColorTokens.midInk,
    tertiaryContainer: ColorTokens.mintFoam.withOpacity(0.7),
    onTertiaryContainer: ColorTokens.midInk,
    error: ColorTokens.error,
    onError: ColorTokens.midInk,
    errorContainer: ColorTokens.error.withOpacity(0.7),
    onErrorContainer: ColorTokens.midInk,
    background: ColorTokens.lightBackground,
    onBackground: ColorTokens.lightText,
    surface: ColorTokens.lightSurface,
    onSurface: ColorTokens.lightText,
    surfaceVariant: ColorTokens.lightSurface.withOpacity(0.7),
    onSurfaceVariant: ColorTokens.lightTextSecondary,
    outline: ColorTokens.lightBorder,
    outlineVariant: ColorTokens.lightBorder.withOpacity(0.5),
    shadow: Colors.black.withOpacity(0.1),
    scrim: Colors.black.withOpacity(0.3),
    inverseSurface: ColorTokens.darkSurface,
    onInverseSurface: ColorTokens.darkText,
    inversePrimary: ColorTokens.darkPrimary,
  ),

  // AppBar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: ColorTokens.lightBackground,
    foregroundColor: ColorTokens.midInk,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: ColorTokens.midInk,
      size: 24,
      weight: 1.0, // 1px hairline stroke
    ),
    titleTextStyle: GoogleFonts.playfairDisplay(
      color: ColorTokens.midInk,
      fontSize: TypographyTokens.fontXl,
      fontWeight: TypographyTokens.bold,
      letterSpacing: TypographyTokens.letterSpacingTight,
    ),
  ),

  // Card Theme
  cardTheme: CardThemeData(
    color: ColorTokens.lightSurface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusXl),
      side: BorderSide(
        color: ColorTokens.lightBorder,
        width: 1.0,
      ),
    ),
    margin: EdgeInsets.all(SpacingTokens.space8),
    clipBehavior: Clip.antiAlias,
  ),

  // Button Themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorTokens.lightPrimary,
      foregroundColor: ColorTokens.midInk,
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
      foregroundColor: ColorTokens.midInk,
      side: BorderSide(color: ColorTokens.lightBorder, width: 1.0),
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
      foregroundColor: ColorTokens.midInk,
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
    fillColor: ColorTokens.lightSurface,
    contentPadding: EdgeInsets.all(SpacingTokens.space16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: BorderSide(color: ColorTokens.lightBorder, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: BorderSide(color: ColorTokens.lightBorder, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: BorderSide(color: ColorTokens.lightPrimary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: BorderSide(color: ColorTokens.error, width: 1.0),
    ),
    labelStyle: GoogleFonts.inter(
      color: ColorTokens.lightTextSecondary,
      fontSize: TypographyTokens.fontMd,
    ),
    hintStyle: GoogleFonts.inter(
      color: ColorTokens.lightTextSecondary.withOpacity(0.7),
      fontSize: TypographyTokens.fontMd,
    ),
  ),

  // Icon Theme
  iconTheme: IconThemeData(
    color: ColorTokens.midInk,
    size: 24,
    weight: 1.0, // 1px hairline stroke
  ),

  // Tab Bar Theme
  tabBarTheme: TabBarThemeData(
    labelColor: ColorTokens.midInk,
    unselectedLabelColor: ColorTokens.lightTextSecondary,
    indicatorColor: ColorTokens.lightPrimary,
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
    backgroundColor: ColorTokens.lightPrimary,
    foregroundColor: ColorTokens.midInk,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusCircular),
    ),
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: ColorTokens.lightBackground,
    selectedItemColor: ColorTokens.midInk,
    unselectedItemColor: ColorTokens.lightTextSecondary,
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
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingTight,
      height: TypographyTokens.lineHeightTight,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: TypographyTokens.font3xl,
      fontWeight: TypographyTokens.bold,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingTight,
      height: TypographyTokens.lineHeightTight,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: TypographyTokens.font2xl,
      fontWeight: TypographyTokens.regular,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.font2xl,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontXl,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.regular,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.regular,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.regular,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.medium,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightTight,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.medium,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightTight,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontXs,
      fontWeight: TypographyTokens.medium,
      color: ColorTokens.midInk,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightTight,
    ),
  ),
);
