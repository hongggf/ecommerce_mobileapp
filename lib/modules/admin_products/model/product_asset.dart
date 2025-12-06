class ProductAsset {
  final int? id;
  final int? productId;
  final int? variantId;
  final String? url;
  final String? base64File;
  final String kind;
  final bool isPrimary;
  final String? createdAt;
  final String? updatedAt;

  ProductAsset({
    this.id,
    this.productId,
    this.variantId,
    this.url,
    this.base64File,
    required this.kind,
    this.isPrimary = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductAsset.fromJson(Map<String, dynamic> json) {
    final asset = ProductAsset(
      id: json['id'] as int?,
      productId: json['product_id'] as int?,
      variantId: json['variant_id'] as int?,
      url: json['url'] as String?,
      base64File: json['base64_file'] as String?,
      kind: json['kind'] as String? ?? 'image',
      isPrimary: json['is_primary'] == true || json['is_primary'] == 1,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
    
    print('📦 Parsed Asset:');
    print('   ID: ${asset.id}');
    print('   URL: ${asset.url}');
    print('   Has base64: ${asset.base64File != null && asset.base64File!.isNotEmpty}');
    print('   Base64 length: ${asset.base64File?.length ?? 0}');
    print('   Is Primary: ${asset.isPrimary}');
    
    return asset;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'variant_id': variantId,
      'url': url,
      'base64_file': base64File,
      'kind': kind,
      'is_primary': isPrimary,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'ProductAsset(id: $id, url: $url, isPrimary: $isPrimary, hasBase64: ${base64File != null && base64File!.isNotEmpty})';
  }
}