import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/business.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class _PlanInfo {
  final BusinessPlan plan;
  final String price;
  final List<String> features;
  const _PlanInfo(this.plan, this.price, this.features);
}

const _plans = [
  _PlanInfo(BusinessPlan.free, 'Bs 0 /mes', [
    'Perfil básico con enlaces',
    'Hasta 10 productos',
    'Estadísticas básicas',
  ]),
  _PlanInfo(BusinessPlan.plus, 'Bs 30–50 /mes', [
    'Productos ilimitados',
    'Catálogo destacado en su categoría',
    'Estadísticas avanzadas',
    'Insignia "Plus" en el perfil',
  ]),
  _PlanInfo(BusinessPlan.pro, 'Bs 90–150 /mes', [
    'Todo lo de Plus',
    'Posicionamiento prioritario en búsquedas',
    'Múltiples administradores',
    'Cupones y herramientas de marketing',
  ]),
];

class PlansScreen extends StatelessWidget {
  final BusinessPlan currentPlan;
  const PlansScreen({super.key, required this.currentPlan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planes EKEKO')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Elige el plan que más se ajuste al momento de tu negocio. Puedes cambiar cuando quieras.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ..._plans.map((p) => _PlanCard(info: p, isCurrent: p.plan == currentPlan)),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final _PlanInfo info;
  final bool isCurrent;
  const _PlanCard({required this.info, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCurrent ? info.plan.color : EkekoColors.of(context).border, width: isCurrent ? 1.8 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: info.plan.color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(info.plan.label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const Spacer(),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.bgAlt, borderRadius: BorderRadius.circular(20)),
                  child: const Text('Plan actual', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(info.price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
          const SizedBox(height: 12),
          ...info.features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(f, style: const TextStyle(fontSize: 12.5))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: isCurrent
                ? OutlinedButton(onPressed: null, child: const Text('Plan activo'))
                : ElevatedButton(
                    onPressed: () {
                      context.read<AppState>().upgradePlan(info.plan);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cambiaste a ${info.plan.label} (simulado).')),
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: info.plan.color),
                    child: const Text('Elegir este plan'),
                  ),
          ),
        ],
      ),
    );
  }
}
