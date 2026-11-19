import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../models/order.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

/// El vendedor escanea el QR del comprador para confirmar la entrega.
class DeliveryVerifyScreen extends StatefulWidget {
  const DeliveryVerifyScreen({super.key});

  @override
  State<DeliveryVerifyScreen> createState() => _DeliveryVerifyScreenState();
}

class _DeliveryVerifyScreenState extends State<DeliveryVerifyScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false;

  void _process(String? raw) {
    if (_handled || raw == null) return;
    final order = context.read<AppState>().confirmDeliveryByPayload(raw);
    _handled = true;
    _controller.stop();
    _showResult(order);
  }

  void _showResult(Order? order) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(order != null ? Icons.verified_rounded : Icons.error_outline_rounded,
                size: 56, color: order != null ? AppColors.success : AppColors.danger),
            const SizedBox(height: 12),
            Text(order != null ? '¡Entrega confirmada!' : 'QR no reconocido',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 6),
            Text(
              order != null
                  ? 'Pedido ${order.code} de ${order.businessName} marcado como entregado.'
                  : 'No encontramos un pedido con este código. Verifica e intenta de nuevo.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { Navigator.of(ctx).pop(); Navigator.of(context).pop(); },
                child: const Text('Listo'),
              ),
            ),
            TextButton(
              onPressed: () { Navigator.of(ctx).pop(); setState(() => _handled = false); _controller.start(); },
              child: const Text('Escanear otro'),
            ),
          ],
        ),
      ),
    );
  }

  void _manualEntry() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ingresar código'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Ej. EK-1234')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _process('EKEKO|${ctrl.text.trim()}|manual');
            },
            child: const Text('Verificar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar entrega'),
        actions: [IconButton(onPressed: () => _controller.toggleTorch(), icon: const Icon(Icons.flash_on_rounded))],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    if (capture.barcodes.isNotEmpty) _process(capture.barcodes.first.rawValue);
                  },
                  errorBuilder: (context, error) => _ScannerError(onManual: _manualEntry),
                ),
                // Marco guía
                Container(
                  width: 230, height: 230,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Apunta la cámara al QR de entrega del comprador',
                    textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _manualEntry,
                    icon: const Icon(Icons.keyboard_rounded, size: 18),
                    label: const Text('Ingresar código manualmente'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerError extends StatelessWidget {
  final VoidCallback onManual;
  const _ScannerError({required this.onManual});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.no_photography_rounded, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          const Text('No se pudo acceder a la cámara.', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton.icon(onPressed: onManual, icon: const Icon(Icons.keyboard_rounded, size: 18), label: const Text('Ingresar código')),
        ],
      ),
    );
  }
}
