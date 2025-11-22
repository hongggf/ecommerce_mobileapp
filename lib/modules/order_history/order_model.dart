class OrderModel {
  final String id;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final DateTime orderDate;
  final String status; // 'delivered', 'processing', 'cancelled'
  final String trackingNumber;

  OrderModel({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.orderDate,
    required this.status,
    required this.trackingNumber,
  });

  String get formattedDate {
    return '${orderDate.day}/${orderDate.month}/${orderDate.year}';
  }

  String get statusText {
    switch (status) {
      case 'delivered':
        return 'Delivered';
      case 'processing':
        return 'Processing';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}