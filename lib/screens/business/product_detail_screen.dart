import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:provider/provider.dart';
import '../../models/business.dart';
import '../../models/product.dart';
import '../../models/order.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons.dart';
import '../../widgets/avatar_blob.dart';
import '../../widgets/link_actions.dart';
import '../chat/chat_screen.dart';
import '../orders/order_tracking_screen.dart';
import '../orders/meeting_points_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final Business business;

  const ProductDetailScreen({super.key, required this.product, required this.business});

  @override
  Widget build(BuildContext context) {
    final ek = EkekoColors.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(business.name),
        actions: [
          IconButton(
            tooltip: 'Compartir producto',
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              final url = Uri.base.replace(path: '/producto/${product.id}', query: null, fragment: '').toString();
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Link copiado: $url'), duration: const Duration(seconds: 4)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoverBlob(
              icon: AppIcons.forProduct(product.name, business.category),
              color: business.color,
              height: 220,
              image: product.image != null ? MemoryImage(product.image!) : null,
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(product.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900))),
                if (product.isFeatured)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(20)),
                    child: const Text('Destacado', style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(product.price == 0 ? 'Consultar precio' : product.formattedPrice,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary)),
            const SizedBox(height: 4),
            Row(children: [
              Icon(product.inStock ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  size: 16, color: product.inStock ? AppColors.success : AppColors.danger),
              const SizedBox(width: 4),
              Text(product.inStock ? 'Disponible' : 'Agotado', style: TextStyle(fontSize: 12.5, color: ek.muted)),
            ]),
            const SizedBox(height: 16),
            const Text('Descripción', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 6),
            Text(product.description, style: const TextStyle(fontSize: 13.5, height: 1.5)),
            if (product.variants.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Opciones disponibles', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: product.variants.map((v) => Chip(label: Text(v))).toList()),
            ],
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: ek.bgAlt, borderRadius: BorderRadius.circular(14), border: Border.all(color: ek.border)),
              child: Row(children: [
                AvatarBlob(icon: AppIcons.forBusiness(business.category, serviceType: business.serviceType), color: business.color, size: 40),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(business.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                    Text('Vendido y entregado por el negocio', style: TextStyle(fontSize: 11, color: ek.muted)),
                  ],
                )),
                if (business.isVerified) const Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
              ]),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: () {
                  context.read<AppState>().sendMessage(business.id, 'Hola, me interesa "${product.name}".');
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen(business: business)));
                },
                icon: const Icon(Icons.forum_rounded, size: 18),
                label: const Text('Chatear'),
              )),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(
                onPressed: () => LinkActions.openWhatsApp(context, business.links.whatsappPhone,
                    message: 'Hola ${business.name}, me interesa "${product.name}" (${product.formattedPrice}) que vi en EKEKO.'),
                icon: const Icon(Icons.chat_rounded, size: 18, color: AppColors.success),
                label: const Text('WhatsApp'),
              )),
            ]),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: product.inStock ? () => _startOrder(context) : null,
                icon: const Icon(Icons.shopping_bag_rounded, size: 19),
                label: Text(product.inStock ? 'Hacer pedido y seguir envío' : 'Producto agotado'),
              ),
            ),
            const SizedBox(height: 8),
            Center(child: Text('EKEKO conecta comprador y vendedor; el pago se coordina directamente.',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 10.5, color: ek.muted))),
          ],
        ),
      ),
    );
  }

  void _startOrder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.all(16), child: Text('¿Cómo quieres recibirlo?', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
            ListTile(
              leading: const Icon(Icons.local_shipping_rounded, color: AppColors.primary),
              title: const Text('Envío a domicilio'),
              subtitle: const Text('Sigue la ruta de tu envío en la app'),
              onTap: () { Navigator.pop(ctx); _create(context, 'envio', null); },
            ),
            ListTile(
              leading: const Icon(Icons.handshake_rounded, color: AppColors.accent),
              title: const Text('Punto de encuentro seguro'),
              subtitle: const Text('Elige un lugar público para encontrarte'),
              onTap: () async {
                Navigator.pop(ctx);
                final point = await Navigator.of(context).push<String>(
                  MaterialPageRoute(builder: (_) => const MeetingPointsScreen(selecting: true)),
                );
                if (point != null && context.mounted) _create(context, 'encuentro', point);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _create(BuildContext context, String mode, String? point) {
    final app = context.read<AppState>();
    final order = app.createOrder(
      business: business,
      items: [OrderItem(productName: product.name, price: product.price)],
      buyerName: 'Tú',
      deliveryMode: mode,
      meetingPointName: point,
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order)));
  }
}
