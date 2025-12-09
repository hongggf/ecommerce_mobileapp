import 'package:ecommerce_urban/app/model/category_model.dart';
import 'package:ecommerce_urban/app/services/base_http_service.dart';



class CategoryRepository extends BaseHttpService {
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await get('/categories');
      return (response as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<CategoryModel> getCategoryById(int id) async {
    try {
      final response = await get('/categories/$id');
      return CategoryModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load category: $e');
    }
  }
}
