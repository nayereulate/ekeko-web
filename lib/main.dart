import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/business.dart';
import 'screens/splash_screen.dart';
import 'screens/home/home_shell.dart';
import 'screens/business/business_profile_screen.dart';
import 'screens/business/product_detail_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'url_strategy_stub.dart' if (dart.library.js_interop) 'url_strategy_web.dart';

const String kTiendaPrefix = '/tienda/';
const String kProductoPrefix = '/producto/';

void main() {
  configureUrlStrategy();
  runApp(EkekoApp(appState: AppState()));
}

class EkekoApp extends StatelessWidget {
  final AppState appState;
  const EkekoApp({super.key, required this.appState});

  /// Devuelve el negocio de una ruta "/tienda/slug", o null.
  Business? _matchTienda(String? name) {
    if (name == null || !name.startsWith(kTiendaPrefix)) return null;
    final slug = name.substring(kTiendaPrefix.length).split('?').first;
    return appState.bySlug(slug);
  }

  /// Construye la pantalla de producto de una ruta "/producto/id", o null.
  Widget? _buildProducto(String? name) {
    if (name == null || !name.startsWith(kProductoPrefix)) return null;
    final id = name.substring(kProductoPrefix.length).split('?').first;
    final found = appState.productById(id);
    if (found == null) return null;
    return ProductDetailScreen(product: found.product, business: found.business);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      child: Consumer<AppState>(
        builder: (context, app, _) => MaterialApp(
          title: 'EKEKO',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: app.themeMode,
          // Deep link inicial (abrir .../tienda/slug o .../producto/id directo).
          onGenerateInitialRoutes: (initialRoute) {
            final b = _matchTienda(initialRoute);
            final prod = _buildProducto(initialRoute);
            if (b != null || prod != null) {
              app.login(); // entra como invitado para ver el contenido compartido
              return [
                MaterialPageRoute(builder: (_) => const HomeShell(), settings: const RouteSettings(name: '/')),
                MaterialPageRoute(
                  builder: (_) => b != null ? BusinessProfileScreen(business: b) : prod!,
                  settings: RouteSettings(name: initialRoute),
                ),
              ];
            }
            return [MaterialPageRoute(builder: (_) => const SplashScreen(), settings: const RouteSettings(name: '/'))];
          },
          // Navegación por nombre (pushNamed('/tienda/slug') o '/producto/id').
          onGenerateRoute: (settings) {
            final b = _matchTienda(settings.name);
            if (b != null) {
              return MaterialPageRoute(builder: (_) => BusinessProfileScreen(business: b), settings: settings);
            }
            final prod = _buildProducto(settings.name);
            if (prod != null) {
              return MaterialPageRoute(builder: (_) => prod, settings: settings);
            }
            return null;
          },
        ),
      ),
    );
  }
}
