class CategoryModel {
  bool? success;
  String? message;
  List<CategoryData>? data;

  CategoryModel({this.success, this.message, this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.map((v) => v.toJson()).toList(),
  };
}

class CategoryData {
  int? id;
  String? name;
  String? slug;
  int? createdBy;
  Creator? creator;
  String? createdAt;
  String? updatedAt;

  CategoryData({
    this.id,
    this.name,
    this.slug,
    this.createdBy,
    this.creator,
    this.createdAt,
    this.updatedAt,
  });

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    createdBy = json['created_by'];
    creator = json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'created_by': createdBy,
    'creator': creator?.toJson(),
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

class Creator {
  int? id;
  String? name;
  String? email;

  Creator({this.id, this.name, this.email});

  Creator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}