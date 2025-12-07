class ShipmentModel {
  final int? id;
  final int orderId;
  final String trackingNumber;
  final String carrier;
  final String status;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShipmentModel({
    this.id,
    required this.orderId,
    required this.trackingNumber,
    required this.carrier,
    required this.status,
    this.shippedAt,
    this.deliveredAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      id: json['id'],
      orderId: json['order_id'] ?? 0,
      trackingNumber: json['tracking_number'] ?? '',
      carrier: json['carrier'] ?? '',
      status: json['status'] ?? '',
      shippedAt: json['shipped_at'] != null 
          ? DateTime.parse(json['shipped_at']) 
          : null,
      deliveredAt: json['delivered_at'] != null 
          ? DateTime.parse(json['delivered_at']) 
          : null,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'order_id': orderId,
      'tracking_number': trackingNumber,
      'carrier': carrier,
      'status': status,
      if (shippedAt != null) 'shipped_at': shippedAt!.toIso8601String(),
      if (deliveredAt != null) 'delivered_at': deliveredAt!.toIso8601String(),
    };
  }
}

class CreateShipmentRequest {
  final int orderId;
  final String trackingNumber;
  final String carrier;
  final String status;

  CreateShipmentRequest({
    required this.orderId,
    required this.trackingNumber,
    required this.carrier,
    this.status = 'packed',
  });

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'tracking_number': trackingNumber,
      'carrier': carrier,
      'status': status,
    };
  }
}

class UpdateShipmentRequest {
  final String? status;
  final String? trackingNumber;
  final String? carrier;

  UpdateShipmentRequest({
    this.status,
    this.trackingNumber,
    this.carrier,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (status != null) map['status'] = status;
    if (trackingNumber != null) map['tracking_number'] = trackingNumber;
    if (carrier != null) map['carrier'] = carrier;
    return map;
  }
}

class MarkShippedRequest {
  final String trackingNumber;
  final String carrier;

  MarkShippedRequest({
    required this.trackingNumber,
    required this.carrier,
  });

  Map<String, dynamic> toJson() {
    return {
      'tracking_number': trackingNumber,
      'carrier': carrier,
    };
  }
}