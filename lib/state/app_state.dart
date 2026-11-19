import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../data/mock_data.dart';
import '../models/business.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/order.dart';

/// Estado global de la app (datos de prueba, sin backend).
class AppState extends ChangeNotifier {
  AppState() {
    businesses = buildMockBusinesses();
    _myBusinessId = businesses.first.id;
  }

  late final List<Business> businesses;
  String? _myBusinessId;

  // ——— Tema ———
  ThemeMode themeMode = ThemeMode.light;
  bool get isDark => themeMode == ThemeMode.dark;
  void toggleTheme() {
    themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // ——— Sesión del vendedor ———
  bool isLoggedIn = false;
  Business get myBusiness => businesses.firstWhere((b) => b.id == _myBusinessId, orElse: () => businesses.first);
  void loginAs(String businessId) { _myBusinessId = businessId; isLoggedIn = true; notifyListeners(); }
  void login() { isLoggedIn = true; notifyListeners(); }
  void logout() { isLoggedIn = false; notifyListeners(); }

  Business? byId(String id) {
    for (final b in businesses) {
      if (b.id == id) return b;
    }
    return null;
  }

  Business? bySlug(String slug) {
    for (final b in businesses) {
      if (b.slug == slug) return b;
    }
    return null;
  }

  ({Product product, Business business})? productById(String id) {
    for (final b in businesses) {
      for (final p in b.products) {
        if (p.id == id) return (product: p, business: b);
      }
    }
    return null;
  }

  // ——— Favoritos ———
  final Set<String> _favoriteBusinessIds = {};
  bool isFavorite(String id) => _favoriteBusinessIds.contains(id);
  void toggleFavorite(String id) {
    _favoriteBusinessIds.contains(id) ? _favoriteBusinessIds.remove(id) : _favoriteBusinessIds.add(id);
    notifyListeners();
  }
  List<Business> get favoriteBusinesses => businesses.where((b) => _favoriteBusinessIds.contains(b.id)).toList();

  // ——— Seguir tiendas ———
  final Set<String> _followIds = {};
  bool isFollowing(String id) => _followIds.contains(id);
  void toggleFollow(String id) {
    _followIds.contains(id) ? _followIds.remove(id) : _followIds.add(id);
    notifyListeners();
  }

  // ——— Geolocalización ———
  double? userLat;
  double? userLng;
  bool locating = false;
  String? locationError;

  Future<void> fetchLocation() async {
    locating = true; locationError = null; notifyListeners();
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) throw 'Activa la ubicación del dispositivo.';
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        throw 'Permiso de ubicación denegado.';
      }
      final pos = await Geolocator.getCurrentPosition();
      userLat = pos.latitude; userLng = pos.longitude;
    } catch (e) {
      locationError = e.toString();
    } finally {
      locating = false; notifyListeners();
    }
  }

  /// Distancia en km del usuario a un negocio (null si falta algún dato).
  double? distanceKm(Business b) {
    if (userLat == null || userLng == null || b.lat == null || b.lng == null) return null;
    final m = Geolocator.distanceBetween(userLat!, userLng!, b.lat!, b.lng!);
    return m / 1000.0;
  }

  // ——— Pedidos / seguimiento / entrega ———
  final List<Order> orders = [];

  Order createOrder({
    required Business business,
    required List<OrderItem> items,
    required String buyerName,
    required String deliveryMode,
    String? meetingPointName,
  }) {
    final n = orders.length + 1;
    final order = Order(
      id: 'o${DateTime.now().millisecondsSinceEpoch}',
      code: 'EK-${(1000 + n * 37) % 9000 + 1000}',
      businessId: business.id,
      businessName: business.name,
      items: items,
      buyerName: buyerName,
      createdAt: DateTime.now(),
      deliveryMode: deliveryMode,
      meetingPointName: meetingPointName,
    );
    orders.insert(0, order);
    notifyListeners();
    return order;
  }

  void advanceOrder(Order order) {
    const seq = OrderStage.values;
    final i = seq.indexOf(order.stage);
    if (i < seq.length - 1) {
      order.stage = seq[i + 1];
      if (order.stage == OrderStage.delivered) order.deliveredAt = DateTime.now();
      notifyListeners();
    }
  }

  /// Verifica un QR de entrega: marca el pedido como entregado si coincide.
  Order? confirmDeliveryByPayload(String payload) {
    final parts = payload.split('|');
    if (parts.length < 2 || parts.first != 'EKEKO') return null;
    final code = parts[1];
    for (final o in orders) {
      if (o.code == code) {
        o.stage = OrderStage.delivered;
        o.deliveredAt = DateTime.now();
        notifyListeners();
        return o;
      }
    }
    return null;
  }

  // ——— Chat (local, sin backend) ———
  final Map<String, List<ChatMessage>> _chats = {};
  List<ChatMessage> chatWith(String businessId) => _chats[businessId] ?? const [];

  void sendMessage(String businessId, String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    final list = _chats.putIfAbsent(businessId, () => []);
    list.add(ChatMessage(text: t, fromMe: true, at: DateTime.now()));
    notifyListeners();
    // Respuesta automática simulada del vendedor.
    Future.delayed(const Duration(milliseconds: 900), () {
      list.add(ChatMessage(
        text: '¡Hola! Gracias por escribir a ${byId(businessId)?.name ?? 'nuestra tienda'}. '
            'En breve te damos los detalles. 😊',
        fromMe: false,
        at: DateTime.now(),
      ));
      notifyListeners();
    });
  }

  // ——— Registro / edición del vendedor ———
  void _replace(Business updated) {
    final i = businesses.indexWhere((b) => b.id == updated.id);
    if (i != -1) businesses[i] = updated;
    notifyListeners();
  }

  Business registerBusiness({
    required String name,
    required String category,
    String? serviceType,
    required String department,
    required String city,
    required String zone,
    required String description,
    required BusinessLinks links,
    String? tagline,
  }) {
    final id = 'b${DateTime.now().millisecondsSinceEpoch}';
    final biz = Business(
      id: id, name: name, category: category, serviceType: serviceType,
      department: department, city: city, zone: zone, description: description,
      tagline: tagline, avatarEmoji: '🛍️', color: const Color(0xFF1667A6), links: links,
    );
    businesses.insert(0, biz);
    _myBusinessId = id; isLoggedIn = true;
    notifyListeners();
    return biz;
  }

  void upgradePlan(BusinessPlan plan) => _replace(myBusiness.copyWith(plan: plan));

  void updateMyBusinessProfile({
    String? name,
    String? category,
    String? serviceType,
    String? department,
    String? city,
    String? zone,
    String? description,
    String? tagline,
    BusinessLinks? links,
    Color? color,
    int? coverStyle,
    bool? shipsNationwide,
    bool? respondsFast,
  }) {
    _replace(myBusiness.copyWith(
      name: name, category: category, serviceType: serviceType, department: department,
      city: city, zone: zone, description: description, tagline: tagline, links: links,
      color: color, coverStyle: coverStyle, shipsNationwide: shipsNationwide, respondsFast: respondsFast,
    ));
  }

  void setMyQr(Uint8List bytes) => _replace(myBusiness.copyWith(qrImage: bytes));

  Future<void> useMyLocationForBusiness() async {
    await fetchLocation();
    if (userLat != null && userLng != null) {
      _replace(myBusiness.copyWith(lat: userLat, lng: userLng));
    }
  }

  // ——— Productos del negocio propio ———
  void addProductToMyBusiness(Product product) =>
      _replace(myBusiness.copyWith(products: [...myBusiness.products, product]));

  void updateMyProduct(Product updated) {
    final list = [...myBusiness.products];
    final i = list.indexWhere((p) => p.id == updated.id);
    if (i != -1) list[i] = updated;
    _replace(myBusiness.copyWith(products: list));
  }

  void deleteMyProduct(String productId) =>
      _replace(myBusiness.copyWith(products: myBusiness.products.where((p) => p.id != productId).toList()));

  // ——— Reseñas ———
  void addReview(String businessId, Review review) {
    final b = byId(businessId);
    if (b == null) return;
    final reviews = [review, ...b.reviews];
    final avg = reviews.fold(0.0, (s, r) => s + r.rating) / reviews.length;
    final updated = Business(
      id: b.id, name: b.name, category: b.category, serviceType: b.serviceType,
      department: b.department, city: b.city, zone: b.zone, description: b.description,
      tagline: b.tagline, avatarEmoji: b.avatarEmoji, color: b.color, isVerified: b.isVerified,
      rating: double.parse(avg.toStringAsFixed(2)), reviewCount: reviews.length, plan: b.plan,
      links: b.links, products: b.products, reviews: reviews, profileVisits: b.profileVisits,
      linkClicks: b.linkClicks, contactsGenerated: b.contactsGenerated, respondsFast: b.respondsFast,
      shipsNationwide: b.shipsNationwide, salesCount: b.salesCount, official: b.official,
      lat: b.lat, lng: b.lng, qrImage: b.qrImage, coverStyle: b.coverStyle,
    );
    _replace(updated);
  }

  // ——— Métricas simuladas ———
  void trackVisit(String businessId) {}
}
