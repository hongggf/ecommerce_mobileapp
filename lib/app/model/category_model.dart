// lib/app/data/models/category_model.dart

class CategoryModel {
  final int id;
  final int? parentId;
  final String slug;
  final String name;
  final String? description;
  final int? position;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CategoryModel>? children;

  CategoryModel({
    required this.id,
    this.parentId,
    required this.slug,
    required this.name,
    this.description,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      parentId: json['parent_id'],
      slug: json['slug'],
      name: json['name'],
      description: json['description'],
      position: json['position'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      children: json['children'] != null
          ? (json['children'] as List)
              .map((child) => CategoryModel.fromJson(child))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'slug': slug,
      'name': name,
      'description': description,
      'position': position,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'children': children?.map((child) => child.toJson()).toList(),
    };
  }
}