import 'package:flutter/material.dart';

class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const ResponsiveContent({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(
      20,
      12,
      20,
      32,
    ),
    this.maxWidth = 520,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        final horizontalPadding =
            availableWidth < 360 ? 16.0 : 20.0;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}