import 'package:flutter/material.dart';
import '../models/business.dart';
import '../theme/app_theme.dart';

class Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const Badge({super.key, required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
      ]),
    );
  }
}

class TrustBadges extends StatelessWidget {
  final Business business;
  final bool compact;
  const TrustBadges({super.key, required this.business, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final b = business;
    final chips = <Widget>[];
    if (b.official) chips.add(const Badge(icon: Icons.verified_user_rounded, label: 'Oficial', color: AppColors.primary));
    if (b.isVerified) chips.add(const Badge(icon: Icons.verified_rounded, label: 'Verificado', color: AppColors.success));
    if (b.respondsFast) chips.add(const Badge(icon: Icons.bolt_rounded, label: 'Responde <1h', color: AppColors.warning));
    if (b.shipsNationwide) chips.add(const Badge(icon: Icons.local_shipping_rounded, label: 'Envíos a Bolivia', color: AppColors.info));
    if (!compact && b.salesCount >= 50) {
      chips.add(const Badge(icon: Icons.military_tech_rounded, label: '+50 ventas', color: AppColors.accentDark));
    }
    return Wrap(spacing: 6, runSpacing: 6, children: chips);
  }
}
