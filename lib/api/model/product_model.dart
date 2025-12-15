class ProductModel {
  final int id;
  final String name;
  final String description;
  final String price;
  final String? comparePrice;
  final String image;
  final int stockQuantity;
  final int lowStockAlert;
  final String status;
  final String createdAt;

  final CategoryModel category;
  final UserModel creator;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.comparePrice,
    required this.image,
    required this.stockQuantity,
    required this.lowStockAlert,
    required this.status,
    required this.createdAt,
    required this.category,
    required this.creator,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: json['price'].toString(),
      comparePrice: json['compare_price']?.toString(),
      image: json['image'] ?? '',
      stockQuantity: json['stock_quantity'] ?? 0,
      lowStockAlert: json['low_stock_alert'] ?? 0,
      status: json['status'] ?? 'inactive',
      createdAt: json['created_at'] ?? '',
      category: CategoryModel.fromJson(json['category']),
      creator: UserModel.fromJson(json['creator']),
    );
  }
}

class CategoryModel {
  final int id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}