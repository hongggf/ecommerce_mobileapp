// lib/app/data/models/product_model.dart

class ProductModel {
  final int id;
  final String name;
  final String description;
  final String status;
  final int categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CategoryInfo? category;
  final List<ProductVariantModel>? variants;
  final List<ProductAssetModel>? assets;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.variants,
    this.assets,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      categoryId: json['category_id'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      category: json['category'] != null 
          ? CategoryInfo.fromJson(json['category']) 
          : null,
      variants: json['variants'] != null
          ? (json['variants'] as List)
              .map((v) => ProductVariantModel.fromJson(v))
              .toList()
          : null,
      assets: json['assets'] != null
          ? (json['assets'] as List)
              .map((a) => ProductAssetModel.fromJson(a))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'category_id': categoryId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'category': category?.toJson(),
      'variants': variants?.map((v) => v.toJson()).toList(),
      'assets': assets?.map((a) => a.toJson()).toList(),
    };
  }

  // Helper methods
  String get primaryImageUrl {
    if (assets != null && assets!.isNotEmpty) {
      final primary = assets!.firstWhere(
        (a) => a.isPrimary,
        orElse: () => assets!.first,
      );
      return primary.url;
    }
    return 'https://via.placeholder.com/300';
  }

  double get lowestPrice {
    if (variants != null && variants!.isNotEmpty) {
      return variants!
          .map((v) => v.price)
          .reduce((a, b) => a < b ? a : b);
    }
    return 0.0;
  }
}

// Category info within product
class CategoryInfo {
  final int id;
  final String name;
  final String slug;
  final String? description;

  CategoryInfo({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
    };
  }
}

// Product Variant Model
class ProductVariantModel {
  final int id;
  final int productId;
  final String name;
  final String sku;
  final double price;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductVariantModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.sku,
    required this.price,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      sku: json['sku'],
      price: (json['price'] as num).toDouble(),
      status: json['status'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'sku': sku,
      'price': price,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// Product Asset Model
class ProductAssetModel {
  final int id;
  final int productId;
  final int? variantId;
  final String url;
  final String kind;
  final bool isPrimary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductAssetModel({
    required this.id,
    required this.productId,
    this.variantId,
    required this.url,
    required this.kind,
    required this.isPrimary,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductAssetModel.fromJson(Map<String, dynamic> json) {
    return ProductAssetModel(
      id: json['id'],
      productId: json['product_id'],
      variantId: json['variant_id'],
      url: json['url'],
      kind: json['kind'],
      isPrimary: json['is_primary'] == 1 || json['is_primary'] == true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'variant_id': variantId,
      'url': url,
      'kind': kind,
      'is_primary': isPrimary,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}