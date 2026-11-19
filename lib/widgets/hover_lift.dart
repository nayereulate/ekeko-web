import 'package:flutter/material.dart';

/// Eleva y agranda ligeramente el contenido al pasar el cursor (web/escritorio).
class HoverLift extends StatefulWidget {
  final Widget child;
  final double scale;
  final BorderRadius borderRadius;
  const HoverLift({
    super.key,
    required this.child,
    this.scale = 1.02,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
  });

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: _hover
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.16), blurRadius: 22, offset: const Offset(0, 10))]
                : const [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Aparición con desvanecido + leve deslizamiento hacia arriba.
class FadeInUp extends StatefulWidget {
  final Widget child;
  final int delayMs;
  const FadeInUp({super.key, required this.child, this.delayMs = 0});

  @override
  State<FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<FadeInUp> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
  late final Animation<double> _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(_fade);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () { if (mounted) _c.forward(); });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _fade, child: SlideTransition(position: _slide, child: widget.child));
}
