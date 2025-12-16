class CartItemModel {
  final int id;
  int quantity;
  final ProductModel product;

  CartItemModel({
    required this.id,
    required this.quantity,
    required this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      quantity: json['quantity'],
      product: ProductModel.fromJson(json['product']),
    );
  }
}

class ProductModel {
  final int id;
  final String name;
  final String? description;
  final String? price;
  final String? image;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
    );
  }
}