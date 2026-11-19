import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/business.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/business_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _queryCtrl = TextEditingController();
  String _query = '';
  String? _category;
  String? _department;
  bool _onlyVerified = false;

  List<Business> _filter(List<Business> all) {
    final q = _query.toLowerCase();
    return all.where((b) {
      final matchesQuery = q.isEmpty ||
          b.name.toLowerCase().contains(q) ||
          b.category.toLowerCase().contains(q) ||
          (b.serviceType?.toLowerCase().contains(q) ?? false) ||
          b.products.any((p) => p.name.toLowerCase().contains(q));
      final matchesCategory = _category == null || b.category == _category;
      final matchesDept = _department == null || b.department == _department;
      final matchesVerified = !_onlyVerified || b.isVerified;
      return matchesQuery && matchesCategory && matchesDept && matchesVerified;
    }).toList();
  }

  bool get _hasFilters => _category != null || _department != null || _onlyVerified;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final results = _filter(appState.businesses);

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar'), automaticallyImplyLeading: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _queryCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Busca un producto, negocio o servicio…',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isEmpty ? null : IconButton(icon: const Icon(Icons.close_rounded), onPressed: () { _queryCtrl.clear(); setState(() => _query = ''); }),
              ),
            ),
          ),
          SizedBox(
            height: 38,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                FilterChip(label: const Text('Verificados'), selected: _onlyVerified, avatar: _onlyVerified ? null : const Icon(Icons.verified_outlined, size: 16), onSelected: (v) => setState(() => _onlyVerified = v)),
                const SizedBox(width: 8),
                _FilterMenu(label: _category ?? 'Categoría', active: _category != null, options: kCategories, onSelected: (v) => setState(() => _category = v), onClear: () => setState(() => _category = null)),
                const SizedBox(width: 8),
                _FilterMenu(label: _department ?? 'Departamento', active: _department != null, options: kDepartments, onSelected: (v) => setState(() => _department = v), onClear: () => setState(() => _department = null)),
                if (_hasFilters) ...[
                  const SizedBox(width: 8),
                  TextButton(onPressed: () => setState(() { _category = null; _department = null; _onlyVerified = false; }), child: const Text('Limpiar')),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: results.isEmpty
                ? _EmptyState(query: _query)
                : Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 820),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: results.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, i) => BusinessCard(
                          business: results[i],
                          onTap: () => Navigator.of(context).pushNamed('/tienda/${results[i].slug}'),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterMenu extends StatelessWidget {
  final String label;
  final bool active;
  final List<String> options;
  final ValueChanged<String> onSelected;
  final VoidCallback onClear;

  const _FilterMenu({required this.label, required this.active, required this.options, required this.onSelected, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final ek = EkekoColors.of(context);
    return PopupMenuButton<String>(
      onSelected: (v) => v == '__clear__' ? onClear() : onSelected(v),
      itemBuilder: (context) => [
        if (active) const PopupMenuItem(value: '__clear__', child: Text('Quitar filtro')),
        ...options.map((o) => PopupMenuItem(value: o, child: Text(o))),
      ],
      child: Chip(
        label: Text(label),
        avatar: Icon(Icons.expand_more_rounded, size: 16, color: active ? Colors.white : null),
        backgroundColor: active ? AppColors.primary : ek.bgAlt,
        labelStyle: TextStyle(color: active ? Colors.white : null, fontSize: 12.5),
        side: BorderSide(color: active ? AppColors.primary : ek.border),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    final ek = EkekoColors.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.search_off_rounded, size: 52, color: ek.muted),
          const SizedBox(height: 12),
          Text(query.isEmpty ? 'Ajusta los filtros para ver resultados' : 'No encontramos resultados para "$query"',
              textAlign: TextAlign.center, style: TextStyle(color: ek.muted)),
        ]),
      ),
    );
  }
}
