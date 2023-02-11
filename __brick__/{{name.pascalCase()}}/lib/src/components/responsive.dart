import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final LayoutWidgetBuilder? mobile;
  final LayoutWidgetBuilder? tablet;
  final LayoutWidgetBuilder? desktop;

  const Responsive({
    Key? key,
    this.mobile,
    this.desktop,
    this.tablet,
  }) : super(key: key);

  // This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop help us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1023 &&
      MediaQuery.of(context).size.width > 768;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1023;

  static bool isDesktopConstraints(BoxConstraints constraints) =>
      constraints.maxWidth >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        // final minWidth = constraints.minWidth;
        const notFoundElement = Text('Not found any widget!');

        if (maxWidth <= 768) {
          return mobile != null
              ? mobile!(context, constraints)
              : (tablet != null
                  ? tablet!(context, constraints)
                  : (desktop != null
                      ? desktop!(context, constraints)
                      : notFoundElement));
        }

        if (maxWidth <= 1023) {
          return tablet != null
              ? tablet!(context, constraints)
              : (desktop != null
                  ? desktop!(context, constraints)
                  : notFoundElement);
        }

        return desktop != null ? desktop!(context, constraints) : notFoundElement;
      },
    );
  }
}
