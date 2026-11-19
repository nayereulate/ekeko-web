import 'dart:typed_data';

class Product {
  final String id;
  final String businessId;
  final String name;
  final double price;
  final String description;
  final String emoji; // legado (ya no se muestra; se usa icono o foto)
  final bool inStock;
  final bool isFeatured;
  final List<String> variants;
  final Uint8List? image; // foto subida por el vendedor (opcional)

  const Product({
    required this.id,
    required this.businessId,
    required this.name,
    required this.price,
    required this.description,
    required this.emoji,
    this.inStock = true,
    this.isFeatured = false,
    this.variants = const [],
    this.image,
  });

  String get formattedPrice =>
      'Bs ${price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)}';
}
