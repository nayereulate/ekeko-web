import 'package:flutter/material.dart';

/// Avatar con icono de marca sobre un gradiente de color (sin emojis).
class AvatarBlob extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const AvatarBlob({super.key, required this.icon, required this.color, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(color, Colors.white, 0.12)!, Color.lerp(color, Colors.black, 0.28)!],
        ),
        borderRadius: BorderRadius.circular(size * 0.30),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: size * 0.5),
    );
  }
}

/// Portada rectangular con icono (o foto) sobre gradiente.
class CoverBlob extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double height;
  final BorderRadius? borderRadius;
  final ImageProvider? image;

  const CoverBlob({
    super.key,
    required this.icon,
    required this.color,
    this.height = 120,
    this.borderRadius,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(14);
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.lerp(color, Colors.white, 0.22)!, color, Color.lerp(color, Colors.black, 0.30)!],
          ),
          image: image != null ? DecorationImage(image: image!, fit: BoxFit.cover) : null,
        ),
        alignment: Alignment.center,
        child: image != null
            ? null
            : Icon(icon, color: Colors.white.withValues(alpha: 0.92), size: height * 0.4),
      ),
    );
  }
}
