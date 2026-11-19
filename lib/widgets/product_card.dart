import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_icons.dart';
import 'avatar_blob.dart';
import 'hover_lift.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Color color;
  final String category;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.color,
    required this.onTap,
    this.category = '',
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CoverBlob(
                  icon: AppIcons.forProduct(product.name, category),
                  color: color,
                  height: 104,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                  image: product.image != null ? MemoryImage(product.image!) : null,
                ),
                if (product.isFeatured)
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.star_rounded, size: 12, color: Color(0xFFE0A52B)),
                        SizedBox(width: 3),
                        Text('Destacado', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800)),
                      ]),
                    ),
                  ),
                if (!product.inStock)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.45),
                      alignment: Alignment.center,
                      child: const Text('Agotado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.25)),
                  const SizedBox(height: 5),
                  Text(product.price == 0 ? 'Consultar' : product.formattedPrice,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5, color: Color(0xFF1667A6))),
                ],
              ),
            ),
          ],
        ),
      ),
     ),
    );
  }
}
