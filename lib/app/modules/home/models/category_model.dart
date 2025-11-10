class CategoryModel {
  final String name;

  CategoryModel({required this.name});

  factory CategoryModel.fromJson(dynamic json) {
    return CategoryModel(name: json.toString());
  }
}
