// lib/models/product_model.dart
import 'package:ecommerce_urban/modules/admin_products/model/product_varaint_model.dart';

class Product {
  final int? id;
  final String name;
  final String description;
  final String status;
  final int categoryId;
  final List<ProductVariant>? variants;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.categoryId,
    this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'] ?? 'active',
      categoryId: json['category_id'],
      variants: (json['variants'] as List?)
          ?.map((v) => ProductVariant.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'category_id': categoryId,
    };
  }
}