// import 'package:ecommerce_urban/app/constants/constants.dart';
// import 'package:ecommerce_urban/modules/admin_products/model/product_asset.dart';
// import 'package:ecommerce_urban/modules/admin_products/model/product_varaint_model.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';

// import '../model/category_model.dart';
// import '../model/product_model.dart';

// class ApiService {
//   // Change to your HTTPS domain
//   static const String baseUrl = ApiConstants.baseUrl;

//   // For local testing with HTTP:
//   // static const String baseUrl = 'http://10.0.2.2:8000/api';

//   ApiService();

//   // Helper method to make HTTP requests with error handling
//   Future<Map<String, dynamic>> _makeRequest(
//     String method,
//     String endpoint, {
//     Map<String, dynamic>? body,
//   }) async {
//     try {
//       final url = Uri.parse('$baseUrl$endpoint');
//       late http.Response response;

//       final headers = {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       };

//       switch (method) {
//         case 'GET':
//           response = await http.get(url, headers: headers);
//           break;
//         case 'POST':
//           response = await http.post(
//             url,
//             headers: headers,
//             body: jsonEncode(body),
//           );
//           break;
//         case 'PUT':
//           response = await http.put(
//             url,
//             headers: headers,
//             body: jsonEncode(body),
//           );
//           break;
//         case 'DELETE':
//           response = await http.delete(url, headers: headers);
//           break;
//         default:
//           throw Exception('Unsupported HTTP method: $method');
//       }

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception(
//           'API Error: ${response.statusCode} - ${response.body}',
//         );
//       }
//     } on SocketException catch (e) {
//       throw Exception('Network error: $e');
//     } on HttpException catch (e) {
//       throw Exception('HTTP error: $e');
//     } catch (e) {
//       throw Exception('Request failed: $e');
//     }
//   }

//   // CATEGORIES
//   Future<List<Category>> getCategories() async {
//     try {
//       final response = await _makeRequest('GET', '/categories');
//       List<Category> categories = (response is List)
//           ? List<Category>.from(
//               response.map((c) => Category.fromJson(c as Map<String, dynamic>)))
//           : List<Category>.from((response['data'] as List)
//               .map((c) => Category.fromJson(c as Map<String, dynamic>)));
//       return categories;
//     } catch (e) {
//       throw Exception('Failed to fetch categories: $e');
//     }
//   }

//   Future<Category> createCategory(Category category) async {
//     try {
//       final response = await _makeRequest(
//         'POST',
//         '/categories',
//         body: category.toJson(),
//       );
//       return Category.fromJson(response);
//     } catch (e) {
//       throw Exception('Failed to create category: $e');
//     }
//   }

//   Future<Category> updateCategory(int id, Category category) async {
//     try {
//       final response = await _makeRequest(
//         'PUT',
//         '/categories/$id',
//         body: category.toJson(),
//       );
//       return Category.fromJson(response);
//     } catch (e) {
//       throw Exception('Failed to update category: $e');
//     }
//   }

//   Future<void> deleteCategory(int id) async {
//     try {
//       await _makeRequest('DELETE', '/categories/$id');
//     } catch (e) {
//       throw Exception('Failed to delete category: $e');
//     }
//   }

//   // PRODUCTS
//   Future<List<Product>> getProducts() async {
//     try {
//       final response = await _makeRequest('GET', '/products');
//       List<Product> products = (response is List)
//           ? List<Product>.from(
//               response.map((p) => Product.fromJson(p as Map<String, dynamic>)))
//           : List<Product>.from((response['data'] as List)
//               .map((p) => Product.fromJson(p as Map<String, dynamic>)));
//       return products;
//     } catch (e) {
//       throw Exception('Failed to fetch products: $e');
//     }
//   }

//   Future<Product> createProduct(Product product) async {
//     try {
//       final response = await _makeRequest(
//         'POST',
//         '/products',
//         body: product.toJson(),
//       );
//       return Product.fromJson(response);
//     } catch (e) {
//       throw Exception('Failed to create product: $e');
//     }
//   }

//   Future<Product> updateProduct(int id, Product product) async {
//     try {
//       final response = await _makeRequest(
//         'PUT',
//         '/products/$id',
//         body: product.toJson(),
//       );
//       return Product.fromJson(response);
//     } catch (e) {
//       throw Exception('Failed to update product: $e');
//     }
//   }

//   Future<void> deleteProduct(int id) async {
//     try {
//       await _makeRequest('DELETE', '/products/$id');
//     } catch (e) {
//       throw Exception('Failed to delete product: $e');
//     }
//   }

//   // PRODUCT VARIANTS
//   Future<List<ProductVariant>> getProductVariants(int productId) async {
//     try {
//       final response =
//           await _makeRequest('GET', '/products/$productId/variants');
//       List<ProductVariant> variants = (response is List)
//           ? List<ProductVariant>.from(response
//               .map((v) => ProductVariant.fromJson(v as Map<String, dynamic>)))
//           : List<ProductVariant>.from((response['data'] as List)
//               .map((v) => ProductVariant.fromJson(v as Map<String, dynamic>)));
//       return variants;
//     } catch (e) {
//       throw Exception('Failed to fetch variants: $e');
//     }
//   }

//   Future<ProductVariant> createProductVariant(ProductVariant variant) async {
//     try {
//       final response = await _makeRequest(
//         'POST',
//         '/product-variants',
//         body: variant.toJson(),
//       );
//       return ProductVariant.fromJson(response);
//     } catch (e) {
//       throw Exception('Failed to create variant: $e');
//     }
//   }

//   Future<ProductVariant> updateProductVariant(
//     int id,
//     ProductVariant variant,
//   ) async {
//     try {
//       final response = await _makeRequest(
//         'PUT',
//         '/product-variants/$id',
//         body: variant.toJson(),
//       );
//       return ProductVariant.fromJson(response);
//     } catch (e) {
//       throw Exception('Failed to update variant: $e');
//     }
//   }

//   Future<void> deleteProductVariant(int id) async {
//     try {
//       await _makeRequest('DELETE', '/product-variants/$id');
//     } catch (e) {
//       throw Exception('Failed to delete variant: $e');
//     }
//   }

//   // PRODUCT ASSETS
//   Future<List<ProductAsset>> getProductAssets(int productId) async {
//     try {
//       final response = await _makeRequest('GET', '/products/$productId/assets');
//       List<ProductAsset> assets = (response is List)
//           ? List<ProductAsset>.from(response
//               .map((a) => ProductAsset.fromJson(a as Map<String, dynamic>)))
//           : List<ProductAsset>.from((response['data'] as List)
//               .map((a) => ProductAsset.fromJson(a as Map<String, dynamic>)));
//       return assets;
//     } catch (e) {
//       throw Exception('Failed to fetch assets: $e');
//     }
//   }

//   Future<ProductAsset> uploadProductAsset(
//     File imageFile,
//     int productId, {
//     bool isPrimary = false,
//   }) async {
//     try {
//       final bytes = await imageFile.readAsBytes();
//       final base64Image = base64Encode(bytes);
//       final mimeType = _getMimeType(imageFile.path);
//       final base64File = 'data:$mimeType;base64,$base64Image';

//       final response = await _makeRequest(
//         'POST',
//         '/product-assets',
//         body: {
//           'product_id': productId,
//           'base64_file': base64File,
//           'kind': 'image',
//           'is_primary': isPrimary,
//         },
//       );
//       return ProductAsset.fromJson(response);
//     } catch (e) {
//       throw Exception('Failed to upload asset: $e');
//     }
//   }

//   Future<void> deleteProductAsset(int id) async {
//     try {
//       await _makeRequest('DELETE', '/product-assets/$id');
//     } catch (e) {
//       throw Exception('Failed to delete asset: $e');
//     }
//   }

//   String _getMimeType(String filePath) {
//     if (filePath.endsWith('.png')) return 'image/png';
//     if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) {
//       return 'image/jpeg';
//     }
//     if (filePath.endsWith('.gif')) return 'image/gif';
//     if (filePath.endsWith('.webp')) return 'image/webp';
//     return 'image/jpeg';
//   }
// }
import 'package:ecommerce_urban/app/constants/constants.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_asset.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_varaint_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../model/category_model.dart';
import '../model/product_model.dart';

class Adminproductapiservice {
  static const String baseUrl = ApiConstants.baseUrl;

  Adminproductapiservice();

  // FIXED: return type is now dynamic (supports Map or List)
  Future<dynamic> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      late http.Response response;

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      switch (method) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'API Error: ${response.statusCode} - ${response.body}',
        );
      }
    } on SocketException catch (e) {
      throw Exception('Network error: $e');
    } on HttpException catch (e) {
      throw Exception('HTTP error: $e');
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  // -----------------------
  // CATEGORIES
  // -----------------------
  Future<List<Category>> getCategories() async {
    try {
      final response = await _makeRequest('GET', '/categories');

      List dataList = (response is List) ? response : response['data'];

      return dataList
          .map((c) => Category.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<Category> createCategory(Category category) async {
    try {
      final response = await _makeRequest(
        'POST',
        '/categories',
        body: category.toJson(),
      );
      return Category.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  Future<Category> updateCategory(int id, Category category) async {
    try {
      final response = await _makeRequest(
        'PUT',
        '/categories/$id',
        body: category.toJson(),
      );
      return Category.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _makeRequest('DELETE', '/categories/$id');
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  // -----------------------
  // PRODUCTS
  // -----------------------
  Future<List<Product>> getProducts() async {
    try {
      final response = await _makeRequest('GET', '/products');

      List dataList = (response is List) ? response : response['data'];

      return dataList
          .map((p) => Product.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      final response = await _makeRequest(
        'POST',
        '/products',
        body: product.toJson(),
      );
      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    try {
      final response = await _makeRequest(
        'PUT',
        '/products/$id',
        body: product.toJson(),
      );
      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _makeRequest('DELETE', '/products/$id');
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // -----------------------
  // PRODUCT VARIANTS
  // -----------------------
  Future<List<ProductVariant>> getProductVariants(int productId) async {
    try {
      final response =
          await _makeRequest('GET', '/products/$productId/variants');

      List dataList = (response is List) ? response : response['data'];

      return dataList
          .map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch variants: $e');
    }
  }

  Future<ProductVariant> createProductVariant(ProductVariant variant) async {
    try {
      final response = await _makeRequest(
        'POST',
        '/product-variants',
        body: variant.toJson(),
      );
      return ProductVariant.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create variant: $e');
    }
  }

  Future<ProductVariant> updateProductVariant(
    int id,
    ProductVariant variant,
  ) async {
    try {
      final response = await _makeRequest(
        'PUT',
        '/product-variants/$id',
        body: variant.toJson(),
      );
      return ProductVariant.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update variant: $e');
    }
  }

  Future<void> deleteProductVariant(int id) async {
    try {
      await _makeRequest('DELETE', '/product-variants/$id');
    } catch (e) {
      throw Exception('Failed to delete variant: $e');
    }
  }

  // -----------------------
  // PRODUCT ASSETS
  // -----------------------
  Future<List<ProductAsset>> getProductAssets(int productId) async {
    try {
      final response =
          await _makeRequest('GET', '/products/$productId/assets');

      List dataList = (response is List) ? response : response['data'];

      return dataList
          .map((a) => ProductAsset.fromJson(a as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch assets: $e');
    }
  }

  Future<ProductAsset> uploadProductAsset(
    File imageFile,
    int productId, {
    bool isPrimary = false,
  }) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final mimeType = _getMimeType(imageFile.path);

      final base64File = 'data:$mimeType;base64,$base64Image';

      final response = await _makeRequest(
        'POST',
        '/product-assets',
        body: {
          'product_id': productId,
          'base64_file': base64File,
          'kind': 'image',
          'is_primary': isPrimary,
        },
      );
      return ProductAsset.fromJson(response);
    } catch (e) {
      throw Exception('Failed to upload asset: $e');
    }
  }

  Future<void> deleteProductAsset(int id) async {
    try {
      await _makeRequest('DELETE', '/product-assets/$id');
    } catch (e) {
      throw Exception('Failed to delete asset: $e');
    }
  }

  String _getMimeType(String filePath) {
    if (filePath.endsWith('.png')) return 'image/png';
    if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) {
      return 'image/jpeg';
    }
    if (filePath.endsWith('.gif')) return 'image/gif';
    if (filePath.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
