class ReportData {
  final List<String> labels;
  final List<num> values;

  ReportData({required this.labels, required this.values});

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      labels: List<String>.from(json['labels'] ?? []),
      values: List<num>.from(json['values'] ?? []),
    );
  }
}

class StockLevel {
  final String product;
  final int stockQuantity;

  StockLevel({required this.product, required this.stockQuantity});

  factory StockLevel.fromJson(Map<String, dynamic> json) {
    return StockLevel(
      product: json['product'],
      stockQuantity: json['stock_quantity'],
    );
  }
}

class ProductSalesByPeriod {
  final String period;
  final ReportData data;

  ProductSalesByPeriod({required this.period, required this.data});

  factory ProductSalesByPeriod.fromJson(Map<String, dynamic> json) {
    return ProductSalesByPeriod(
      period: json['period'],
      data: ReportData.fromJson(json['data']),
    );
  }
}