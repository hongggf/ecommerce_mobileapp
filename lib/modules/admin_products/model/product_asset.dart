class ProductAsset {
  final int? id;
  final int? productId;
  final int? productVariantId;
  final String base64File;
  final String kind;
  final bool isPrimary;

  ProductAsset({
    this.id,
    this.productId,
    this.productVariantId,
    required this.base64File,
    required this.kind,
    required this.isPrimary,
  });

  factory ProductAsset.fromJson(Map<String, dynamic> json) {
    return ProductAsset(
      id: json['id'],
      productId: json['product_id'],
      productVariantId: json['product_variant_id'],
      base64File: json['base64_file'] ?? '',
      kind: json['kind'] ?? 'image',
      isPrimary: json['is_primary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'base64_file': base64File,
      'kind': kind,
      'is_primary': isPrimary,
    };
  }
}