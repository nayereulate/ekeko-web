import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final ek = EkekoColors.of(context);
    final orders = app.orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis pedidos'), automaticallyImplyLeading: false),
      body: orders.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 84, height: 84,
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), shape: BoxShape.circle),
                    child: const Icon(Icons.receipt_long_rounded, size: 40, color: AppColors.primary),
                  ),
                  const SizedBox(height: 14),
                  const Text('Aún no tienes pedidos', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text('Cuando hagas un pedido podrás seguir su envío aquí.',
                      textAlign: TextAlign.center, style: TextStyle(color: ek.muted)),
                ]),
              ),
            )
          : Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final o = orders[i];
                final idx = OrderStage.values.indexOf(o.stage);
                final progress = (idx + 1) / OrderStage.values.length;
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: o))),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ek.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(o.code, style: const TextStyle(fontWeight: FontWeight.w900)),
                          const Spacer(),
                          _StageChip(stage: o.stage),
                        ]),
                        const SizedBox(height: 4),
                        Text(o.businessName, style: TextStyle(color: ek.muted, fontSize: 13)),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(value: progress, minHeight: 6, color: AppColors.accent, backgroundColor: ek.border),
                        ),
                        const SizedBox(height: 8),
                        Row(children: [
                          Text('Bs ${o.total.toStringAsFixed(o.total % 1 == 0 ? 0 : 2)}', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                          const Spacer(),
                          Text('Ver seguimiento →', style: TextStyle(color: AppColors.primary, fontSize: 12.5, fontWeight: FontWeight.w700)),
                        ]),
                      ],
                    ),
                  ),
                );
              },
            ),
              ),
            ),
    );
  }
}

class _StageChip extends StatelessWidget {
  final OrderStage stage;
  const _StageChip({required this.stage});

  @override
  Widget build(BuildContext context) {
    final delivered = stage == OrderStage.delivered;
    final color = delivered ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
      child: Text(stage.label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11.5)),
    );
  }
}
