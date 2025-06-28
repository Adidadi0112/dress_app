import 'package:flutter/material.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.inter().fontFamily,
  brightness: Brightness.dark,

  // Enhanced Color Scheme
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: ColorTokens.darkPrimary,
    onPrimary: ColorTokens.darkBackground,
    primaryContainer: ColorTokens.darkPrimaryVariant,
    onPrimaryContainer: ColorTokens.darkText,
    secondary: ColorTokens.darkSecondary,
    onSecondary: ColorTokens.darkBackground,
    secondaryContainer: ColorTokens.darkSecondaryVariant,
    onSecondaryContainer: ColorTokens.darkText,
    tertiary: ColorTokens.darkAccent,
    onTertiary: ColorTokens.darkBackground,
    tertiaryContainer: ColorTokens.darkAccentVariant,
    onTertiaryContainer: ColorTokens.darkText,
    error: ColorTokens.error,
    onError: Colors.white,
    errorContainer: ColorTokens.errorDark,
    onErrorContainer: ColorTokens.errorLight,
    background: ColorTokens.darkBackground,
    onBackground: ColorTokens.darkText,
    surface: ColorTokens.darkSurface,
    onSurface: ColorTokens.darkText,
    surfaceVariant: ColorTokens.darkSurfaceSecondary,
    onSurfaceVariant: ColorTokens.darkTextSecondary,
    outline: ColorTokens.darkBorder,
    outlineVariant: ColorTokens.darkBorderVariant,
    shadow: Colors.black.withOpacity(0.4),
    scrim: Colors.black.withOpacity(0.6),
    inverseSurface: ColorTokens.lightSurface,
    onInverseSurface: ColorTokens.lightText,
    inversePrimary: ColorTokens.lightPrimary,
  ),

  // Enhanced AppBar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: ColorTokens.darkBackground,
    foregroundColor: ColorTokens.darkText,
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 4,
    shadowColor: Colors.black.withOpacity(0.3),
    iconTheme: const IconThemeData(
      color: ColorTokens.darkText,
      size: 24,
    ),
    titleTextStyle: GoogleFonts.playfairDisplay(
      color: ColorTokens.darkText,
      fontSize: TypographyTokens.fontXl,
      fontWeight: TypographyTokens.bold,
      letterSpacing: TypographyTokens.letterSpacingTight,
    ),
  ),

  // Enhanced Card Theme
  cardTheme: CardThemeData(
    color: ColorTokens.darkSurface,
    elevation: 0,
    shadowColor: Colors.black.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusXl),
      side: const BorderSide(
        color: ColorTokens.darkBorderVariant,
        width: 1.0,
      ),
    ),
    margin: const EdgeInsets.all(SpacingTokens.space8),
    clipBehavior: Clip.antiAlias,
  ),

  // Enhanced Button Themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorTokens.darkPrimary,
      foregroundColor: ColorTokens.darkBackground,
      elevation: 0,
      shadowColor: ColorTokens.darkPrimary.withOpacity(0.3),
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
        if (states.contains(MaterialState.hovered)) return 6;
        return 0;
      }),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ColorTokens.darkPrimary,
      side: const BorderSide(color: ColorTokens.darkPrimary, width: 1.5),
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
      foregroundColor: ColorTokens.darkPrimary,
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
    fillColor: ColorTokens.darkSurface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: SpacingTokens.space16,
      vertical: SpacingTokens.space16,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: const BorderSide(color: ColorTokens.darkBorder, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: const BorderSide(color: ColorTokens.darkBorder, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
      borderSide: const BorderSide(color: ColorTokens.darkPrimary, width: 2.0),
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
      color: ColorTokens.darkTextSecondary,
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.medium,
    ),
    hintStyle: GoogleFonts.inter(
      color: ColorTokens.darkTextTertiary,
      fontSize: TypographyTokens.fontMd,
    ),
    floatingLabelStyle: GoogleFonts.inter(
      color: ColorTokens.darkPrimary,
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.medium,
    ),
  ),

  // Enhanced Icon Theme
  iconTheme: const IconThemeData(
    color: ColorTokens.darkText,
    size: 24,
  ),

  // Enhanced Tab Bar Theme
  tabBarTheme: TabBarThemeData(
    labelColor: ColorTokens.darkPrimary,
    unselectedLabelColor: ColorTokens.darkTextSecondary,
    indicatorColor: ColorTokens.darkPrimary,
    indicatorSize: TabBarIndicatorSize.label,
    indicator: UnderlineTabIndicator(
      borderSide: const BorderSide(color: ColorTokens.darkPrimary, width: 3),
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
    backgroundColor: ColorTokens.darkPrimary,
    foregroundColor: ColorTokens.darkBackground,
    elevation: 8,
    highlightElevation: 16,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusCircular),
    ),
  ),

  // Enhanced Bottom Navigation Bar Theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: ColorTokens.darkSurface,
    selectedItemColor: ColorTokens.darkPrimary,
    unselectedItemColor: ColorTokens.darkTextSecondary,
    selectedLabelStyle: GoogleFonts.inter(
      fontSize: TypographyTokens.fontXs,
      fontWeight: TypographyTokens.semiBold,
    ),
    unselectedLabelStyle: GoogleFonts.inter(
      fontSize: TypographyTokens.fontXs,
      fontWeight: TypographyTokens.medium,
    ),
    elevation: 12,
    type: BottomNavigationBarType.fixed,
  ),

  // Enhanced Text Theme
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
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightSnug,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.font2xl,
      fontWeight: TypographyTokens.bold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingTight,
      height: TypographyTokens.lineHeightSnug,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontXl,
      fontWeight: TypographyTokens.bold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightSnug,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightSnug,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightSnug,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightSnug,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightSnug,
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
      color: ColorTokens.darkTextSecondary,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.semiBold,
      color: ColorTokens.darkText,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightSnug,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.medium,
      color: ColorTokens.darkTextSecondary,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightSnug,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: TypographyTokens.fontXs,
      fontWeight: TypographyTokens.medium,
      color: ColorTokens.darkTextTertiary,
      letterSpacing: TypographyTokens.letterSpacingWider,
      height: TypographyTokens.lineHeightSnug,
    ),
  ),

  // Enhanced Divider Theme
  dividerTheme: const DividerThemeData(
    color: ColorTokens.darkBorderVariant,
    thickness: 1,
    space: SpacingTokens.space16,
  ),

  // Enhanced Chip Theme
  chipTheme: ChipThemeData(
    backgroundColor: ColorTokens.darkSurfaceSecondary,
    selectedColor: ColorTokens.darkPrimary.withOpacity(0.2),
    secondarySelectedColor: ColorTokens.darkSecondary.withOpacity(0.2),
    padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.space12),
    labelStyle: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.medium,
      color: ColorTokens.darkText,
    ),
    secondaryLabelStyle: GoogleFonts.inter(
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.medium,
      color: ColorTokens.darkText,
    ),
    brightness: Brightness.dark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusCircular),
    ),
  ),
);
