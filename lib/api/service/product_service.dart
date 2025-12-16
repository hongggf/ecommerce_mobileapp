import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ecommerce_urban/api/model/product_model.dart';
import 'package:ecommerce_urban/app/constants/app_constant.dart';
import 'package:ecommerce_urban/app/services/dio_service.dart';

class ProductService {
  final Dio _dio = DioService.dio;

  /// GET PRODUCTS (search + sort + pagination)
  Future<List<ProductModel>> getProducts({
    String? search,
    String? sort,
    int? categoryId, // <-- added
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _dio.get(
      AppConstant.products,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
        if (categoryId != null) 'category_id': categoryId, // <-- added
        'page': page,
        'per_page': perPage,
      },
    );

    final List list = response.data['data']['data'];
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }

  /// CREATE
  Future<void> createProduct({
    required String name,
    required int categoryId,
    required String description,
    required String price,
    required String comparePrice,
    required File image,
    required String status,
    required int stockQuantity,
    required int lowStockAlert,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'category_id': categoryId,
      'description': description,
      'price': price,
      'compare_price': comparePrice,
      'status': status,
      'stock_quantity': stockQuantity,
      'low_stock_alert': lowStockAlert,
      'image': await MultipartFile.fromFile(image.path, filename: image.path.split('/').last,),
    });

    await _dio.post(AppConstant.products, data: formData);
  }

  /// UPDATE
  Future<void> updateProduct(
      int id, {
        required String name,
        required int categoryId,
        required String description,
        required String price,
        required String comparePrice,
        File? image,
        required String status,
        required int stockQuantity,
        required int lowStockAlert,
      }) async {
    final map = {
      'name': name,
      'category_id': categoryId,
      'description': description,
      'price': price,
      'compare_price': comparePrice,
      'status': status,
      'stock_quantity': stockQuantity,
      'low_stock_alert': lowStockAlert,
    };

    if (image != null) {
      map['image'] = await MultipartFile.fromFile(image.path);
    }

    await _dio.put(
      AppConstant.productById(id), // Use PUT for update
      data: FormData.fromMap(map),
    );
  }

  /// DELETE
  Future<void> deleteProduct(int id) async {
    await _dio.delete(AppConstant.productById(id));
  }

  /// Get Product except stock_quantity = 0
  Future<List<ProductModel>> getAvailableProducts({
    String? search,
    String? sort,
    int? categoryId,
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _dio.get(
      AppConstant.availableProducts,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
        if (categoryId != null) 'category_id': categoryId,
        'page': page,
        'per_page': perPage,
      },
    );

    final List list = response.data['data']['data'];

    return list.map((e) => ProductModel.fromJson(e)).toList();
  }
}