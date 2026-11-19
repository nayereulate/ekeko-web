import 'package:flutter_web_plugins/url_strategy.dart';

/// En web usamos URLs limpias (sin #): tusitio.com/tienda/nombre.
/// Requiere que el hosting redirija rutas desconocidas a index.html
/// (ver _redirects, vercel.json y serve.py).
void configureUrlStrategy() => usePathUrlStrategy();
