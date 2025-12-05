class Category {
  final int? id;
  final int? parentId;
  final String slug;
  final String name;
  final String? description;
  final int position;

  Category({
    this.id,
    this.parentId,
    required this.slug,
    required this.name,
    this.description,
    required this.position,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      parentId: json['parent_id'],
      slug: json['slug'],
      name: json['name'],
      description: json['description'],
      position: json['position'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentId,
      'slug': slug,
      'name': name,
      'description': description,
      'position': position,
    };
  }
}