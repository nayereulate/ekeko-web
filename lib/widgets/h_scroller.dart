import 'package:flutter/material.dart';
import 'responsive.dart';

/// Lista horizontal deslizable con botones de flecha en escritorio.
class HScroller extends StatefulWidget {
  final double height;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing;
  final EdgeInsets padding;
  const HScroller({
    super.key,
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
    this.spacing = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
  });

  @override
  State<HScroller> createState() => _HScrollerState();
}

class _HScrollerState extends State<HScroller> {
  final _ctrl = ScrollController();
  bool _hover = false;

  void _scroll(double delta) {
    final target = (_ctrl.offset + delta).clamp(0.0, _ctrl.position.maxScrollExtent);
    _ctrl.animateTo(target, duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktop(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: SizedBox(
        height: widget.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ListView.separated(
              controller: _ctrl,
              scrollDirection: Axis.horizontal,
              padding: widget.padding,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.itemCount,
              separatorBuilder: (_, _) => SizedBox(width: widget.spacing),
              itemBuilder: widget.itemBuilder,
            ),
            if (desktop) ...[
              _Arrow(left: true, visible: _hover, onTap: () => _scroll(-360)),
              _Arrow(left: false, visible: _hover, onTap: () => _scroll(360)),
            ],
          ],
        ),
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  final bool left;
  final bool visible;
  final VoidCallback onTap;
  const _Arrow({required this.left, required this.visible, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left ? 2 : null,
      right: left ? null : 2,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 160),
        child: Material(
          color: Theme.of(context).cardColor,
          shape: const CircleBorder(),
          elevation: 3,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: visible ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(left ? Icons.chevron_left_rounded : Icons.chevron_right_rounded, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}
