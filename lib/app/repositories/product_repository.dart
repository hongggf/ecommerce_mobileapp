// // lib/app/repositories/product_repository.dart

// import 'package:ecommerce_urban/app/model/product_model.dart';
// import 'package:ecommerce_urban/app/services/base_http_service.dart';

// class ProductRepository extends BaseHttpService {
//   Future<Map<String, dynamic>> getProducts({
//     int page = 1,
//     int perPage = 15,
//     int? categoryId,
//   }) async {
//     try {
//       String endpoint;
      
//       // If category is specified, use category-specific endpoint
//       if (categoryId != null) {
//         // Try this format first: /categories/{id}/products
//         endpoint = '/categories/$categoryId/products?page=$page&per_page=$perPage';
//         print('🔍 Trying endpoint: $endpoint');
//       } else {
//         // All products
//         endpoint = '/products?page=$page&per_page=$perPage';
//       }
      
//       print('📦 Category ID: $categoryId');
      
//       final response = await get(endpoint);
      
//       print('✅ Response data count: ${(response['data'] as List).length}');
      
//       return {
//         'data': (response['data'] as List)
//             .map((json) => ProductModel.fromJson(json))
//             .toList(),
//         'current_page': response['current_page'],
//         'last_page': response['last_page'],
//         'total': response['total'],
//       };
//     } catch (e) {
//       print('❌ Error with category endpoint, trying query param...');
      
//       // Fallback: try query parameter approach
//       try {
//         String queryParams = '?page=$page&per_page=$perPage';
//         if (categoryId != null) {
//           queryParams += '&category_id=$categoryId';
//         }
        
//         print('🔍 Fallback endpoint: /products$queryParams');
//         final response = await get('/products$queryParams');
        
//         return {
//           'data': (response['data'] as List)
//               .map((json) => ProductModel.fromJson(json))
//               .toList(),
//           'current_page': response['current_page'],
//           'last_page': response['last_page'],
//           'total': response['total'],
//         };
//       } catch (e2) {
//         throw Exception('Failed to load products: $e2');
//       }
//     }
//   }

//   Future<ProductModel> getProductById(int id) async {
//     try {
//       final response = await get('/products/$id');
//       return ProductModel.fromJson(response);
//     } catch (e) {
//       throw Exception('Failed to load product: $e');
//     }
//   }

//   Future<List<ProductModel>> getPopularProducts({int limit = 10}) async {
//     try {
//       final response = await get('/products?per_page=$limit');
//       return (response['data'] as List)
//           .map((json) => ProductModel.fromJson(json))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to load popular products: $e');
//     }
//   }
  
//   Future<List<ProductModel>> getProductsByCategory({
//     required int categoryId,
//     int page = 1,
//     int perPage = 15,
//   }) async {
//     try {
//       final response = await get(
//         '/products?category_id=$categoryId&page=$page&per_page=$perPage',
//       );
      
//       return (response['data'] as List)
//           .map((json) => ProductModel.fromJson(json))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to load products by category: $e');
//     }
//   }
// }// lib/app/repositories/product_repository.dart

import 'package:ecommerce_urban/app/model/product_model.dart';
import 'package:ecommerce_urban/app/services/base_http_service.dart';

class ProductRepository extends BaseHttpService {

  /// MAIN METHOD — Now correctly loads by category (if given)
  Future<Map<String, dynamic>> getProducts({
    int page = 1,
    int perPage = 15,
    int? categoryId,
  }) async {
    try {
      String endpoint;

      // If category selected → use correct backend filter
      if (categoryId != null) {
        endpoint = '/products?category_id=$categoryId&page=$page&per_page=$perPage';
        print('🔍 Fetching by category: $endpoint');
      } else {
        endpoint = '/products?page=$page&per_page=$perPage';
        print('🔍 Fetching ALL products');
      }

      final response = await get(endpoint);

      return {
        'data': (response['data'] as List)
            .map((json) => ProductModel.fromJson(json))
            .toList(),
        'current_page': response['current_page'],
        'last_page': response['last_page'],
        'total': response['total'],
      };
    } catch (e) {
      throw Exception("Failed to load products: $e");
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await get('/products/$id');
      return ProductModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<List<ProductModel>> getPopularProducts({int limit = 10}) async {
    try {
      final response = await get('/products?per_page=$limit');
      return (response['data'] as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load popular products: $e');
    }
  }
}
