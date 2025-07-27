import 'package:flutter/material.dart';

class ResponsiveBreakpoints {
  // Mobile breakpoints
  static const double mobileSmall = 320;
  static const double mobileMedium = 375;
  static const double mobileLarge = 414;

  // Tablet breakpoints
  static const double tabletSmall = 768;
  static const double tabletLarge = 1024;

  // Desktop breakpoints
  static const double desktopSmall = 1200;
  static const double desktopMedium = 1440;
  static const double desktopLarge = 1920;
}

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <
        ResponsiveBreakpoints.tabletSmall;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= ResponsiveBreakpoints.tabletSmall &&
        width < ResponsiveBreakpoints.desktopSmall;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >=
        ResponsiveBreakpoints.desktopSmall;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width <
        ResponsiveBreakpoints.mobileMedium;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >=
        ResponsiveBreakpoints.tabletLarge;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  static double getResponsiveFontSize(
    BuildContext context, {
    double mobile = 14.0,
    double tablet = 16.0,
    double desktop = 18.0,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return desktop;
    }
  }

  static int getResponsiveGridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }

  static double getResponsiveCardWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isMobile(context)) {
      return screenWidth * 0.9;
    } else if (isTablet(context)) {
      return screenWidth * 0.45;
    } else {
      return screenWidth * 0.3;
    }
  }

  static double getResponsiveCardHeight(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    if (isMobile(context)) {
      return screenHeight * 0.4;
    } else if (isTablet(context)) {
      return screenHeight * 0.35;
    } else {
      return screenHeight * 0.3;
    }
  }
}

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (ResponsiveHelper.isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
