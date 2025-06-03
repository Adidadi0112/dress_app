import 'package:flutter/material.dart';
import 'package:dress_app/theme/tokens.dart';

/// Typography styles for the Wardrobe Journal app
/// This file contains all the text styles used throughout the app
/// based on the typography tokens defined in tokens.dart

class AppTypography {
  // Display styles (using Playfair Display)
  static TextStyle displayLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.displayFontFamily,
      fontSize: TypographyTokens.font4xl,
      fontWeight: TypographyTokens.bold,
      letterSpacing: TypographyTokens.letterSpacingTight,
      height: TypographyTokens.lineHeightTight,
      color: color ?? Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle displayMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.displayFontFamily,
      fontSize: TypographyTokens.font3xl,
      fontWeight: TypographyTokens.bold,
      letterSpacing: TypographyTokens.letterSpacingTight,
      height: TypographyTokens.lineHeightTight,
      color: color ?? Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle displaySmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.displayFontFamily,
      fontSize: TypographyTokens.font2xl,
      fontWeight: TypographyTokens.regular,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
      color: color ?? Theme.of(context).colorScheme.onBackground,
    );
  }

  // Heading styles (using Inter)
  static TextStyle headingLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.primaryFontFamily,
      fontSize: TypographyTokens.font2xl,
      fontWeight: TypographyTokens.semiBold,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
      color: color ?? Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle headingMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.primaryFontFamily,
      fontSize: TypographyTokens.fontXl,
      fontWeight: TypographyTokens.semiBold,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
      color: color ?? Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle headingSmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.primaryFontFamily,
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.semiBold,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightTight,
      color: color ?? Theme.of(context).colorScheme.onBackground,
    );
  }

  // Body styles (using Inter)
  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.primaryFontFamily,
      fontSize: TypographyTokens.fontLg,
      fontWeight: TypographyTokens.regular,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
      color: color ?? Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.primaryFontFamily,
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.regular,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
      color: color ?? Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle bodySmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.primaryFontFamily,
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.regular,
      letterSpacing: TypographyTokens.letterSpacingNormal,
      height: TypographyTokens.lineHeightNormal,
      color: color ?? Theme.of(context).colorScheme.onBackground,
    );
  }

  // Caption style (using Inter)
  static TextStyle caption(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.primaryFontFamily,
      fontSize: TypographyTokens.fontXs,
      fontWeight: TypographyTokens.regular,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightNormal,
      color: color ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
    );
  }

  // Button styles (using Inter)
  static TextStyle buttonLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.primaryFontFamily,
      fontSize: TypographyTokens.fontMd,
      fontWeight: TypographyTokens.medium,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightTight,
      color: color ?? Theme.of(context).colorScheme.onPrimary,
    );
  }

  static TextStyle buttonMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.primaryFontFamily,
      fontSize: TypographyTokens.fontSm,
      fontWeight: TypographyTokens.medium,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightTight,
      color: color ?? Theme.of(context).colorScheme.onPrimary,
    );
  }

  static TextStyle buttonSmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: TypographyTokens.primaryFontFamily,
      fontSize: TypographyTokens.fontXs,
      fontWeight: TypographyTokens.medium,
      letterSpacing: TypographyTokens.letterSpacingWide,
      height: TypographyTokens.lineHeightTight,
      color: color ?? Theme.of(context).colorScheme.onPrimary,
    );
  }
}
