import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons.dart';
import '../../widgets/plan_badge.dart';
import '../../widgets/product_card.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/section_title.dart';
import '../../widgets/stat_tile.dart';
import '../orders/delivery_verify_screen.dart';
import 'add_edit_product_screen.dart';
import 'edit_business_screen.dart';
import 'plans_screen.dart';

const _coverColors = [
  Color(0xFF1667A6), Color(0xFF21A56B), Color(0xFF0E7C86),
  Color(0xFF2E7DB5), Color(0xFF158A5E), Color(0xFF155E75),
  Color(0xFF7A3FB5), Color(0xFFB5471B),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _uploadQr(BuildContext context) async {
    final app = context.read<AppState>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      app.setMyQr(bytes);
      messenger.showSnackBar(const SnackBar(content: Text('QR de pago actualizado.')));
    } catch (_) {
      messenger.showSnackBar(const SnackBar(content: Text('No se pudo cargar la imagen.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final b = appState.myBusiness;
    final ek = EkekoColors.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Negocio'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Ver mi vitrina',
            icon: const Icon(Icons.visibility_outlined),
            onPressed: () => Navigator.of(context).pushNamed('/tienda/${b.slug}'),
          ),
          IconButton(
            tooltip: 'Editar vitrina',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditBusinessScreen(business: b))),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Encabezado
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: AppColors.coverGradient(b.color), borderRadius: BorderRadius.circular(18)),
            child: Row(children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(17), border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2)),
                alignment: Alignment.center,
                child: Icon(AppIcons.forBusiness(b.category, serviceType: b.serviceType), color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.name, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  RatingStars(rating: b.rating, reviewCount: b.reviewCount, size: 13),
                  const SizedBox(height: 8),
                  Row(children: [PlanBadge(plan: b.plan), const SizedBox(width: 8), if (b.isVerified) const Icon(Icons.verified_rounded, color: Colors.white, size: 18)]),
                ],
              )),
            ]),
          ),
          const SizedBox(height: 16),

          // Accesos rápidos
          Row(children: [
            _QuickAction(icon: Icons.qr_code_scanner_rounded, label: 'Verificar\nentrega', color: AppColors.accent,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DeliveryVerifyScreen()))),
            const SizedBox(width: 10),
            _QuickAction(icon: Icons.inventory_2_outlined, label: 'Agregar\nproducto', color: AppColors.primary,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddEditProductScreen()))),
            const SizedBox(width: 10),
            _QuickAction(icon: Icons.workspace_premium_outlined, label: 'Planes', color: AppColors.info,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlansScreen(currentPlan: b.plan)))),
          ]),
          const SizedBox(height: 20),

          // Personalización de la vitrina
          const SectionTitle(title: 'Personaliza tu vitrina'),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ek.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Color de marca', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 10),
                Wrap(spacing: 10, runSpacing: 10, children: _coverColors.map((c) {
                  final sel = c.toARGB32() == b.color.toARGB32();
                  return GestureDetector(
                    onTap: () => appState.updateMyBusinessProfile(color: c),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: c, shape: BoxShape.circle,
                          border: Border.all(color: sel ? (appState.isDark ? Colors.white : Colors.black) : Colors.transparent, width: 2.5)),
                      child: sel ? const Icon(Icons.check_rounded, color: Colors.white, size: 18) : null,
                    ),
                  );
                }).toList()),
                const Divider(height: 24),
                const Text('Estilo de portada', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 10),
                Row(children: List.generate(3, (i) {
                  final sel = b.coverStyle == i;
                  return Expanded(child: Padding(
                    padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                    child: GestureDetector(
                      onTap: () => appState.updateMyBusinessProfile(coverStyle: i),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: AppColors.coverGradient(b.color),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: sel ? AppColors.primary : Colors.transparent, width: 2.5),
                        ),
                        alignment: Alignment.center,
                        child: Text(['Liso', 'Puntos', 'Icono'][i], style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ));
                })),
                const Divider(height: 24),
                Row(children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('QR de pago', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                      Text(b.qrImage == null ? 'Sube tu QR para que te paguen' : 'QR cargado ✓', style: TextStyle(fontSize: 12, color: ek.muted)),
                    ],
                  )),
                  if (b.qrImage != null) ...[
                    ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.memory(b.qrImage!, width: 44, height: 44, fit: BoxFit.cover)),
                    const SizedBox(width: 8),
                  ],
                  OutlinedButton.icon(onPressed: () => _uploadQr(context), icon: const Icon(Icons.upload_rounded, size: 17), label: Text(b.qrImage == null ? 'Subir' : 'Cambiar')),
                ]),
                const Divider(height: 24),
                Row(children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ubicación de la tienda', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                      Text(b.lat != null ? 'Ubicación guardada ✓' : 'Usa tu GPS para ubicar tu tienda', style: TextStyle(fontSize: 12, color: ek.muted)),
                    ],
                  )),
                  OutlinedButton.icon(
                    onPressed: appState.locating ? null : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await appState.useMyLocationForBusiness();
                      final err = appState.locationError;
                      messenger.showSnackBar(SnackBar(content: Text(err ?? 'Ubicación guardada.')));
                    },
                    icon: const Icon(Icons.my_location_rounded, size: 17),
                    label: const Text('Ubicar'),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Estadísticas
          const SectionTitle(title: 'Estadísticas (últimos 30 días)'),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.5,
            children: [
              StatTile(label: 'Visitas al perfil', value: '${b.profileVisits}', icon: Icons.visibility_outlined, color: AppColors.info),
              StatTile(label: 'Contactos', value: '${b.contactsGenerated}', icon: Icons.chat_bubble_outline_rounded, color: AppColors.success),
              StatTile(label: 'Ventas', value: '${b.salesCount}', icon: Icons.sell_outlined, color: AppColors.accent),
              StatTile(label: 'Productos', value: '${b.products.length}', icon: Icons.inventory_2_outlined, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 22),

          // Catálogo editable
          SectionTitle(
            title: 'Mi catálogo (${b.products.length})',
            trailing: TextButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddEditProductScreen())),
              icon: const Icon(Icons.add_rounded, size: 18), label: const Text('Agregar'),
            ),
          ),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.70),
            itemCount: b.products.length,
            itemBuilder: (context, i) {
              final product = b.products[i];
              return Stack(children: [
                ProductCard(product: product, color: b.color, category: b.category,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddEditProductScreen(existing: product)))),
                Positioned(top: 6, right: 6, child: Material(
                  color: Colors.black54, shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _confirmDelete(context, product.id, product.name),
                    child: const Padding(padding: EdgeInsets.all(5), child: Icon(Icons.delete_outline_rounded, color: Colors.white, size: 18)),
                  ),
                )),
              ]);
            },
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              context.read<AppState>().logout();
              Navigator.of(context).popUntil((r) => r.isFirst);
            },
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Cerrar sesión'),
          ),
          const SizedBox(height: 24),
        ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Eliminar "$name" de tu catálogo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () { ctx.read<AppState>().deleteMyProduct(id); Navigator.pop(ctx); },
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ek = EkekoColors.of(context);
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: ek.border)),
          child: Column(children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, height: 1.2)),
          ]),
        ),
      ),
    );
  }
}
