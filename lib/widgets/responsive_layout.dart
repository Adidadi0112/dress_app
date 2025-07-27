import 'package:flutter/material.dart';
import 'package:dress_app/theme/responsive.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveHelper.isDesktop(context) && desktop != null) {
          return desktop!;
        } else if (ResponsiveHelper.isTablet(context) && tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? _getMaxWidth(context),
        ),
        child: Padding(
          padding: padding ?? ResponsiveHelper.getResponsivePadding(context),
          child: child,
        ),
      ),
    );
  }

  double _getMaxWidth(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return 1200;
    } else if (ResponsiveHelper.isTablet(context)) {
      return 800;
    } else {
      return double.infinity;
    }
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? crossAxisCount;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    final count = crossAxisCount ??
        ResponsiveHelper.getResponsiveGridCrossAxisCount(context);

    return GridView.count(
      crossAxisCount: count,
      crossAxisSpacing: spacing,
      mainAxisSpacing: runSpacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

class ResponsiveListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;

  const ResponsiveListView({
    super.key,
    required this.children,
    this.padding,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding ?? ResponsiveHelper.getResponsivePadding(context),
      physics: physics,
      children: children,
    );
  }
}
