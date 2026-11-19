import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/order.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;
  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final ek = EkekoColors.of(context);
    final stages = OrderStage.values;
    final currentIndex = stages.indexOf(order.stage);

    return Scaffold(
      appBar: AppBar(title: const Text('Seguimiento del pedido')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Resumen
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: AppColors.heroGradient, borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.receipt_long_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Pedido ${order.code}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(20)),
                    child: Text(order.stage.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                ]),
                const SizedBox(height: 10),
                Text(order.businessName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                Text('Total: Bs ${order.total.toStringAsFixed(order.total % 1 == 0 ? 0 : 2)}',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.95))),
                Text(order.deliveryMode == 'encuentro'
                    ? 'Entrega en punto de encuentro: ${order.meetingPointName ?? '-'}'
                    : 'Envío a domicilio',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12.5)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Línea de tiempo del envío
          const Text('Ruta del envío', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 12),
          ...List.generate(stages.length, (i) {
            final done = i <= currentIndex;
            final isCurrent = i == currentIndex;
            return _TimelineRow(
              stage: stages[i],
              done: done,
              isCurrent: isCurrent,
              isLast: i == stages.length - 1,
            );
          }),

          const SizedBox(height: 20),

          // QR de verificación de entrega
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(18), border: Border.all(color: ek.border)),
            child: Column(children: [
              const Text('QR de entrega', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              const SizedBox(height: 4),
              Text('Muestra este código al recibir. El vendedor lo escanea para confirmar la entrega.',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: ek.muted)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                child: QrImageView(
                  data: order.qrPayload,
                  size: 180,
                  eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.primaryDark),
                  dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AppColors.primaryDark),
                ),
              ),
              const SizedBox(height: 10),
              Text('Código: ${order.code}', style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1)),
              if (order.isDelivered) ...[
                const SizedBox(height: 10),
                const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.verified_rounded, color: AppColors.success),
                  SizedBox(width: 6),
                  Text('Entrega confirmada', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w800)),
                ]),
              ],
            ]),
          ),

          const SizedBox(height: 18),
          if (!order.isDelivered)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => app.advanceOrder(order),
                icon: const Icon(Icons.fast_forward_rounded, size: 18),
                label: const Text('Simular avance del envío'),
              ),
            ),
          const SizedBox(height: 8),
          Center(child: Text('Demo: el estado avanza manualmente mientras no haya backend.', style: TextStyle(fontSize: 11, color: ek.muted))),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final OrderStage stage;
  final bool done;
  final bool isCurrent;
  final bool isLast;
  const _TimelineRow({required this.stage, required this.done, required this.isCurrent, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final ek = EkekoColors.of(context);
    final color = done ? AppColors.accent : ek.muted;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                  color: done ? AppColors.accent : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: done ? const Icon(Icons.check_rounded, size: 15, color: Colors.white) : null,
              ),
              if (!isLast)
                Expanded(child: Container(width: 2.4, color: done ? AppColors.accent : ek.border)),
            ],
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stage.label, style: TextStyle(fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w700, fontSize: 14, color: done ? null : ek.muted)),
                Text(stage.hint, style: TextStyle(fontSize: 11.5, color: ek.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
