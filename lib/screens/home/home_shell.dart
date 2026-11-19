import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/responsive.dart';
import '../business/explore_screen.dart';
import '../business/search_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../favorites/favorites_screen.dart';
import '../orders/orders_screen.dart';

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(this.icon, this.activeIcon, this.label);
}

const _items = [
  _NavItem(Icons.explore_outlined, Icons.explore_rounded, 'Explorar'),
  _NavItem(Icons.search_outlined, Icons.search_rounded, 'Buscar'),
  _NavItem(Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Pedidos'),
  _NavItem(Icons.favorite_border_rounded, Icons.favorite_rounded, 'Favoritos'),
  _NavItem(Icons.storefront_outlined, Icons.storefront_rounded, 'Mi Negocio'),
];

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  bool _menuExtended = true;

  final _screens = const [
    ExploreScreen(),
    SearchScreen(),
    OrdersScreen(),
    FavoritesScreen(),
    DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktop(context);
    final content = IndexedStack(index: _index, children: _screens);

    if (desktop) {
      return Scaffold(
        body: Row(
          children: [
            _SideMenu(
              index: _index,
              extended: _menuExtended,
              onToggle: () => setState(() => _menuExtended = !_menuExtended),
              onSelect: (i) => setState(() => _index = i),
            ),
            Expanded(child: ClipRect(child: content)),
          ],
        ),
      );
    }

    return Scaffold(
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          for (final it in _items)
            BottomNavigationBarItem(icon: Icon(it.icon), activeIcon: Icon(it.activeIcon), label: it.label),
        ],
      ),
    );
  }
}

class _SideMenu extends StatelessWidget {
  final int index;
  final bool extended;
  final VoidCallback onToggle;
  final ValueChanged<int> onSelect;
  const _SideMenu({required this.index, required this.extended, required this.onToggle, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final ek = EkekoColors.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: extended ? 232 : 76,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(right: BorderSide(color: ek.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          // Botón de menú + marca
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                IconButton(
                  tooltip: extended ? 'Contraer menú' : 'Expandir menú',
                  onPressed: onToggle,
                  icon: const Icon(Icons.menu_rounded),
                ),
                if (extended) ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(gradient: AppColors.heroGradient, borderRadius: BorderRadius.circular(9)),
                    child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 17),
                  ),
                  const SizedBox(width: 8),
                  const Text('EKEKO', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 0.5)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                for (int i = 0; i < _items.length; i++)
                  _MenuTile(item: _items[i], selected: i == index, extended: extended, onTap: () => onSelect(i)),
              ],
            ),
          ),
          const Divider(height: 1),
          // Toggle de tema
          Padding(
            padding: const EdgeInsets.all(10),
            child: _MenuTile(
              item: _NavItem(
                app.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                app.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                app.isDark ? 'Tema claro' : 'Tema oscuro',
              ),
              selected: false,
              extended: extended,
              onTap: () => context.read<AppState>().toggleTheme(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final bool extended;
  final VoidCallback onTap;
  const _MenuTile({required this.item, required this.selected, required this.extended, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ek = EkekoColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 46,
            padding: EdgeInsets.symmetric(horizontal: extended ? 14 : 0),
            alignment: extended ? Alignment.centerLeft : Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(selected ? item.activeIcon : item.icon, size: 23, color: selected ? AppColors.primary : ek.muted),
                if (extended) ...[
                  const SizedBox(width: 14),
                  Text(item.label, style: TextStyle(fontWeight: selected ? FontWeight.w800 : FontWeight.w600, color: selected ? AppColors.primary : null)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
