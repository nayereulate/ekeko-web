import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'product.dart';
import 'review.dart';

/// Convierte un texto en un slug para URL: "Tejidos Wara" -> "tejidos-wara".
String slugify(String s) {
  const from = 'áàäâãéèëêíìïîóòöôõúùüûñç';
  const to = 'aaaaaeeeeiiiiooooouuuunc';
  var out = s.toLowerCase();
  for (var i = 0; i < from.length; i++) {
    out = out.replaceAll(from[i], to[i]);
  }
  return out.replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'(^-+|-+$)'), '');
}

enum BusinessPlan { free, plus, pro }

extension BusinessPlanX on BusinessPlan {
  String get label => switch (this) {
        BusinessPlan.free => 'Ekeko Free',
        BusinessPlan.plus => 'Ekeko Plus',
        BusinessPlan.pro => 'Ekeko Pro',
      };

  Color get color => switch (this) {
        BusinessPlan.free => const Color(0xFF5F7484),
        BusinessPlan.plus => const Color(0xFF21A56B),
        BusinessPlan.pro => const Color(0xFF1667A6),
      };
}

class BusinessLinks {
  final String? instagram;
  final String? facebook;
  final String? tiktok;
  final String whatsappPhone; // formato internacional sin '+', ej: 59171234567
  final String? website;
  final String? mapsQuery;

  const BusinessLinks({
    this.instagram,
    this.facebook,
    this.tiktok,
    required this.whatsappPhone,
    this.website,
    this.mapsQuery,
  });

  BusinessLinks copyWith({
    String? instagram,
    String? facebook,
    String? tiktok,
    String? whatsappPhone,
    String? website,
    String? mapsQuery,
  }) =>
      BusinessLinks(
        instagram: instagram ?? this.instagram,
        facebook: facebook ?? this.facebook,
        tiktok: tiktok ?? this.tiktok,
        whatsappPhone: whatsappPhone ?? this.whatsappPhone,
        website: website ?? this.website,
        mapsQuery: mapsQuery ?? this.mapsQuery,
      );
}

class Business {
  final String id;
  final String name;
  final String category;
  final String? serviceType; // solo para categoría "Servicios"
  final String department;    // uno de los 9 departamentos
  final String city;
  final String zone;
  final String description;
  final String? tagline;      // frase corta de venta
  final String avatarEmoji;   // legado (ya no se muestra; se usa icono)
  final Color color;          // color de marca (personalizable)
  final bool isVerified;
  final double rating;
  final int reviewCount;
  final BusinessPlan plan;
  final BusinessLinks links;
  final List<Product> products;
  final List<Review> reviews;
  final int profileVisits;
  final int linkClicks;
  final int contactsGenerated;

  // Nuevos
  final bool respondsFast;
  final bool shipsNationwide;
  final int salesCount;
  final bool official;
  final double? lat;
  final double? lng;
  final Uint8List? qrImage;   // QR de pago subido por el vendedor
  final int coverStyle;       // 0..2 estilos de portada

  const Business({
    required this.id,
    required this.name,
    required this.category,
    required this.department,
    required this.city,
    required this.zone,
    required this.description,
    required this.avatarEmoji,
    required this.color,
    required this.links,
    this.serviceType,
    this.tagline,
    this.isVerified = false,
    this.rating = 0,
    this.reviewCount = 0,
    this.plan = BusinessPlan.free,
    this.products = const [],
    this.reviews = const [],
    this.profileVisits = 0,
    this.linkClicks = 0,
    this.contactsGenerated = 0,
    this.respondsFast = false,
    this.shipsNationwide = false,
    this.salesCount = 0,
    this.official = false,
    this.lat,
    this.lng,
    this.qrImage,
    this.coverStyle = 0,
  });

  /// Identificador para la URL de la vitrina (ej. "tejidos-wara").
  String get slug => slugify(name);

  Business copyWith({
    String? name,
    String? category,
    String? serviceType,
    String? department,
    String? city,
    String? zone,
    String? description,
    String? tagline,
    Color? color,
    BusinessPlan? plan,
    BusinessLinks? links,
    List<Product>? products,
    bool? respondsFast,
    bool? shipsNationwide,
    double? lat,
    double? lng,
    Uint8List? qrImage,
    int? coverStyle,
  }) {
    return Business(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      serviceType: serviceType ?? this.serviceType,
      department: department ?? this.department,
      city: city ?? this.city,
      zone: zone ?? this.zone,
      description: description ?? this.description,
      tagline: tagline ?? this.tagline,
      avatarEmoji: avatarEmoji,
      color: color ?? this.color,
      isVerified: isVerified,
      rating: rating,
      reviewCount: reviewCount,
      plan: plan ?? this.plan,
      links: links ?? this.links,
      products: products ?? this.products,
      reviews: reviews,
      profileVisits: profileVisits,
      linkClicks: linkClicks,
      contactsGenerated: contactsGenerated,
      respondsFast: respondsFast ?? this.respondsFast,
      shipsNationwide: shipsNationwide ?? this.shipsNationwide,
      salesCount: salesCount,
      official: official,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      qrImage: qrImage ?? this.qrImage,
      coverStyle: coverStyle ?? this.coverStyle,
    );
  }
}
