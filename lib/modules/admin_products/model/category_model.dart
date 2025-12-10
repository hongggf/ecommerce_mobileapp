class Category {
  final int? id;
  final int? parentId;
 
  final String name;
  final String? description;
  

  Category({
    this.id,
    this.parentId,
    
    required this.name,
    this.description,
    
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      parentId: json['parent_id'],
     
      name: json['name'],
      description: json['description'],
    
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentId,
      
      'name': name,
      'description': description,
      
    };
  }
}