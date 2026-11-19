import '../models/business.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/order.dart';
import '../theme/app_theme.dart';

/// Categorías principales de EKEKO.
const List<String> kCategories = [
  'Ropa',
  'Casa',
  'Accesorios',
  'Tecnología',
  'Servicios',
  'Alimentos',
  'Belleza',
  'Artesanías',
];

/// Tipos dentro de la categoría "Servicios".
const List<String> kServiceTypes = [
  'Gimnasio',
  'Restaurante',
  'Plomería',
  'Pintura',
  'Albañilería',
  'Carpintería',
  'Electricidad',
  'Jardinería',
  'Limpieza',
  'Clases',
  'Transporte',
  'Tecnología',
];

/// Los 9 departamentos de Bolivia.
const List<String> kDepartments = [
  'La Paz',
  'Santa Cruz',
  'Cochabamba',
  'Oruro',
  'Potosí',
  'Chuquisaca',
  'Tarija',
  'Beni',
  'Pando',
];

/// Coordenadas aproximadas de la capital de cada departamento.
const Map<String, List<double>> kDepartmentCoords = {
  'La Paz': [-16.5000, -68.1500],
  'Santa Cruz': [-17.7833, -63.1821],
  'Cochabamba': [-17.3895, -66.1568],
  'Oruro': [-17.9833, -67.1500],
  'Potosí': [-19.5836, -65.7531],
  'Chuquisaca': [-19.0333, -65.2627],
  'Tarija': [-21.5355, -64.7296],
  'Beni': [-14.8333, -64.9000],
  'Pando': [-11.0267, -68.7692],
};

/// Puntos de encuentro seguros sugeridos.
const List<MeetingPoint> kMeetingPoints = [
  MeetingPoint(name: 'Estación Central Teleférico', department: 'La Paz', city: 'La Paz', note: 'Zona concurrida y con seguridad.', lat: -16.4955, lng: -68.1336),
  MeetingPoint(name: 'Ventura Mall', department: 'Santa Cruz', city: 'Santa Cruz', note: 'Parqueo y cámaras de seguridad.', lat: -17.7520, lng: -63.1990),
  MeetingPoint(name: 'Plaza Colón', department: 'Cochabamba', city: 'Cochabamba', note: 'Punto céntrico y seguro.', lat: -17.3930, lng: -66.1570),
  MeetingPoint(name: 'Plaza 10 de Febrero', department: 'Oruro', city: 'Oruro', note: 'Centro de la ciudad.', lat: -17.9700, lng: -67.1110),
  MeetingPoint(name: 'Plaza 10 de Noviembre', department: 'Potosí', city: 'Potosí', note: 'Zona central vigilada.', lat: -19.5890, lng: -65.7540),
  MeetingPoint(name: 'Plaza 25 de Mayo', department: 'Chuquisaca', city: 'Sucre', note: 'Plaza principal de Sucre.', lat: -19.0470, lng: -65.2590),
  MeetingPoint(name: 'Plaza Luis de Fuentes', department: 'Tarija', city: 'Tarija', note: 'Centro, muy concurrido.', lat: -21.5350, lng: -64.7290),
  MeetingPoint(name: 'Plaza principal Trinidad', department: 'Beni', city: 'Trinidad', note: 'Centro de Trinidad.', lat: -14.8333, lng: -64.9000),
  MeetingPoint(name: 'Plaza principal Cobija', department: 'Pando', city: 'Cobija', note: 'Centro de Cobija.', lat: -11.0267, lng: -68.7692),
];

List<MeetingPoint> meetingPointsFor(String department) =>
    kMeetingPoints.where((m) => m.department == department).toList();

List<Business> buildMockBusinesses() {
  return [
    Business(
      id: 'b1', name: 'Tejidos Wara', category: 'Ropa', department: 'La Paz', city: 'La Paz', zone: 'Sopocachi',
      tagline: 'Tejidos de alpaca hechos a mano',
      description: 'Chompas, chalinas y gorros tejidos a mano en fibra de alpaca. Diseños andinos con un toque moderno.',
      avatarEmoji: '🧶', color: AppColors.forSeed(0), isVerified: true, rating: 4.8, reviewCount: 34,
      plan: BusinessPlan.plus, respondsFast: true, shipsNationwide: true, salesCount: 60,
      lat: -16.5000, lng: -68.1500,
      links: const BusinessLinks(instagram: '@tejidoswara', facebook: 'TejidosWaraBolivia', tiktok: '@tejidoswara', whatsappPhone: '59171234501', website: 'tejidoswara.bo', mapsQuery: 'Sopocachi, La Paz, Bolivia'),
      profileVisits: 1280, linkClicks: 340, contactsGenerated: 96,
      products: const [
        Product(id: 'p1', businessId: 'b1', name: 'Chompa de alpaca clásica', price: 220, description: 'Chompa 100% alpaca, tejido tupido, 4 colores.', emoji: '🧥', isFeatured: true, variants: ['S', 'M', 'L', 'XL']),
        Product(id: 'p2', businessId: 'b1', name: 'Chalina jacquard', price: 95, description: 'Chalina con motivos andinos tejidos a telar.', emoji: '🧣'),
        Product(id: 'p3', businessId: 'b1', name: 'Gorro con orejeras', price: 60, description: 'Gorro abrigado ideal para el altiplano.', emoji: '🧢'),
        Product(id: 'p4', businessId: 'b1', name: 'Guantes de lana', price: 45, description: 'Par de guantes tejidos, varios colores.', emoji: '🧤', inStock: false),
      ],
      reviews: const [
        Review(id: 'r1', authorName: 'Fátima R.', rating: 5, comment: 'Hermosa calidad, la chompa abriga muchísimo.', daysAgo: 3),
        Review(id: 'r2', authorName: 'Jorge M.', rating: 4.5, comment: 'Buena atención por WhatsApp, entrega rápida.', daysAgo: 12),
      ],
    ),
    Business(
      id: 'b2', name: 'Dulce Sabor', category: 'Alimentos', department: 'Santa Cruz', city: 'Santa Cruz', zone: 'Equipetrol',
      tagline: 'Tortas y postres para toda ocasión',
      description: 'Tortas personalizadas, cupcakes y postres para toda ocasión. Pedidos con 24h de anticipación.',
      avatarEmoji: '🎂', color: AppColors.forSeed(1), isVerified: true, rating: 4.9, reviewCount: 58,
      plan: BusinessPlan.pro, respondsFast: true, salesCount: 120, lat: -17.7833, lng: -63.1821,
      links: const BusinessLinks(instagram: '@dulcesabor.scz', tiktok: '@dulcesabor', whatsappPhone: '59175544302', mapsQuery: 'Equipetrol, Santa Cruz, Bolivia'),
      profileVisits: 2430, linkClicks: 810, contactsGenerated: 212,
      products: const [
        Product(id: 'p5', businessId: 'b2', name: 'Torta de chocolate (20 porciones)', price: 180, description: 'Bizcocho húmedo de chocolate con ganache.', emoji: '🍫', isFeatured: true),
        Product(id: 'p6', businessId: 'b2', name: 'Caja de 12 cupcakes', price: 96, description: 'Sabores surtidos: vainilla, chocolate y red velvet.', emoji: '🧁'),
        Product(id: 'p7', businessId: 'b2', name: 'Torta temática infantil', price: 250, description: 'Diseño personalizado según el tema.', emoji: '🎨'),
      ],
      reviews: const [
        Review(id: 'r3', authorName: 'Camila V.', rating: 5, comment: 'La mejor torta que probé en Santa Cruz.', daysAgo: 1),
        Review(id: 'r4', authorName: 'Diego S.', rating: 5, comment: 'Puntuales y muy ricas las cupcakes.', daysAgo: 8),
      ],
    ),
    Business(
      id: 'b3', name: 'Bella Andina', category: 'Belleza', department: 'Cochabamba', city: 'Cochabamba', zone: 'Cala Cala',
      tagline: 'Cosmética natural boliviana',
      description: 'Cosmética natural boliviana: jabones, cremas y aceites elaborados con insumos locales.',
      avatarEmoji: '🧴', color: AppColors.forSeed(2), rating: 4.6, reviewCount: 21, salesCount: 24,
      lat: -17.3895, lng: -66.1568,
      links: const BusinessLinks(instagram: '@bellaandina.bo', whatsappPhone: '59168891203'),
      profileVisits: 540, linkClicks: 140, contactsGenerated: 38,
      products: const [
        Product(id: 'p8', businessId: 'b3', name: 'Jabón de coca y menta', price: 18, description: 'Jabón artesanal exfoliante, 100g.', emoji: '🧼'),
        Product(id: 'p9', businessId: 'b3', name: 'Crema de manos a la miel', price: 35, description: 'Hidratación profunda con miel de Bolivia.', emoji: '🍯', isFeatured: true),
        Product(id: 'p10', businessId: 'b3', name: 'Aceite corporal de sacha inchi', price: 55, description: 'Aceite 100% natural, 120ml.', emoji: '🌿'),
      ],
      reviews: const [Review(id: 'r5', authorName: 'Paola T.', rating: 5, comment: 'Huele riquísimo y es súper suave.', daysAgo: 5)],
    ),
    Business(
      id: 'b4', name: 'Manos de Barro', category: 'Artesanías', department: 'La Paz', city: 'El Alto', zone: '16 de Julio',
      tagline: 'Cerámica inspirada en Tiwanaku',
      description: 'Cerámica artesanal inspirada en la cultura Tiwanaku: vasijas, tazas y figuras decorativas.',
      avatarEmoji: '🏺', color: AppColors.forSeed(3), isVerified: true, rating: 4.7, reviewCount: 42,
      plan: BusinessPlan.plus, shipsNationwide: true, salesCount: 55, lat: -16.5047, lng: -68.1633,
      links: const BusinessLinks(instagram: '@manosdebarro', facebook: 'ManosDeBarroElAlto', whatsappPhone: '59172200198', mapsQuery: 'Feria 16 de Julio, El Alto, Bolivia'),
      profileVisits: 980, linkClicks: 260, contactsGenerated: 71,
      products: const [
        Product(id: 'p11', businessId: 'b4', name: 'Vasija Tiwanaku mediana', price: 140, description: 'Pieza única pintada a mano.', emoji: '🏺', isFeatured: true),
        Product(id: 'p12', businessId: 'b4', name: 'Set de 4 tazas de barro', price: 80, description: 'Ideal para regalo, motivos andinos.', emoji: '☕'),
        Product(id: 'p13', businessId: 'b4', name: 'Figura decorativa Ekeko', price: 65, description: 'Réplica artesanal del Ekeko.', emoji: '🗿'),
      ],
      reviews: const [
        Review(id: 'r6', authorName: 'Renata C.', rating: 5, comment: 'Increíble trabajo, se nota el detalle.', daysAgo: 15),
        Review(id: 'r7', authorName: 'Iván P.', rating: 4, comment: 'Muy bonito, tardó un poco la entrega.', daysAgo: 20),
      ],
    ),
    Business(
      id: 'b5', name: 'TecnoFix Bolivia', category: 'Tecnología', department: 'La Paz', city: 'La Paz', zone: 'San Pedro',
      tagline: 'Reparación de celulares y laptops',
      description: 'Reparación de celulares y laptops. Cambio de pantallas, baterías y diagnóstico gratuito.',
      avatarEmoji: '🔧', color: AppColors.forSeed(4), isVerified: true, rating: 4.5, reviewCount: 67,
      plan: BusinessPlan.pro, respondsFast: true, salesCount: 150, lat: -16.5030, lng: -68.1420,
      links: const BusinessLinks(instagram: '@tecnofix.bo', whatsappPhone: '59176677012', website: 'tecnofixbolivia.com', mapsQuery: 'San Pedro, La Paz, Bolivia'),
      profileVisits: 1870, linkClicks: 520, contactsGenerated: 188,
      products: const [
        Product(id: 'p14', businessId: 'b5', name: 'Cambio de pantalla (gama media)', price: 250, description: 'Incluye instalación y garantía de 30 días.', emoji: '📱', isFeatured: true),
        Product(id: 'p15', businessId: 'b5', name: 'Cambio de batería', price: 120, description: 'Baterías originales, instalación en el día.', emoji: '🔋'),
        Product(id: 'p16', businessId: 'b5', name: 'Diagnóstico de laptop', price: 0, description: 'Revisión sin costo, cotización posterior.', emoji: '💻'),
      ],
      reviews: const [Review(id: 'r8', authorName: 'Marco A.', rating: 4.5, comment: 'Rápido y buen precio, recomendado.', daysAgo: 2)],
    ),
    Business(
      id: 'b6', name: 'Ferretería El Constructor', category: 'Casa', department: 'Santa Cruz', city: 'Santa Cruz', zone: 'Plan 3000',
      tagline: 'Todo para tu construcción',
      description: 'Materiales de construcción, herramientas y ferretería en general. Más de 15 años de trayectoria.',
      avatarEmoji: '🛠️', color: AppColors.forSeed(5), rating: 4.3, reviewCount: 29, salesCount: 30,
      lat: -17.8200, lng: -63.1500,
      links: const BusinessLinks(facebook: 'FerreteriaElConstructorSCZ', whatsappPhone: '59178812309', mapsQuery: 'Plan 3000, Santa Cruz, Bolivia'),
      profileVisits: 410, linkClicks: 95, contactsGenerated: 27,
      products: const [
        Product(id: 'p17', businessId: 'b6', name: 'Cemento (bolsa 50kg)', price: 62, description: 'Descuento por volumen.', emoji: '🧱'),
        Product(id: 'p18', businessId: 'b6', name: 'Taladro percutor', price: 380, description: 'Incluye maletín y 3 brocas.', emoji: '🪛', isFeatured: true),
      ],
      reviews: const [Review(id: 'r9', authorName: 'Willy Q.', rating: 4, comment: 'Buenos precios, atienden rápido.', daysAgo: 9)],
    ),
    Business(
      id: 'b7', name: 'Calzados Kantuta', category: 'Ropa', department: 'Cochabamba', city: 'Cochabamba', zone: 'América',
      tagline: 'Calzado de cuero hecho a mano',
      description: 'Calzado de cuero hecho a mano: botas, mocasines y sandalias para toda la familia.',
      avatarEmoji: '👞', color: AppColors.forSeed(0), isVerified: true, rating: 4.7, reviewCount: 45,
      plan: BusinessPlan.plus, shipsNationwide: true, salesCount: 80, lat: -17.3800, lng: -66.1700,
      links: const BusinessLinks(instagram: '@calzadoskantuta', tiktok: '@calzadoskantuta', whatsappPhone: '59167712045', mapsQuery: 'América, Cochabamba, Bolivia'),
      profileVisits: 1120, linkClicks: 300, contactsGenerated: 84,
      products: const [
        Product(id: 'p19', businessId: 'b7', name: 'Botas de cuero clásicas', price: 320, description: 'Cuero genuino, suela antideslizante.', emoji: '🥾', isFeatured: true, variants: ['38', '39', '40', '41', '42']),
        Product(id: 'p20', businessId: 'b7', name: 'Mocasines casuales', price: 210, description: 'Cómodos para uso diario.', emoji: '👞'),
      ],
      reviews: const [Review(id: 'r10', authorName: 'Sofía L.', rating: 5, comment: 'Excelente calidad, duran años.', daysAgo: 6)],
    ),
    Business(
      id: 'b8', name: 'Sabores del Valle', category: 'Servicios', serviceType: 'Restaurante', department: 'Cochabamba', city: 'Cochabamba', zone: 'Queru Queru',
      tagline: 'Comida típica y catering',
      description: 'Comida típica cochabambina para eventos y catering. Silpancho, pique macho y más.',
      avatarEmoji: '🍽️', color: AppColors.forSeed(1), rating: 4.8, reviewCount: 39, respondsFast: true, salesCount: 45,
      lat: -17.3700, lng: -66.1400,
      links: const BusinessLinks(instagram: '@saboresdelvalle.cbba', whatsappPhone: '59169903312'),
      profileVisits: 760, linkClicks: 190, contactsGenerated: 55,
      products: const [
        Product(id: 'p21', businessId: 'b8', name: 'Silpancho (porción)', price: 28, description: 'Plato tradicional cochabambino.', emoji: '🍛', isFeatured: true),
        Product(id: 'p22', businessId: 'b8', name: 'Pique macho para 2', price: 65, description: 'Carne, salchicha, papas y verduras.', emoji: '🥘'),
        Product(id: 'p23', businessId: 'b8', name: 'Catering (por persona)', price: 45, description: 'Mínimo 20 personas, menú a elección.', emoji: '🎉'),
      ],
      reviews: const [Review(id: 'r11', authorName: 'Hugo B.', rating: 5, comment: 'El mejor pique macho de la zona.', daysAgo: 4)],
    ),
    Business(
      id: 'b9', name: 'Estudio Glow', category: 'Belleza', department: 'Santa Cruz', city: 'Santa Cruz', zone: 'Las Palmas',
      tagline: 'Uñas y tratamientos faciales',
      description: 'Manicura, pedicura y tratamientos faciales. Reserva tu cita por WhatsApp.',
      avatarEmoji: '💅', color: AppColors.forSeed(2), isVerified: true, rating: 4.9, reviewCount: 73,
      plan: BusinessPlan.pro, respondsFast: true, salesCount: 200, lat: -17.7700, lng: -63.2000,
      links: const BusinessLinks(instagram: '@estudioglow.scz', tiktok: '@estudioglow', whatsappPhone: '59175591177', mapsQuery: 'Las Palmas, Santa Cruz, Bolivia'),
      profileVisits: 3100, linkClicks: 940, contactsGenerated: 301,
      products: const [
        Product(id: 'p24', businessId: 'b9', name: 'Manicura semipermanente', price: 60, description: 'Incluye limado, cutícula y esmaltado.', emoji: '💅', isFeatured: true),
        Product(id: 'p25', businessId: 'b9', name: 'Pedicura spa', price: 70, description: 'Exfoliación, masaje e hidratación.', emoji: '🦶'),
        Product(id: 'p26', businessId: 'b9', name: 'Limpieza facial profunda', price: 110, description: 'Sesión de 60 minutos.', emoji: '✨'),
      ],
      reviews: const [
        Review(id: 'r12', authorName: 'Anahí F.', rating: 5, comment: 'Súper profesionales, quedé encantada.', daysAgo: 2),
        Review(id: 'r13', authorName: 'Lucía G.', rating: 5, comment: 'Ambiente lindo y buena atención.', daysAgo: 10),
      ],
    ),
    Business(
      id: 'b10', name: 'Cuero Andino', category: 'Accesorios', department: 'La Paz', city: 'La Paz', zone: 'Mercado de las Brujas',
      tagline: 'Marroquinería de cuero genuino',
      description: 'Billeteras, bolsos y correas de cuero genuino, hechos por artesanos paceños.',
      avatarEmoji: '👜', color: AppColors.forSeed(3), rating: 4.4, reviewCount: 18, salesCount: 20,
      lat: -16.4960, lng: -68.1380,
      links: const BusinessLinks(instagram: '@cueroandino', whatsappPhone: '59170012233', mapsQuery: 'Mercado de las Brujas, La Paz, Bolivia'),
      profileVisits: 320, linkClicks: 80, contactsGenerated: 19,
      products: const [
        Product(id: 'p27', businessId: 'b10', name: 'Billetera de cuero', price: 75, description: 'Cuero curtido a mano, varios colores.', emoji: '👛'),
        Product(id: 'p28', businessId: 'b10', name: 'Bolso bandolera', price: 180, description: 'Diseño unisex, compartimentos internos.', emoji: '👜', isFeatured: true),
      ],
      reviews: const [Review(id: 'r14', authorName: 'Erik N.', rating: 4.5, comment: 'Muy buena calidad de cuero.', daysAgo: 18)],
    ),
    Business(
      id: 'b11', name: 'Diseños Print', category: 'Servicios', serviceType: 'Tecnología', department: 'Santa Cruz', city: 'Santa Cruz', zone: 'Segundo Anillo',
      tagline: 'Diseño gráfico e impresión',
      description: 'Diseño gráfico, logos, catálogos digitales e impresión de material publicitario.',
      avatarEmoji: '🖌️', color: AppColors.forSeed(4), isVerified: true, rating: 4.6, reviewCount: 24,
      plan: BusinessPlan.plus, respondsFast: true, salesCount: 40, lat: -17.7850, lng: -63.1700,
      links: const BusinessLinks(instagram: '@disenosprint', website: 'disenosprint.bo', whatsappPhone: '59177123456'),
      profileVisits: 690, linkClicks: 170, contactsGenerated: 46,
      products: const [
        Product(id: 'p29', businessId: 'b11', name: 'Diseño de logo', price: 250, description: '3 propuestas + archivos editables.', emoji: '🎨', isFeatured: true),
        Product(id: 'p30', businessId: 'b11', name: 'Catálogo digital (10 productos)', price: 180, description: 'Listo para compartir en redes.', emoji: '📄'),
      ],
      reviews: const [Review(id: 'r15', authorName: 'Natalia R.', rating: 4.5, comment: 'Muy creativos y cumplieron el plazo.', daysAgo: 7)],
    ),
    Business(
      id: 'b12', name: 'Boutique Luna', category: 'Ropa', department: 'La Paz', city: 'El Alto', zone: 'Ceja',
      tagline: 'Moda femenina accesible',
      description: 'Ropa de moda para mujer a precios accesibles. Nuevas colecciones cada mes.',
      avatarEmoji: '👗', color: AppColors.forSeed(0), rating: 4.2, reviewCount: 15, salesCount: 18,
      lat: -16.5100, lng: -68.1620,
      links: const BusinessLinks(instagram: '@boutiqueluna.elalto', tiktok: '@boutiqueluna', whatsappPhone: '59172345678'),
      profileVisits: 280, linkClicks: 60, contactsGenerated: 14,
      products: const [
        Product(id: 'p31', businessId: 'b12', name: 'Vestido casual', price: 110, description: 'Tela liviana, ideal para el día a día.', emoji: '👗', isFeatured: true),
        Product(id: 'p32', businessId: 'b12', name: 'Blusa de temporada', price: 65, description: 'Varios estampados disponibles.', emoji: '👚'),
      ],
      reviews: const [Review(id: 'r16', authorName: 'Carla M.', rating: 4, comment: 'Linda ropa y buenos precios.', daysAgo: 11)],
    ),

    // ——— Negocios nuevos: cubren Servicios y todos los departamentos ———
    Business(
      id: 'g1', name: 'GameZone Cochabamba', category: 'Tecnología', department: 'Cochabamba', city: 'Cochabamba', zone: 'Recoleta',
      tagline: 'Gaming, consolas y accesorios',
      description: 'Consolas, controles, juegos y accesorios gamer. Compra-venta de usados probados.',
      avatarEmoji: '🎮', color: AppColors.forSeed(2), isVerified: true, rating: 4.7, reviewCount: 51,
      plan: BusinessPlan.plus, respondsFast: true, shipsNationwide: true, salesCount: 72, lat: -17.3850, lng: -66.1600,
      links: const BusinessLinks(instagram: '@gamezone.cbba', tiktok: '@gamezone.cbba', whatsappPhone: '59177001122', mapsQuery: 'Recoleta, Cochabamba, Bolivia'),
      profileVisits: 2100, linkClicks: 640, contactsGenerated: 180,
      products: const [
        Product(id: 'g1a', businessId: 'g1', name: 'Control inalámbrico', price: 180, description: 'Bluetooth para PC y consola. Garantía.', emoji: '🎮', isFeatured: true),
        Product(id: 'g1b', businessId: 'g1', name: 'Audífonos gamer RGB', price: 150, description: 'Sonido envolvente, micrófono retráctil.', emoji: '🎧'),
        Product(id: 'g1c', businessId: 'g1', name: 'Teclado mecánico', price: 320, description: 'Switches azules, retroiluminado.', emoji: '⌨️'),
      ],
      reviews: const [Review(id: 'g1r', authorName: 'Bruno T.', rating: 5, comment: 'Excelente atención y precios.', daysAgo: 2)],
    ),
    Business(
      id: 's1', name: 'PowerFit Gym', category: 'Servicios', serviceType: 'Gimnasio', department: 'Santa Cruz', city: 'Santa Cruz', zone: 'Norte',
      tagline: 'Entrena con los mejores',
      description: 'Gimnasio equipado con máquinas de última generación, clases grupales y entrenadores certificados.',
      avatarEmoji: '🏋️', color: AppColors.forSeed(5), isVerified: true, rating: 4.8, reviewCount: 88,
      plan: BusinessPlan.pro, respondsFast: true, salesCount: 300, lat: -17.7600, lng: -63.1800,
      links: const BusinessLinks(instagram: '@powerfit.scz', tiktok: '@powerfit', whatsappPhone: '59170101010', mapsQuery: 'Zona Norte, Santa Cruz, Bolivia'),
      profileVisits: 4100, linkClicks: 1200, contactsGenerated: 420,
      products: const [
        Product(id: 's1a', businessId: 's1', name: 'Membresía mensual', price: 150, description: 'Acceso ilimitado + clases grupales.', emoji: '💪', isFeatured: true),
        Product(id: 's1b', businessId: 's1', name: 'Plan trimestral', price: 390, description: '3 meses con descuento.', emoji: '🏋️'),
        Product(id: 's1c', businessId: 's1', name: 'Entrenador personal (sesión)', price: 70, description: 'Rutina personalizada 1 a 1.', emoji: '🏃'),
      ],
      reviews: const [Review(id: 's1r', authorName: 'Mauricio P.', rating: 5, comment: 'Equipos nuevos y buen ambiente.', daysAgo: 3)],
    ),
    Business(
      id: 's2', name: 'Doña Rosa Comidas', category: 'Servicios', serviceType: 'Restaurante', department: 'Oruro', city: 'Oruro', zone: 'Centro',
      tagline: 'Sabor casero orureño',
      description: 'Restaurante de comida casera. Almuerzos, charque y rostro asado. Delivery disponible.',
      avatarEmoji: '🍲', color: AppColors.forSeed(1), rating: 4.6, reviewCount: 33, respondsFast: true, salesCount: 90,
      lat: -17.9833, lng: -67.1500,
      links: const BusinessLinks(instagram: '@donarosa.oruro', whatsappPhone: '59172020202', mapsQuery: 'Centro, Oruro, Bolivia'),
      profileVisits: 880, linkClicks: 230, contactsGenerated: 110,
      products: const [
        Product(id: 's2a', businessId: 's2', name: 'Almuerzo completo', price: 20, description: 'Sopa, segundo y refresco.', emoji: '🍲', isFeatured: true),
        Product(id: 's2b', businessId: 's2', name: 'Charquekan', price: 35, description: 'Plato típico orureño.', emoji: '🥩'),
      ],
      reviews: const [Review(id: 's2r', authorName: 'Elena V.', rating: 5, comment: 'Como la comida de casa.', daysAgo: 5)],
    ),
    Business(
      id: 's3', name: 'Plomería Rápida', category: 'Servicios', serviceType: 'Plomería', department: 'Cochabamba', city: 'Cochabamba', zone: 'Sarco',
      tagline: 'Emergencias 24/7',
      description: 'Instalación y reparación de cañerías, grifos, tanques y baños. Atención de emergencias.',
      avatarEmoji: '🔧', color: AppColors.forSeed(3), isVerified: true, rating: 4.7, reviewCount: 41, respondsFast: true, salesCount: 130,
      lat: -17.3950, lng: -66.1800,
      links: const BusinessLinks(whatsappPhone: '59173030303', facebook: 'PlomeriaRapidaCbba'),
      profileVisits: 1050, linkClicks: 410, contactsGenerated: 260,
      products: const [
        Product(id: 's3a', businessId: 's3', name: 'Visita + diagnóstico', price: 50, description: 'Evaluación a domicilio.', emoji: '🔧', isFeatured: true),
        Product(id: 's3b', businessId: 's3', name: 'Destape de cañería', price: 120, description: 'Con equipo profesional.', emoji: '🚰'),
      ],
      reviews: const [Review(id: 's3r', authorName: 'Raúl C.', rating: 5, comment: 'Llegó en 30 minutos, resolvió todo.', daysAgo: 1)],
    ),
    Business(
      id: 's4', name: 'Pintores Pro Tarija', category: 'Servicios', serviceType: 'Pintura', department: 'Tarija', city: 'Tarija', zone: 'Centro',
      tagline: 'Pintura de casas y empresas',
      description: 'Servicio de pintura interior y exterior, texturizados y acabados. Presupuesto gratis.',
      avatarEmoji: '🎨', color: AppColors.forSeed(4), rating: 4.5, reviewCount: 27, respondsFast: true, salesCount: 60,
      lat: -21.5355, lng: -64.7296,
      links: const BusinessLinks(instagram: '@pintorespro.tja', whatsappPhone: '59174040404', mapsQuery: 'Centro, Tarija, Bolivia'),
      profileVisits: 520, linkClicks: 150, contactsGenerated: 95,
      products: const [
        Product(id: 's4a', businessId: 's4', name: 'Pintura por m²', price: 25, description: 'Incluye material y mano de obra.', emoji: '🖌️', isFeatured: true),
        Product(id: 's4b', businessId: 's4', name: 'Texturizado decorativo', price: 60, description: 'Acabados especiales por m².', emoji: '🎨'),
      ],
      reviews: const [Review(id: 's4r', authorName: 'Gloria M.', rating: 4.5, comment: 'Trabajo limpio y puntual.', daysAgo: 12)],
    ),
    Business(
      id: 's5', name: 'Construcciones Andinas', category: 'Servicios', serviceType: 'Albañilería', department: 'Potosí', city: 'Potosí', zone: 'Centro',
      tagline: 'Obra fina y gruesa',
      description: 'Albañilería, obra fina y gruesa, remodelaciones y ampliaciones. Equipo con experiencia.',
      avatarEmoji: '🧱', color: AppColors.forSeed(5), rating: 4.4, reviewCount: 19, salesCount: 35,
      lat: -19.5836, lng: -65.7531,
      links: const BusinessLinks(whatsappPhone: '59175050505', facebook: 'ConstruccionesAndinasPotosi'),
      profileVisits: 390, linkClicks: 110, contactsGenerated: 70,
      products: const [
        Product(id: 's5a', businessId: 's5', name: 'Construcción por m²', price: 220, description: 'Obra gruesa, materiales aparte.', emoji: '🏗️', isFeatured: true),
        Product(id: 's5b', businessId: 's5', name: 'Remodelación de baño', price: 1500, description: 'Incluye acabados estándar.', emoji: '🚿'),
      ],
      reviews: const [Review(id: 's5r', authorName: 'Pedro Q.', rating: 4, comment: 'Cumplieron con el plazo acordado.', daysAgo: 25)],
    ),
    Business(
      id: 's6', name: 'Muebles del Sur', category: 'Casa', department: 'Chuquisaca', city: 'Sucre', zone: 'Centro',
      tagline: 'Muebles de madera a medida',
      description: 'Muebles de madera a medida: roperos, mesas, repisas y más. Diseño personalizado.',
      avatarEmoji: '🪑', color: AppColors.forSeed(2), isVerified: true, rating: 4.8, reviewCount: 36,
      plan: BusinessPlan.plus, shipsNationwide: true, salesCount: 50, lat: -19.0333, lng: -65.2627,
      links: const BusinessLinks(instagram: '@mueblesdelsur.sucre', whatsappPhone: '59176060606', mapsQuery: 'Centro, Sucre, Bolivia'),
      profileVisits: 720, linkClicks: 210, contactsGenerated: 120,
      products: const [
        Product(id: 's6a', businessId: 's6', name: 'Ropero 3 cuerpos', price: 1800, description: 'Madera mara, diseño a elección.', emoji: '🚪', isFeatured: true),
        Product(id: 's6b', businessId: 's6', name: 'Mesa de comedor 6 sillas', price: 2200, description: 'Madera maciza.', emoji: '🪑'),
      ],
      reviews: const [Review(id: 's6r', authorName: 'Andrea F.', rating: 5, comment: 'Acabado precioso, muy resistente.', daysAgo: 8)],
    ),
    Business(
      id: 's7', name: 'Amazonía Tech', category: 'Tecnología', department: 'Beni', city: 'Trinidad', zone: 'Centro',
      tagline: 'Soporte y venta de equipos',
      description: 'Venta y reparación de computadoras, redes e impresoras. Soporte a empresas del Beni.',
      avatarEmoji: '💻', color: AppColors.forSeed(0), rating: 4.5, reviewCount: 22, respondsFast: true, salesCount: 40,
      lat: -14.8333, lng: -64.9000,
      links: const BusinessLinks(instagram: '@amazoniatech.bni', whatsappPhone: '59177070707', mapsQuery: 'Centro, Trinidad, Bolivia'),
      profileVisits: 460, linkClicks: 130, contactsGenerated: 65,
      products: const [
        Product(id: 's7a', businessId: 's7', name: 'Mantenimiento de PC', price: 100, description: 'Limpieza, optimización y respaldo.', emoji: '🖥️', isFeatured: true),
        Product(id: 's7b', businessId: 's7', name: 'Instalación de red', price: 350, description: 'Cableado y configuración.', emoji: '🌐'),
      ],
      reviews: const [Review(id: 's7r', authorName: 'Luis A.', rating: 4.5, comment: 'Resolvieron el problema de mi red.', daysAgo: 6)],
    ),
    Business(
      id: 's8', name: 'Pando Natural', category: 'Alimentos', department: 'Pando', city: 'Cobija', zone: 'Centro',
      tagline: 'Productos amazónicos',
      description: 'Castaña, copoazú, açaí y productos naturales de la Amazonía boliviana. Envíos a todo el país.',
      avatarEmoji: '🌰', color: AppColors.forSeed(1), isVerified: true, rating: 4.9, reviewCount: 31,
      plan: BusinessPlan.plus, shipsNationwide: true, salesCount: 70, lat: -11.0267, lng: -68.7692,
      links: const BusinessLinks(instagram: '@pandonatural', tiktok: '@pandonatural', whatsappPhone: '59178080808', mapsQuery: 'Centro, Cobija, Bolivia'),
      profileVisits: 640, linkClicks: 200, contactsGenerated: 88,
      products: const [
        Product(id: 's8a', businessId: 's8', name: 'Castaña amazónica 500g', price: 45, description: 'Pelada y seleccionada.', emoji: '🌰', isFeatured: true),
        Product(id: 's8b', businessId: 's8', name: 'Pulpa de copoazú 1kg', price: 60, description: 'Congelada, 100% natural.', emoji: '🍈'),
      ],
      reviews: const [Review(id: 's8r', authorName: 'Carmen R.', rating: 5, comment: 'Productos frescos y bien empacados.', daysAgo: 4)],
    ),
  ];
}
