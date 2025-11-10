class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final List<dynamic> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      discountPercentage: json['discountPercentage'].toDouble(),
      images: json['images'],
    );
  }
}
