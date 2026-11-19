import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/business.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons.dart';
import '../../widgets/avatar_blob.dart';
import '../../widgets/business_card.dart';
import '../../widgets/h_scroller.dart';
import '../../widgets/hover_lift.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/responsive.dart';
import '../../widgets/section_title.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String? _department;
  String? _category;
  String _query = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final width = MediaQuery.of(context).size.width;
    final gutter = math.max(16.0, (width - kContentMaxWidth) / 2);
    final cols = gridColumnsFor(width);
    final q = _query.toLowerCase().trim();

    var list = appState.businesses.where((b) {
      if (_department != null && b.department != _department) return false;
      if (_category != null && b.category != _category) return false;
      if (q.isNotEmpty) {
        final hit = b.name.toLowerCase().contains(q) ||
            b.category.toLowerCase().contains(q) ||
            (b.serviceType?.toLowerCase().contains(q) ?? false) ||
            b.products.any((p) => p.name.toLowerCase().contains(q));
        if (!hit) return false;
      }
      return true;
    }).toList();

    final hasLoc = appState.userLat != null;
    if (hasLoc) {
      list.sort((a, b) => (appState.distanceKm(a) ?? 1e9).compareTo(appState.distanceKm(b) ?? 1e9));
    }

    final verified = appState.businesses.where((b) => b.isVerified).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final feature = (hasLoc ? list : verified).take(10).toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _Header(
                gutter: gutter,
                department: _department,
                onDepartment: (d) => setState(() => _department = d),
                searchController: _searchCtrl,
                query: _query,
                onQuery: (v) => setState(() => _query = v),
                businessCount: appState.businesses.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, 16, gutter, 0),
                child: SectionTitle(title: 'Categorías'),
              ),
            ),
            SliverToBoxAdapter(
              child: FadeInUp(child: _CategoryRow(gutter: gutter, selected: _category, onSelect: (c) => setState(() => _category = c))),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, 22, gutter, 4),
                child: SectionTitle(title: hasLoc ? 'Cerca de ti' : 'Destacados de la semana'),
              ),
            ),
            SliverToBoxAdapter(
              child: FadeInUp(
                child: HScroller(
                  height: 188,
                  padding: EdgeInsets.symmetric(horizontal: gutter),
                  itemCount: feature.length,
                  itemBuilder: (context, i) => _FeaturedCard(business: feature[i]),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, 24, gutter, 10),
                child: SectionTitle(
                  title: _category ?? 'Todos los negocios',
                  trailing: (_category != null || _department != null)
                      ? TextButton(onPressed: () => setState(() { _category = null; _department = null; }), child: const Text('Limpiar'))
                      : null,
                ),
              ),
            ),
            if (list.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(44),
                  child: Center(
                    child: Column(children: [
                      Container(
                        width: 84, height: 84,
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), shape: BoxShape.circle),
                        child: const Icon(Icons.storefront_outlined, size: 40, color: AppColors.primary),
                      ),
                      const SizedBox(height: 14),
                      const Text('Nada por aquí todavía', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Prueba con otra categoría, departamento o búsqueda.',
                          textAlign: TextAlign.center, style: TextStyle(color: EkekoColors.of(context).muted)),
                    ]),
                  ),
                ),
              ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 4),
              sliver: cols == 1
                  ? SliverList.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _tappable(context, list[i]),
                    )
                  : SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols, mainAxisSpacing: 14, crossAxisSpacing: 14, mainAxisExtent: 250),
                      delegate: SliverChildBuilderDelegate((context, i) => _tappable(context, list[i]), childCount: list.length),
                    ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],
        ),
      ),
    );
  }

  Widget _tappable(BuildContext context, Business b) => BusinessCard(
        business: b,
        onTap: () => Navigator.of(context).pushNamed('/tienda/${b.slug}'),
      );
}

class _Header extends StatelessWidget {
  final double gutter;
  final String? department;
  final ValueChanged<String?> onDepartment;
  final TextEditingController searchController;
  final String query;
  final ValueChanged<String> onQuery;
  final int businessCount;
  const _Header({
    required this.gutter,
    required this.department,
    required this.onDepartment,
    required this.searchController,
    required this.query,
    required this.onQuery,
    required this.businessCount,
  });

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final desktop = isDesktop(context);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      child: Container(
        padding: EdgeInsets.fromLTRB(gutter, 14, gutter, desktop ? 34 : 24),
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Stack(
          children: [
            // Círculos decorativos
            Positioned(right: -40, top: -50, child: _circle(150, 0.10)),
            Positioned(right: 60, bottom: -70, child: _circle(120, 0.08)),
            Positioned(left: -30, bottom: -40, child: _circle(90, 0.06)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.storefront_rounded, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    const Text('EKEKO', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                    const Spacer(),
                    IconButton(
                      tooltip: app.locating ? 'Buscando ubicación…' : 'Usar mi ubicación',
                      onPressed: app.locating ? null : () async {
                        final appState = context.read<AppState>();
                        final messenger = ScaffoldMessenger.of(context);
                        await appState.fetchLocation();
                        final err = appState.locationError;
                        if (err != null) messenger.showSnackBar(SnackBar(content: Text(err)));
                      },
                      icon: app.locating
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2))
                          : Icon(app.userLat != null ? Icons.my_location_rounded : Icons.location_searching_rounded, color: Colors.white),
                    ),
                    IconButton(
                      tooltip: 'Tema claro/oscuro',
                      onPressed: () => context.read<AppState>().toggleTheme(),
                      icon: Icon(app.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: desktop ? 22 : 12),
                Text('Todo lo boliviano,\nen un solo lugar.',
                    style: TextStyle(color: Colors.white, fontSize: desktop ? 34 : 26, fontWeight: FontWeight.w800, height: 1.15, letterSpacing: -0.5)),
                const SizedBox(height: 6),
                Text('Productos, tiendas y servicios cerca de ti.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14.5, fontWeight: FontWeight.w500)),
                const SizedBox(height: 18),
                // Buscador grande
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Material(
                    elevation: 8,
                    shadowColor: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(16),
                    child: TextField(
                      controller: searchController,
                      onChanged: onQuery,
                      decoration: InputDecoration(
                        hintText: 'Busca "chompa", "gimnasio", "plomería"…',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: query.isEmpty ? null : IconButton(icon: const Icon(Icons.close_rounded), onPressed: () { searchController.clear(); onQuery(''); }),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Stats de confianza
                Wrap(spacing: 8, runSpacing: 8, children: [
                  _Stat(icon: Icons.storefront_rounded, text: '$businessCount negocios'),
                  const _Stat(icon: Icons.public_rounded, text: '9 departamentos'),
                  const _Stat(icon: Icons.qr_code_2_rounded, text: 'Pago por QR'),
                  const _Stat(icon: Icons.verified_rounded, text: 'Vendedores verificados'),
                ]),
                const SizedBox(height: 16),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _Chip(label: 'Todo Bolivia', selected: department == null, onTap: () => onDepartment(null)),
                      ...kDepartments.map((d) => _Chip(label: d, selected: department == d, onTap: () => onDepartment(d))),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(double size, double opacity) => Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: opacity)),
      );
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Stat({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white, size: 15),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected ? Colors.white : Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: selected ? 0 : 0.55)),
            ),
            alignment: Alignment.center,
            child: Text(label, style: TextStyle(color: selected ? AppColors.primary : Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
          ),
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final double gutter;
  final String? selected;
  final ValueChanged<String?> onSelect;
  const _CategoryRow({required this.gutter, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return HScroller(
      height: 98,
      padding: EdgeInsets.symmetric(horizontal: gutter),
      itemCount: kCategories.length,
      itemBuilder: (context, i) {
        final cat = kCategories[i];
        final isSel = selected == cat;
        final color = AppColors.forSeed(i);
        return InkWell(
          onTap: () => onSelect(isSel ? null : cat),
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 80,
            child: Column(
              children: [
                HoverLift(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: 62, height: 62,
                    decoration: BoxDecoration(
                      gradient: AppColors.coverGradient(color),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
                      border: isSel ? Border.all(color: AppColors.primary, width: 2.5) : null,
                    ),
                    alignment: Alignment.center,
                    child: Icon(AppIcons.forCategory(cat), color: Colors.white, size: 27),
                  ),
                ),
                const SizedBox(height: 6),
                Text(cat, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, fontWeight: isSel ? FontWeight.w800 : FontWeight.w600)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Business business;
  const _FeaturedCard({required this.business});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final dist = app.distanceKm(business);
    final ek = EkekoColors.of(context);
    return SizedBox(
      width: 162,
      child: HoverLift(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).pushNamed('/tienda/${business.slug}'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: ek.border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    AvatarBlob(icon: AppIcons.forBusiness(business.category, serviceType: business.serviceType), color: business.color, size: 42),
                    const Spacer(),
                    if (business.isVerified) const Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
                  ]),
                  const SizedBox(height: 8),
                  Text(business.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(dist != null ? '${business.city} · ${dist.toStringAsFixed(dist < 10 ? 1 : 0)} km' : business.city,
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: ek.muted)),
                  const Spacer(),
                  RatingStars(rating: business.rating, size: 12, reviewCount: business.reviewCount),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
