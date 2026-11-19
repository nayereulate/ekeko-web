# EKEKO

Marketplace / vitrina digital de negocios bolivianos, hecho con **Flutter** (un solo
código para **Android** y **web**).

🌐 **En vivo:** https://ekeko-phi.vercel.app

## Qué hace
- Directorio de tiendas y servicios por **categoría** y los **9 departamentos** de Bolivia.
- **Vitrina personalizable** por vendedor (color de marca, portada, redes, QR de pago, ubicación).
- **Link propio por tienda y producto** (`/tienda/<slug>`, `/producto/<id>`) — ideal para la bio.
- **Chat** comprador–vendedor, **seguimiento de envío**, **verificación de entrega por QR** (escáner),
  **puntos de encuentro** seguros y **geolocalización** ("cerca de ti").
- **Modo claro/oscuro**, diseño responsivo con menú lateral en PC y animaciones.

## Correr en desarrollo
```bash
flutter pub get
flutter run -d chrome   # web
flutter run             # dispositivo/emulador Android
```

## Compilar para web
```bash
flutter build web --release
# salida en build/web
```

## Estructura
```
lib/
  models/      Business, Product, Review, Order…
  state/       AppState (estado global con provider)
  theme/       paleta, tipografía, iconos propios
  screens/     explore, search, business, dashboard, orders, chat, auth…
  widgets/     tarjetas, carrusel, hover, insignias…
```

## Notas
- Datos de ejemplo en memoria (sin backend todavía): el seguimiento de envío avanza
  manualmente, el chat responde automático y los datos no persisten.
- Geolocalización y escáner de QR requieren HTTPS o localhost.

---
Hecho con Flutter · [Claude Code](https://claude.com/claude-code)
