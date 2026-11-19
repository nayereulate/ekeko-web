import 'package:flutter/material.dart';

/// Breakpoints de diseño responsivo.
const double kTabletBreak = 640;
const double kDesktopBreak = 900;
const double kContentMaxWidth = 1180;

bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= kDesktopBreak;
bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= kTabletBreak;

/// Centra el contenido con un ancho máximo (mejor lectura en PC).
class MaxWidthBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  const MaxWidthBox({super.key, required this.child, this.maxWidth = kContentMaxWidth, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Nº de columnas según el ancho disponible.
int gridColumnsFor(double width, {double tile = 320}) {
  if (width >= kContentMaxWidth) return 3;
  if (width >= kDesktopBreak) return 3;
  if (width >= kTabletBreak) return 2;
  return 1;
}
