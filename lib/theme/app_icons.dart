import 'package:flutter/material.dart';

/// Iconografía propia de EKEKO basada en Material Icons (sin emojis).
class AppIcons {
  AppIcons._();

  static const IconData brand = Icons.storefront_rounded;

  static const Map<String, IconData> _category = {
    'Ropa': Icons.checkroom_rounded,
    'Casa': Icons.chair_rounded,
    'Accesorios': Icons.diamond_rounded,
    'Tecnología': Icons.devices_rounded,
    'Servicios': Icons.handyman_rounded,
    'Alimentos': Icons.restaurant_rounded,
    'Belleza': Icons.spa_rounded,
    'Artesanías': Icons.palette_rounded,
  };

  static const Map<String, IconData> _service = {
    'Gimnasio': Icons.fitness_center_rounded,
    'Restaurante': Icons.restaurant_menu_rounded,
    'Plomería': Icons.plumbing_rounded,
    'Pintura': Icons.format_paint_rounded,
    'Albañilería': Icons.construction_rounded,
    'Carpintería': Icons.carpenter_rounded,
    'Electricidad': Icons.electrical_services_rounded,
    'Jardinería': Icons.grass_rounded,
    'Limpieza': Icons.cleaning_services_rounded,
    'Clases': Icons.school_rounded,
    'Transporte': Icons.local_shipping_rounded,
    'Tecnología': Icons.memory_rounded,
  };

  static IconData forCategory(String category) =>
      _category[category] ?? Icons.store_mall_directory_rounded;

  static IconData forService(String? serviceType) =>
      serviceType == null ? Icons.handyman_rounded : (_service[serviceType] ?? Icons.handyman_rounded);

  /// Icono de un negocio: su tipo de servicio si lo tiene, si no su categoría.
  static IconData forBusiness(String category, {String? serviceType}) {
    if (category == 'Servicios') return forService(serviceType);
    return forCategory(category);
  }

  /// Intenta inferir un icono de producto por palabras clave del nombre;
  /// si no, usa el de la categoría.
  static IconData forProduct(String name, String category) {
    final n = name.toLowerCase();
    for (final entry in _productKeywords.entries) {
      if (entry.key.any((k) => n.contains(k))) return entry.value;
    }
    return forCategory(category);
  }

  static final Map<List<String>, IconData> _productKeywords = {
    ['camisa', 'polera', 'blusa', 'vestido', 'chompa', 'ropa', 'jean', 'pantal']: Icons.checkroom_rounded,
    ['zapato', 'bota', 'calzado', 'mocasin', 'sandalia', 'zapatilla']: Icons.ice_skating_rounded,
    ['bolso', 'cartera', 'billetera', 'mochila']: Icons.shopping_bag_rounded,
    ['anillo', 'collar', 'arete', 'joya', 'reloj', 'pulsera']: Icons.diamond_rounded,
    ['laptop', 'computad', 'pc', 'notebook']: Icons.laptop_mac_rounded,
    ['celular', 'telefono', 'smartphone', 'movil']: Icons.smartphone_rounded,
    ['audifon', 'parlante', 'auricular', 'headset']: Icons.headphones_rounded,
    ['control', 'consola', 'gamer', 'gaming', 'joystick']: Icons.sports_esports_rounded,
    ['teclado', 'mouse', 'raton']: Icons.keyboard_rounded,
    ['torta', 'pastel', 'cupcake', 'postre', 'reposter']: Icons.cake_rounded,
    ['pizza', 'hamburgues', 'comida', 'almuerzo', 'plato', 'silpancho', 'pique']: Icons.lunch_dining_rounded,
    ['cafe', 'bebida', 'jugo', 'te ']: Icons.local_cafe_rounded,
    ['crema', 'jabon', 'aceite', 'cosm', 'facial', 'manicura', 'pedicura']: Icons.spa_rounded,
    ['silla', 'mesa', 'mueble', 'sofa', 'cama', 'decora']: Icons.chair_rounded,
    ['lampara', 'foco', 'luz']: Icons.lightbulb_rounded,
    ['taza', 'vasija', 'cerami', 'barro', 'artesan']: Icons.emoji_food_beverage_rounded,
    ['taladro', 'herramient', 'cemento', 'construc']: Icons.handyman_rounded,
    ['servicio', 'reparac', 'manteni', 'instalac', 'diagn']: Icons.build_rounded,
    ['clase', 'curso', 'asesor']: Icons.school_rounded,
  };
}
