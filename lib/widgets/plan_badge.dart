import 'package:flutter/material.dart';
import '../models/business.dart';

class PlanBadge extends StatelessWidget {
  final BusinessPlan plan;
  const PlanBadge({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: plan.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        plan.label,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Tooltip(
      message: 'Negocio Verificado',
      child: Icon(Icons.verified_rounded, color: Color(0xFF2F7D5C), size: 18),
    );
  }
}
