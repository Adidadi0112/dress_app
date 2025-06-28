import 'package:flutter/material.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.inter().fontFamily,
  brightness: Brightness.light,

  // Enhanced Color Scheme
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: ColorTokens.lightPrimary,
    onPrimary: Colors.white,
    primaryContainer: ColorTokens.lightPrimaryVariant,
    onPrimaryContainer: ColorTokens.lightText,
    secondary: ColorTokens.lightSecondary,
    onSecondary: Colors.white,
    secondaryContainer: ColorTokens.lightSecondaryVariant,
    onSecondaryContainer: ColorTokens.lightText,
    tertiary: ColorTokens.lightAccent,
    onTertiary: Colors.white,
    tertiaryContainer: ColorTokens.lightAccentVariant,
    onTertiaryContainer: ColorTokens.lightText,
    error: ColorTokens.error,
    onError: Colors.white,
    errorContainer: ColorTokens.errorLight,
    onErrorContainer: ColorTokens.errorDark,
    background: ColorTokens.lightBackground,
    onBackground: ColorTokens.lightText,
    surface: ColorTokens.lightSurface,
    onSurface: ColorTokens.lightText,
    surfaceVariant: ColorTokens.lightSurfaceSecondary,
    onSurfaceVariant: ColorTokens.lightTextSecondary,
    outline: ColorTokens.lightBorder,
    outlineVariant: ColorTokens.lightBorderVariant,
    shadow: Colors.black.withOpacity(0.08),
    scrim: Colors.black.withOpacity(0.3),
    inverseSurface: ColorTokens.darkSurface,
    onInverseSurface: ColorTokens.darkText,
    inversePrimary: ColorTokens.darkPrimary,
  ),

  // Enhanced AppBar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: ColorTokens.lightBackground,
    foregroundColor: ColorTokens.lightText,
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 4,
    shadowColor: Colors.black.withOpacity(0.1),
    iconTheme: const IconThemeData(
      color: ColorTokens.lightText,
      size: 24,
    ),
    titleTextStyle: GoogleFonts.playfairDisplay(
      color: ColorTokens.lightText,
      fontSize: TypographyTokens.fontXl,
      fontWeight: TypographyTokens.bold,
      letterSpacing: TypographyTokens.letterSpacingTight,
    ),
  ),

  // Enhanced Card Theme
  cardTheme: CardThemeData(
    color: ColorTokens.lightSurface,
    elevation: 0,
    shadowColor: Colors.black.withOpacity(0.08),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusXl),
      side: const BorderSide(
        color: ColorTokens.lightBorderVariant,
        width: 1.0,
      ),
    ),
    margin: const EdgeInsets.all(SpacingTokens.space8),
    clipBehavior: Clip.antiAlias,
  ),

  // Enhanced Button Themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorTokens.lightPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: ColorTokens.lightPrimary.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.space24,
        vertical: SpacingTokens.space16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: TypographyTokens.fontMd,
        fontWeight: TypographyTokens.semiBold,
        letterSpacing: TypographyTokens.letterSpacingWide,
      ),
    ).copyWith(
      elevation: MaterialStateProperty.resolveWith<double>((states) {
        if (states.contains(MaterialState.pressed)) return 2;
        if (states.contains(MaterialState.hovered)) return 4;
        return 0;
      }),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ColorTokens.lightPrimary,
      side: const BorderSide(color: ColorTokens.lightPrimary, width: 1.5),
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.space24,
        vertical: SpacingTokens.space16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: TypographyTokens.fontMd,
        fontWeight: TypographyTokens.semiBold,
        letterSpacing: TypographyTokens.letterSpacingWide,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: ColorTokens.lightPrimary,
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.space16,
        vertical: SpacingTokens.space12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusMd),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: TypographyTokens.fontMd,
        fontWeight: TypographyTokens.semiBold,
        letterSpacing: TypographyTokens.letterSpacingWide,
      ),
    ),
  ),

  // Enhanced Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: ColorTokens.lightSurface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: SpacingTokens.space16,
      vertical: SpacingTokens.space16,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: const BorderSide(color: ColorTokens.lightBorder, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: const BorderSide(color: ColorTokens.lightBorder, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: const BorderSide(color: ColorTokens.lightPrimary, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: const BorderSide(color: ColorTokens.error, width: 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: const BorderSide(color: ColorTokens.error, width: 2.0),
    ),
    labelStyle: GoogleFonts.inter(
      color: ColorTokens.lightTextSecondary,
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.medium,
    ),
    hintStyle: GoogleFonts.inter(
      color: ColorTokens.lightTextTertiary,
      fontSize: TypographyTokens.fontMd,
    ),
    floatingLabelStyle: GoogleFonts.inter(
      color: ColorTokens.lightPrimary,
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.medium,
    ),
  ),

  // Enhanced Icon Theme
  iconTheme: const IconThemeData(
    color: ColorTokens.lightText,
    size: 24,
  ),

  // Enhanced Tab Bar Theme
  tabBarTheme: TabBarThemeData(
    labelColor: ColorTokens.lightPrimary,
    unselectedLabelColor: ColorTokens.lightTextSecondary,
    indicatorColor: ColorTokens.lightPrimary,
    indicatorSize: TabBarIndicatorSize.label,
    indicator: UnderlineTabIndicator(
      borderSide: const BorderSide(color: ColorTokens.lightPrimary, width: 3),
      borderRadius: BorderRadius.circular(RadiusTokens.radiusSm),
    ),
    labelStyle: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.semiBold,
    ),
    unselectedLabelStyle: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.medium,
    ),
  ),

  // Enhanced Floating Action Button Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: ColorTokens.lightPrimary,
    foregroundColor: Colors.white,
    elevation: 6,
    highlightElevation: 12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusCircular),
    ),
  ),

  // Enhanced Bottom Navigation Bar Theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: ColorTokens.lightSurface,
    selectedItemColor: ColorTokens.lightPrimary,
    unselectedItemColor: ColorTokens.lightTextSecondary,
    selectedLabelStyle: GoogleFonts.inter(
      fontSize: TypographyTokens.fontXs,
      fontWeight: TypographyTokens.semiBold,
    ),
    unselectedLabelStyle: GoogleFonts.inter(
      fontSize: TypographyTokens.fontXs,
      fontWeight: TypographyTokens.medium,
    ),
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),

  // Enhanced Text Theme
  textTheme: TextTheme(
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: TypographyTokens.font4xl,
      fontWeight: TypographyTokens.bold,
      color: ColorTokens.lightText,
      letterSpacing: TypographyTokens.letterSpacingTight,
      height: TypographyTokens.lineHeightTight,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: TypographyTokens.font3xl,
      fontWeight: TypographyTokens.bold,
      color: ColorTokens.lightText,
      letterSpacing: TypographyTokens.letterSpacingTight,
      height: TypographyTokens.lineHeightTight,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: TypographyTokens.font2xl,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.lightText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightSnug,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.font2xl,
      fontWeight: TypographyTokens.bold,
      color: ColorTokens.lightText,
      letterSpacing: TypographyTokens.letterSpacingTight,
      height: TypographyTokens.lineHeightSnug,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontXl,
      fontWeight: TypographyTokens.bold,
      color: ColorTokens.lightText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightSnug,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.lightText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightSnug,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.lightText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightSnug,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.lightText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightSnug,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.lightText,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightSnug,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.regular,
      color: ColorTokens.lightText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.regular,
      color: ColorTokens.lightText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.regular,
      color: ColorTokens.lightTextSecondary,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.lightText,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightSnug,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.medium,
      color: ColorTokens.lightTextSecondary,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightSnug,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontXs,
      fontWeight: TypographyTokens.medium,
      color: ColorTokens.lightTextTertiary,
      letterSpacing: TypographyTokens.letterSpacingWider,
      height: TypographyTokens.lineHeightSnug,
    ),
  ),

  // Enhanced Divider Theme
  dividerTheme: const DividerThemeData(
    color: ColorTokens.lightBorderVariant,
    thickness: 1,
    space: SpacingTokens.space16,
  ),

  // Enhanced Chip Theme
  chipTheme: ChipThemeData(
    backgroundColor: ColorTokens.lightSurfaceSecondary,
    selectedColor: ColorTokens.lightPrimary.withOpacity(0.12),
    secondarySelectedColor: ColorTokens.lightSecondary.withOpacity(0.12),
    padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.space12),
    labelStyle: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.medium,
    ),
    secondaryLabelStyle: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.medium,
    ),
    brightness: Brightness.light,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusCircular),
    ),
  ),
);
