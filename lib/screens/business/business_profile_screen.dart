import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:provider/provider.dart';
import '../../models/business.dart';
import '../../models/review.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons.dart';
import '../../widgets/link_actions.dart';
import '../../widgets/plan_badge.dart';
import '../../widgets/product_card.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/section_title.dart';
import '../../widgets/trust_badges.dart';
import '../chat/chat_screen.dart';

class BusinessProfileScreen extends StatelessWidget {
  final Business business;
  const BusinessProfileScreen({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    // Relee el negocio por si cambió (reseñas, QR, etc.).
    final b = appState.byId(business.id) ?? business;
    final isFav = appState.isFavorite(b.id);
    final following = appState.isFollowing(b.id);
    final ek = EkekoColors.of(context);
    final dist = appState.distanceKm(b);
    final featured = b.products.where((p) => p.isFeatured).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 196,
            backgroundColor: b.color,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: _Cover(business: b),
            ),
            actions: [
              IconButton(
                onPressed: () => appState.toggleFavorite(b.id),
                icon: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: Colors.white),
              ),
              IconButton(
                tooltip: 'Compartir vitrina',
                onPressed: () {
                  final url = Uri.base.replace(path: '/tienda/${b.slug}', query: null, fragment: '').toString();
                  Clipboard.setData(ClipboardData(text: url));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Link copiado: $url'), duration: const Duration(seconds: 4)),
                  );
                },
                icon: const Icon(Icons.share_rounded, color: Colors.white),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Flexible(child: Text(b.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))),
                              if (b.isVerified) ...[const SizedBox(width: 6), const Icon(Icons.verified_rounded, color: AppColors.success, size: 20)],
                            ]),
                            const SizedBox(height: 3),
                            Text('${b.category}${b.serviceType != null ? ' · ${b.serviceType}' : ''} · ${b.zone}, ${b.city}',
                                style: TextStyle(color: ek.muted, fontSize: 13)),
                          ],
                        ),
                      ),
                      PlanBadge(plan: b.plan),
                    ],
                  ),
                  if (b.tagline != null) ...[
                    const SizedBox(height: 8),
                    Text('“${b.tagline}”', style: TextStyle(fontSize: 14.5, fontStyle: FontStyle.italic, color: ek.muted)),
                  ],
                  const SizedBox(height: 10),
                  RatingStars(rating: b.rating, reviewCount: b.reviewCount, size: 16),
                  const SizedBox(height: 12),
                  TrustBadges(business: b),
                  const SizedBox(height: 14),
                  Text(b.description, style: const TextStyle(fontSize: 13.5, height: 1.5)),
                  const SizedBox(height: 16),

                  // Redes sociales (optimizado para ventas)
                  _SocialRow(business: b),
                  const SizedBox(height: 14),

                  // CTA principales
                  Row(children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          appState.sendMessage(b.id, '¡Hola! Me interesa lo que vendes.');
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen(business: b)));
                        },
                        icon: const Icon(Icons.forum_rounded, size: 19),
                        label: const Text('Chatear'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => LinkActions.openWhatsApp(context, b.links.whatsappPhone,
                            message: 'Hola ${b.name}, vi tu vitrina en EKEKO y quisiera más información 😊'),
                        icon: const Icon(Icons.chat_rounded, size: 19),
                        label: const Text('WhatsApp'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => appState.toggleFollow(b.id),
                    icon: Icon(following ? Icons.check_rounded : Icons.add_rounded, size: 18),
                    label: Text(following ? 'Siguiendo esta tienda' : 'Seguir tienda'),
                  ),

                  // QR de pago
                  if (b.qrImage != null) ...[
                    const SizedBox(height: 18),
                    _QrCard(business: b),
                  ],

                  // Ubicación / cómo llegar
                  const SizedBox(height: 18),
                  _LocationCard(business: b, distanceKm: dist),

                  const SizedBox(height: 10),
                  if (featured.isNotEmpty) ...[
                    SectionTitle(title: 'Destacados'),
                    SizedBox(
                      height: 210,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: featured.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) => SizedBox(
                          width: 150,
                          child: ProductCard(
                            product: featured[i], color: b.color, category: b.category,
                            onTap: () => Navigator.of(context).pushNamed('/producto/${featured[i].id}'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  SectionTitle(title: 'Catálogo (${b.products.length})'),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.74),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final product = b.products[i];
                  return ProductCard(
                    product: product, color: b.color, category: b.category,
                    onTap: () => Navigator.of(context).pushNamed('/producto/${product.id}'),
                  );
                },
                childCount: b.products.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 8),
              child: SectionTitle(
                title: 'Reseñas (${b.reviews.length})',
                trailing: TextButton.icon(
                  onPressed: () => _showAddReview(context, b.id),
                  icon: const Icon(Icons.rate_review_outlined, size: 18),
                  label: const Text('Escribir'),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemCount: b.reviews.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final r = b.reviews[i];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ek.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(r.authorName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified_rounded, size: 13, color: AppColors.success),
                        const Spacer(),
                        RatingStars(rating: r.rating, size: 13),
                      ]),
                      const SizedBox(height: 4),
                      Text(r.comment, style: const TextStyle(fontSize: 12.5)),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: ek.bgAlt, borderRadius: BorderRadius.circular(14), border: Border.all(color: ek.border)),
                child: Row(children: [
                  const Icon(Icons.shield_outlined, color: AppColors.success),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Compra segura: usa puntos de encuentro públicos y pide ver el producto antes de pagar.',
                      style: TextStyle(fontSize: 12, color: ek.muted))),
                ]),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
        ],
      ),
    );
  }

  void _showAddReview(BuildContext context, String businessId) {
    final ctrl = TextEditingController();
    double rating = 5;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: StatefulBuilder(
          builder: (ctx, setS) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Escribir reseña', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                children: List.generate(5, (i) => IconButton(
                  onPressed: () => setS(() => rating = i + 1.0),
                  icon: Icon(i < rating ? Icons.star_rounded : Icons.star_border_rounded, color: const Color(0xFFE0A52B), size: 30),
                )),
              ),
              TextField(controller: ctrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Cuéntanos tu experiencia…')),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (ctrl.text.trim().isEmpty) return;
                    ctx.read<AppState>().addReview(
                          businessId,
                          Review(
                            id: 'r${DateTime.now().millisecondsSinceEpoch}',
                            authorName: 'Tú',
                            rating: rating,
                            comment: ctrl.text.trim(),
                            daysAgo: 0,
                          ),
                        );
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Gracias por tu reseña!')));
                  },
                  child: const Text('Publicar reseña'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final Business business;
  const _Cover({required this.business});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.coverGradient(business.color)),
      child: Stack(
        children: [
          if (business.coverStyle == 1)
            Positioned.fill(child: CustomPaint(painter: _DotsPainter()))
          else if (business.coverStyle == 2)
            Positioned(right: -30, top: -30, child: Icon(AppIcons.forBusiness(business.category, serviceType: business.serviceType), size: 220, color: Colors.white.withValues(alpha: 0.12))),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: 68, height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                ),
                alignment: Alignment.center,
                child: Icon(AppIcons.forBusiness(business.category, serviceType: business.serviceType), color: Colors.white, size: 34),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.10);
    for (double y = 10; y < size.height; y += 26) {
      for (double x = 10; x < size.width; x += 26) {
        canvas.drawCircle(Offset(x, y), 3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SocialRow extends StatelessWidget {
  final Business business;
  const _SocialRow({required this.business});

  @override
  Widget build(BuildContext context) {
    final L = business.links;
    final items = <Widget>[];
    void add(IconData icon, String label, Color color, VoidCallback onTap) {
      items.add(_SocialButton(icon: icon, label: label, color: color, onTap: onTap));
    }
    add(Icons.chat_rounded, 'WhatsApp', AppColors.success, () => LinkActions.openWhatsApp(context, L.whatsappPhone));
    if (L.instagram != null) add(Icons.camera_alt_rounded, 'Instagram', const Color(0xFFC13584), () => LinkActions.openInstagram(context, L.instagram!));
    if (L.tiktok != null) add(Icons.music_note_rounded, 'TikTok', Colors.black87, () => LinkActions.openTiktok(context, L.tiktok!));
    if (L.facebook != null) add(Icons.facebook_rounded, 'Facebook', const Color(0xFF1877F2), () => LinkActions.openFacebook(context, L.facebook!));
    if (L.website != null) add(Icons.language_rounded, 'Web', AppColors.info, () => LinkActions.openWebsite(context, L.website!));
    return Wrap(spacing: 10, runSpacing: 10, children: items);
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _SocialButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 7),
          Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: color)),
        ]),
      ),
    );
  }
}

class _QrCard extends StatelessWidget {
  final Business business;
  const _QrCard({required this.business});

  @override
  Widget build(BuildContext context) {
    final ek = EkekoColors.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ek.border)),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(business.qrImage!, width: 96, height: 96, fit: BoxFit.cover),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [
                Icon(Icons.qr_code_2_rounded, color: AppColors.primary),
                SizedBox(width: 6),
                Text('Paga por QR', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              ]),
              const SizedBox(height: 4),
              Text('Escanea este QR desde tu app bancaria o billetera para pagar a ${business.name}.',
                  style: TextStyle(fontSize: 12, color: ek.muted)),
            ],
          ),
        ),
      ]),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final Business business;
  final double? distanceKm;
  const _LocationCard({required this.business, required this.distanceKm});

  @override
  Widget build(BuildContext context) {
    final ek = EkekoColors.of(context);
    final query = business.links.mapsQuery ?? '${business.zone}, ${business.city}, Bolivia';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: ek.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.place_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(child: Text('${business.zone}, ${business.city}', style: const TextStyle(fontWeight: FontWeight.w700))),
            if (distanceKm != null)
              Text('${distanceKm!.toStringAsFixed(distanceKm! < 10 ? 1 : 0)} km', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => LinkActions.openMaps(context, query),
              icon: const Icon(Icons.directions_rounded, size: 18),
              label: const Text('Cómo llegar'),
            ),
          ),
        ],
      ),
    );
  }
}
