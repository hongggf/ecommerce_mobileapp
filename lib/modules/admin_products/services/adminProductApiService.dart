
import 'package:ecommerce_urban/app/constants/constants.dart';
import 'package:ecommerce_urban/app/services/storage_services.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_asset.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_varaint_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import '../model/category_model.dart';
import '../model/product_model.dart';

class Adminproductapiservice {
  static const String baseUrl = ApiConstants.baseUrl; // http://127.0.0.1:8000/api
  final StorageService _storage = StorageService();

  Adminproductapiservice();

  Future<String?> _getAuthToken() async {
    try {
      return await _storage.getToken();
    } catch (e) {
      print('❌ Error getting token: $e');
      return null;
    }
  }

  Future<dynamic> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      late http.Response response;

      final token = await _getAuthToken();

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      print('\n🔐 ========== API REQUEST ==========');
      print('METHOD: $method');
      print('URL: $url');
      print('TOKEN: ${token != null ? "Present" : "MISSING"}');
      if (body != null) print('BODY: ${jsonEncode(body)}');
      print('====================================\n');

      switch (method) {
        case 'GET':
          response = await http
              .get(url, headers: headers)
              .timeout(const Duration(seconds: 120));
          break;
        case 'POST':
          response = await http
              .post(
                url,
                headers: headers,
                body: jsonEncode(body),
              )
              .timeout(const Duration(seconds: 60));
          break;
        case 'PUT':
          response = await http
              .put(
                url,
                headers: headers,
                body: jsonEncode(body),
              )
              .timeout(const Duration(seconds: 60));
          break;
        case 'DELETE':
          response = await http
              .delete(url, headers: headers)
              .timeout(const Duration(seconds: 60));
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      print('\n🔐 ========== API RESPONSE ==========');
      print('STATUS: ${response.statusCode}');
      print('BODY LENGTH: ${response.body.length} bytes');

      if (response.body.isNotEmpty) {
        final preview = response.body.length > 300
            ? response.body.substring(0, 300) + '...(truncated)'
            : response.body;
        print('PREVIEW: $preview');
      }
      print('====================================\n');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          print('✅ Empty response (success)');
          return null;
        }

        try {
          final decoded = jsonDecode(response.body);
          print('✅ Response decoded successfully');
          return decoded;
        } catch (e) {
          print('❌ JSON PARSE ERROR: $e');
          throw FormatException(
              'Invalid JSON response. Status: ${response.statusCode}\nError: $e');
        }
      } else if (response.statusCode == 401) {
        print('❌ UNAUTHORIZED - Clearing token');
        await _storage.clearAuthData();
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You do not have permission');
      } else if (response.statusCode == 404) {
        throw Exception('Not found: Resource does not exist');
      } else if (response.statusCode == 500) {
        print('❌ SERVER ERROR: ${response.body}');
        throw Exception('Server error: ${response.body}');
      } else {
        print('❌ API ERROR ${response.statusCode}');
        throw Exception(
            'API Error: ${response.statusCode} - ${response.body.substring(0, 200)}');
      }
    } on TimeoutException {
      print('❌ REQUEST TIMEOUT');
      throw Exception('Request timeout: Server took too long');
    } on SocketException catch (e) {
      print('❌ NETWORK ERROR: $e');
      throw Exception('Network error: Check your connection');
    } on HttpException catch (e) {
      print('❌ HTTP ERROR: $e');
      throw Exception('HTTP error: $e');
    } on FormatException catch (e) {
      print('❌ FORMAT ERROR: $e');
      rethrow;
    } catch (e) {
      print('❌ UNEXPECTED ERROR: $e');
      throw Exception('Request failed: $e');
    }
  }

  // ============== HELPER: Safe List/Data Extraction ==============
  dynamic _getSafeData(dynamic response) {
    // If response is already a list, return it
    if (response is List) {
      print('✅ Response is a direct list with ${(response as List).length} items');
      return response;
    }
    
    // If response is a map, check for data key (Laravel pagination)
    if (response is Map) {
      // Check for 'data' key (Laravel pagination response)
      if (response['data'] != null) {
        print('✅ Response has data key with ${(response['data'] as List?)?.length ?? 0} items');
        return response['data'];
      }
      
      // Check if the whole response is the data
      if (response.containsKey('id')) {
        print('✅ Response is a single object');
        return response;
      }
    }
    
    print('⚠️ Could not extract data from response');
    return response;
  }

  // -----------------------
  // CATEGORIES
  // -----------------------
  Future<List<Category>> getCategories() async {
    try {
      print('📁 Fetching categories from /categories...');
      final response = await _makeRequest('GET', '/categories');

      final data = _getSafeData(response);
      
      if (data is! List) {
        print('⚠️ Response is not a list: $data');
        return [];
      }

      final categories = data
          .map((c) {
            try {
              return Category.fromJson(c as Map<String, dynamic>);
            } catch (e) {
              print('⚠️ Error parsing category: $e');
              return null;
            }
          })
          .whereType<Category>()
          .toList();

      print('✅ Categories loaded: ${categories.length}');
      return categories;
    } catch (e) {
      print('❌ Failed to fetch categories: $e');
      rethrow;
    }
  }

  Future<Category> createCategory(Category category) async {
    try {
      print('➕ Creating category: ${category.name}');
      final response = await _makeRequest(
        'POST',
        '/categories',
        body: category.toJson(),
      );
      print('✅ Category created: ID ${response['id']}');
      return Category.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('❌ Failed to create category: $e');
      rethrow;
    }
  }

  Future<Category> updateCategory(int id, Category category) async {
    try {
      print('🔄 Updating category: ID $id');
      final response = await _makeRequest(
        'PUT',
        '/categories/$id',
        body: category.toJson(),
      );
      print('✅ Category updated: ID $id');
      return Category.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('❌ Failed to update category: $e');
      rethrow;
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      print('🗑️ Deleting category: ID $id');
      await _makeRequest('DELETE', '/categories/$id');
      print('✅ Category deleted: ID $id');
    } catch (e) {
      print('❌ Failed to delete category: $e');
      rethrow;
    }
  }

  // -----------------------
  // PRODUCTS
  // -----------------------
 Future<List<Product>> getProducts() async {
  try {
    print('📦 Fetching products with pagination...');
    
    // Start with 10 per page to test
    final response = await _makeRequest(
      'GET', 
      '/products?per_page=10&page=1'
    );

    final data = _getSafeData(response);

    if (data is! List) {
      print('⚠️ Response is not a list: $data');
      return [];
    }

    print('✅ API returned ${(data as List).length} products');

    final products = data
        .map((p) {
          try {
            return Product.fromJson(p as Map<String, dynamic>);
          } catch (e) {
            print('⚠️ Error parsing product: $e');
            return null;
          }
        })
        .whereType<Product>()
        .toList();

    print('✅ Products loaded: ${products.length}');
    return products;
  } catch (e) {
    print('❌ Failed to fetch products: $e');
    rethrow;
  }
}

  Future<Product> createProduct(Product product) async {
    try {
      print('➕ Creating product: ${product.name}');
      final response = await _makeRequest(
        'POST',
        '/products',
        body: product.toJson(),
      );
      print('✅ Product created: ID ${response['id']}');
      return Product.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('❌ Failed to create product: $e');
      rethrow;
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    try {
      print('🔄 Updating product: ID $id');
      final response = await _makeRequest(
        'PUT',
        '/products/$id',
        body: product.toJson(),
      );
      print('✅ Product updated: ID $id');
      return Product.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('❌ Failed to update product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      print('🗑️ Deleting product: ID $id');
      await _makeRequest('DELETE', '/products/$id');
      print('✅ Product deleted: ID $id');
    } catch (e) {
      print('❌ Failed to delete product: $e');
      rethrow;
    }
  }

  // -----------------------
  // PRODUCT VARIANTS (Fixed: endpoint is /product-varaints not /product-variants)
  // -----------------------
  Future<List<ProductVariant>> getProductVariants(int productId) async {
    try {
      print('📋 Fetching variants for product $productId from /product-variants...');

      // Try to get variants with pagination to avoid truncation
      final response = await _makeRequest('GET', '/product-variants?per_page=100&page=1');

      final data = _getSafeData(response);

      if (data is! List) {
        print('⚠️ Response is not a list: $data');
        return [];
      }

      print('✅ API returned ${(data as List).length} total variants');

      // Filter to only this product's variants
      final variants = data
          .map((v) {
            try {
              final variantData = v as Map<String, dynamic>;
              
              // Convert price string to double if needed
              if (variantData['price'] is String) {
                variantData['price'] = double.parse(variantData['price'] as String);
              }
              
              return ProductVariant.fromJson(variantData);
            } catch (e) {
              print('⚠️ Error parsing variant: $e');
              print('   Raw data: $v');
              return null;
            }
          })
          .whereType<ProductVariant>()
          .where((v) => v.productId == productId)
          .toList();

      print('📊 Filtered to product $productId: ${variants.length} variants');
      if (variants.isNotEmpty) {
        variants.forEach((v) {
          print('   ✓ ${v.name} (ID: ${v.id}, ProductID: ${v.productId}, Price: ${v.price})');
        });
      }
      return variants;
    } catch (e) {
      print('⚠️ Failed to fetch variants: $e');
      return []; // Return empty list instead of crashing
    }
  }

  Future<ProductVariant> createProductVariant(ProductVariant variant) async {
    try {
      print('➕ Creating variant: ${variant.name}');
      final response = await _makeRequest(
        'POST',
        '/product-variants',
        body: variant.toJson(),
      );
      
      // Handle price as string
      var responseData = response as Map<String, dynamic>;
      if (responseData['price'] is String) {
        responseData['price'] = double.parse(responseData['price'] as String);
      }
      
      print('✅ Variant created: ID ${responseData['id']}');
      return ProductVariant.fromJson(responseData);
    } catch (e) {
      print('❌ Failed to create variant: $e');
      rethrow;
    }
  }

  Future<ProductVariant> updateProductVariant(
    int id,
    ProductVariant variant,
  ) async {
    try {
      print('🔄 Updating variant: ID $id');
      final response = await _makeRequest(
        'PUT',
        '/product-variants/$id',
        body: variant.toJson(),
      );
      
      // Handle price as string
      var responseData = response as Map<String, dynamic>;
      if (responseData['price'] is String) {
        responseData['price'] = double.parse(responseData['price'] as String);
      }
      
      print('✅ Variant updated: ID $id');
      return ProductVariant.fromJson(responseData);
    } catch (e) {
      print('❌ Failed to update variant: $e');
      rethrow;
    }
  }

  Future<void> deleteProductVariant(int id) async {
    try {
      print('🗑️ Deleting variant: ID $id');
      await _makeRequest('DELETE', '/product-variants/$id');
      print('✅ Variant deleted: ID $id');
    } catch (e) {
      print('❌ Failed to delete variant: $e');
      rethrow;
    }
  }

  // -----------------------
  // PRODUCT ASSETS
  // -----------------------
 // In your adminProductApiService.dart file
// Find the getProductAssets method and REPLACE it with this:

Future<List<ProductAsset>> getProductAssets(int productId) async {
  try {
    // ✅ CORRECT ENDPOINT: /product-assets/product/{product_id}
    print('🖼️ Fetching assets for product $productId from /product-assets/product/$productId...');

    final response = await _makeRequest('GET', '/product-assets/product/$productId');

    final data = _getSafeData(response);

    if (data is! List) {
      print('⚠️ Response is not a list: $data');
      return [];
    }

    final assets = data
        .map((a) {
          try {
            final assetData = a as Map<String, dynamic>;
            
            print('   📦 Asset ${assetData['id']}:');
            print('      - url: ${assetData['url']}');
            print('      - has base64_file: ${assetData.containsKey('base64_file')}');
            
            return ProductAsset.fromJson(assetData);
          } catch (e) {
            print('⚠️ Error parsing asset: $e');
            return null;
          }
        })
        .whereType<ProductAsset>()
        .toList();

    print('✅ Assets loaded: ${assets.length}');
    if (assets.isNotEmpty) {
      assets.forEach((a) {
        print('   ✓ Asset ID: ${a.id}, URL: ${a.url}');
      });
    }
    return assets;
  } catch (e) {
    print('❌ Failed to fetch assets: $e');
    return [];
  }
}

  Future<ProductAsset> uploadProductAsset(
    File imageFile,
    int productId,
    int variantId, {
    bool isPrimary = false,
  }) async {
    try {
      print('📤 Uploading asset for product $productId, variant $variantId...');
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final mimeType = _getMimeType(imageFile.path);
      final base64File = 'data:$mimeType;base64,$base64Image';

      final response = await _makeRequest(
        'POST',
        '/product-assets',
        body: {
          'product_id': productId,
          'variant_id': variantId,
          'base64_file': base64File,
          'kind': 'image',
          'is_primary': isPrimary,
        },
      );
      print('✅ Asset uploaded: ID ${response['id']}');
      return ProductAsset.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('❌ Failed to upload asset: $e');
      rethrow;
    }
  }
  // Add this method to AdminProductApiService class

/// Get base64 for a single asset (only when needed for display)
Future<String?> getAssetBase64(int assetId) async {
  try {
    print('🖼️ Fetching base64 for asset $assetId...');
    
    final response = await _makeRequest('GET', '/product-assets/$assetId');
    
    if (response is Map && response['base64_file'] != null) {
      final base64 = response['base64_file'] as String;
      print('✅ Base64 fetched: ${base64.length} chars');
      return base64;
    }
    
    print('⚠️ No base64 available for asset $assetId');
    return null;
  } catch (e) {
    print('❌ Failed to fetch base64: $e');
    return null;
  }
}

  Future<void> deleteProductAsset(int id) async {
    try {
      print('🗑️ Deleting asset: ID $id');
      await _makeRequest('DELETE', '/product-assets/$id');
      print('✅ Asset deleted: ID $id');
    } catch (e) {
      print('❌ Failed to delete asset: $e');
      rethrow;
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