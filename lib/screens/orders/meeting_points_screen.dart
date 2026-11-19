import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/order.dart';
import '../../theme/app_theme.dart';
import '../../widgets/link_actions.dart';

class MeetingPointsScreen extends StatefulWidget {
  /// Si se usa para elegir un punto, devuelve el nombre al hacer pop.
  final bool selecting;
  const MeetingPointsScreen({super.key, this.selecting = false});

  @override
  State<MeetingPointsScreen> createState() => _MeetingPointsScreenState();
}

class _MeetingPointsScreenState extends State<MeetingPointsScreen> {
  String _department = kDepartments.first;

  @override
  Widget build(BuildContext context) {
    final ek = EkekoColors.of(context);
    final points = meetingPointsFor(_department);

    return Scaffold(
      appBar: AppBar(title: Text(widget.selecting ? 'Elegir punto de encuentro' : 'Puntos de encuentro seguros')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: ek.bgAlt, borderRadius: BorderRadius.circular(14), border: Border.all(color: ek.border)),
              child: Row(children: [
                const Icon(Icons.shield_outlined, color: AppColors.success),
                const SizedBox(width: 10),
                Expanded(child: Text('Reúnete en lugares públicos y concurridos. Nunca compartas tu dirección exacta con desconocidos.',
                    style: TextStyle(fontSize: 12.5, color: ek.muted))),
              ]),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: kDepartments.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final d = kDepartments[i];
                return ChoiceChip(label: Text(d), selected: d == _department, onSelected: (_) => setState(() => _department = d));
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: points.isEmpty
                ? Center(child: Text('Sin puntos sugeridos en $_department todavía.', style: TextStyle(color: ek.muted)))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: points.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _PointCard(point: points[i], selecting: widget.selecting),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PointCard extends StatelessWidget {
  final MeetingPoint point;
  final bool selecting;
  const _PointCard({required this.point, required this.selecting});

  @override
  Widget build(BuildContext context) {
    final ek = EkekoColors.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ek.border)),
      child: Row(children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(13)),
          child: const Icon(Icons.location_on_rounded, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(point.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5)),
            Text('${point.city} · ${point.note}', style: TextStyle(fontSize: 12, color: ek.muted)),
          ],
        )),
        const SizedBox(width: 8),
        selecting
            ? FilledButton(onPressed: () => Navigator.of(context).pop(point.name), child: const Text('Elegir'))
            : IconButton(
                tooltip: 'Cómo llegar',
                onPressed: () => LinkActions.openMaps(context, '${point.name}, ${point.city}, Bolivia'),
                icon: const Icon(Icons.directions_rounded, color: AppColors.primary),
              ),
      ]),
    );
  }
}
