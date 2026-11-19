/// Pedido: seguimiento de envío + verificación de entrega por QR.
enum OrderStage { pending, confirmed, preparing, shipped, inTransit, delivered }

extension OrderStageX on OrderStage {
  String get label => switch (this) {
        OrderStage.pending => 'Pedido recibido',
        OrderStage.confirmed => 'Confirmado',
        OrderStage.preparing => 'En preparación',
        OrderStage.shipped => 'Enviado',
        OrderStage.inTransit => 'En camino',
        OrderStage.delivered => 'Entregado',
      };

  String get hint => switch (this) {
        OrderStage.pending => 'El vendedor revisará tu pedido',
        OrderStage.confirmed => 'El vendedor confirmó tu pedido',
        OrderStage.preparing => 'Están preparando tu paquete',
        OrderStage.shipped => 'Tu paquete salió del negocio',
        OrderStage.inTransit => 'El repartidor va en camino',
        OrderStage.delivered => 'Entrega confirmada con QR',
      };
}

class OrderItem {
  final String productName;
  final double price;
  final int qty;
  const OrderItem({required this.productName, required this.price, this.qty = 1});
  double get total => price * qty;
}

class Order {
  final String id;
  final String code; // código corto para el QR de entrega
  final String businessId;
  final String businessName;
  final List<OrderItem> items;
  final String buyerName;
  OrderStage stage;
  final DateTime createdAt;
  final String deliveryMode; // 'envio' | 'encuentro'
  final String? meetingPointName;
  DateTime? deliveredAt;

  Order({
    required this.id,
    required this.code,
    required this.businessId,
    required this.businessName,
    required this.items,
    required this.buyerName,
    this.stage = OrderStage.pending,
    required this.createdAt,
    this.deliveryMode = 'envio',
    this.meetingPointName,
    this.deliveredAt,
  });

  double get total => items.fold(0.0, (s, i) => s + i.total);
  bool get isDelivered => stage == OrderStage.delivered;

  /// Contenido codificado dentro del QR de entrega.
  String get qrPayload => 'EKEKO|$code|$id';
}

/// Punto de encuentro seguro sugerido por departamento.
class MeetingPoint {
  final String name;
  final String department;
  final String city;
  final String note;
  final double? lat;
  final double? lng;
  const MeetingPoint({
    required this.name,
    required this.department,
    required this.city,
    required this.note,
    this.lat,
    this.lng,
  });
}

/// Mensaje de chat entre comprador y vendedor (local, sin backend).
class ChatMessage {
  final String text;
  final bool fromMe; // true = comprador (usuario), false = vendedor
  final DateTime at;
  const ChatMessage({required this.text, required this.fromMe, required this.at});
}
