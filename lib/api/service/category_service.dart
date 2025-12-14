import 'package:dio/dio.dart';
import 'package:ecommerce_urban/api/model/category_model.dart';
import 'package:ecommerce_urban/app/constants/app_constant.dart';
import 'package:ecommerce_urban/app/services/dio_service.dart';

class CategoryService {
  final Dio _dio = DioService.dio;

  /// GET all categories
  Future<List<CategoryData>> getCategories({String? search, String? sort}) async {
    try {
      final response = await _dio.get(AppConstant.categories, queryParameters: {
        if (search != null) 'search': search,
        if (sort != null) 'sort': sort,
      });

      return CategoryModel.fromJson(response.data).data ?? [];
    } catch (e) {
      throw Exception("Failed to load categories");
    }
  }

  /// CREATE
  Future<CategoryData> createCategory({required String name, required String slug}) async {
    try {
      final response = await _dio.post(AppConstant.categories, data: {
        "name": name,
        "slug": slug,
      });

      return CategoryModel.fromJson(response.data).data!.first;
    } catch (e) {
      throw Exception("Failed to create category");
    }
  }

  /// UPDATE
  Future<CategoryData> updateCategory({required int id, required String name, required String slug}) async {
    try {
      final response = await _dio.put(AppConstant.categoryById(id), data: {
        "name": name,
        "slug": slug,
      });

      return CategoryModel.fromJson(response.data).data!.first;
    } catch (e) {
      throw Exception("Failed to update category");
    }
  }

  /// DELETE
  Future<void> deleteCategory(int id) async {
    try {
      await _dio.delete(AppConstant.categoryById(id));
    } catch (e) {
      throw Exception("Failed to delete category");
    }
  }
}