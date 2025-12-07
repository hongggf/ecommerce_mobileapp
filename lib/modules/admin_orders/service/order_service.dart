// import 'dart:convert';
// import 'package:ecommerce_urban/modules/admin_orders/model/order_items_model.dart';
// import 'package:ecommerce_urban/modules/admin_orders/model/order_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:ecommerce_urban/app/constants/constants.dart';
// import 'package:ecommerce_urban/app/services/storage_services.dart';

// class OrderService {
//   final StorageService storage = StorageService();

//   Future<String?> getToken() async {
//     return await storage.getToken();
//   }

//   Future<Map<String, String>> getHeaders() async {
//     final token = await getToken();
//     return {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': 'Bearer ${token ?? ''}',
//     };
//   }

//   // Get all orders
//   Future<List<Order>> getAllOrders() async {
//     try {
//       final headers = await getHeaders();
//       final response = await http.get(
//         Uri.parse('${ApiConstants.baseUrl}/orders'),
//         headers: headers,
//       ).timeout(const Duration(seconds: 10));

//       print('📥 Response Status: ${response.statusCode}');
//       print('📥 Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final dynamic data = jsonDecode(response.body);
        
//         // Handle different response formats
//         if (data is List) {
//           // If response is directly a list
//           return data.map((o) => Order.fromJson(o as Map<String, dynamic>)).toList();
//         } else if (data is Map<String, dynamic> && data['data'] != null) {
//           // If response has a 'data' key with list
//           final List orders = data['data'] as List;
//           return orders.map((o) => Order.fromJson(o as Map<String, dynamic>)).toList();
//         } else if (data is Map<String, dynamic> && data['orders'] != null) {
//           // If response has 'orders' key
//           final List orders = data['orders'] as List;
//           return orders.map((o) => Order.fromJson(o as Map<String, dynamic>)).toList();
//         } else {
//           print('❌ Unknown response format: $data');
//           return [];
//         }
//       } else {
//         print('❌ Status Code: ${response.statusCode}');
//         throw Exception('Failed to load orders: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('❌ Error: $e');
//       throw Exception('Error: $e');
//     }
//   }

//   // Get single order
//   Future<Order> getOrder(int orderId) async {
//     try {
//       final headers = await getHeaders();
//       final response = await http.get(
//         Uri.parse('${ApiConstants.baseUrl}/orders/$orderId'),
//         headers: headers,
//       ).timeout(const Duration(seconds: 10));

//       print('📥 Response Status: ${response.statusCode}');
//       print('📥 Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final dynamic data = jsonDecode(response.body);
        
//         if (data is Map<String, dynamic> && data['data'] != null) {
//           return Order.fromJson(data['data'] as Map<String, dynamic>);
//         } else if (data is Map<String, dynamic>) {
//           return Order.fromJson(data);
//         } else {
//           throw Exception('Invalid response format');
//         }
//       } else {
//         throw Exception('Failed to load order');
//       }
//     } catch (e) {
//       print('❌ Error: $e');
//       throw Exception('Error: $e');
//     }
//   }

//   // Get order items
//   Future<List<OrderItem>> getOrderItems(int orderId) async {
//     try {
//       final headers = await getHeaders();
//       final response = await http.get(
//         Uri.parse('${ApiConstants.baseUrl}/orders/$orderId/items'),
//         headers: headers,
//       ).timeout(const Duration(seconds: 10));

//       print('📥 Response Status: ${response.statusCode}');
//       print('📥 Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final dynamic data = jsonDecode(response.body);
        
//         if (data is List) {
//           return data.map((i) => OrderItem.fromJson(i as Map<String, dynamic>)).toList();
//         } else if (data is Map<String, dynamic> && data['data'] != null) {
//           final List items = data['data'] as List;
//           return items.map((i) => OrderItem.fromJson(i as Map<String, dynamic>)).toList();
//         } else if (data is Map<String, dynamic> && data['items'] != null) {
//           final List items = data['items'] as List;
//           return items.map((i) => OrderItem.fromJson(i as Map<String, dynamic>)).toList();
//         } else {
//           return [];
//         }
//       } else {
//         throw Exception('Failed to load items');
//       }
//     } catch (e) {
//       print('❌ Error: $e');
//       throw Exception('Error: $e');
//     }
//   }

//   // Update order item quantity
//   Future<OrderItem> updateItemQuantity(int itemId, int quantity) async {
//     try {
//       final headers = await getHeaders();
//       final response = await http.put(
//         Uri.parse('${ApiConstants.baseUrl}/order-items/$itemId'),
//         headers: headers,
//         body: jsonEncode({'quantity': quantity}),
//       ).timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return OrderItem.fromJson(data);
//       } else {
//         throw Exception('Failed to update quantity');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   // Delete order item
//   Future<void> deleteItem(int itemId) async {
//     try {
//       final headers = await getHeaders();
//       final response = await http.delete(
//         Uri.parse('${ApiConstants.baseUrl}/order-items/$itemId'),
//         headers: headers,
//       ).timeout(const Duration(seconds: 10));

//       if (response.statusCode != 200) {
//         throw Exception('Failed to delete item');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   // Create order item
//   Future<OrderItem> createItem({
//     required int orderId,
//     required int productId,
//     required int variantId,
//     required int quantity,
//     required double unitPrice,
//   }) async {
//     try {
//       final headers = await getHeaders();
//       final response = await http.post(
//         Uri.parse('${ApiConstants.baseUrl}/order-items'),
//         headers: headers,
//         body: jsonEncode({
//           'order_id': orderId,
//           'product_id': productId,
//           'variant_id': variantId,
//           'quantity': quantity,
//           'unit_price': unitPrice,
//         }),
//       ).timeout(const Duration(seconds: 10));

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return OrderItem.fromJson(data);
//       } else {
//         throw Exception('Failed to create item');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
// }import 'dart:convert';
import 'dart:convert';

import 'package:ecommerce_urban/modules/admin_orders/model/order_items_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_urban/app/constants/constants.dart';
import 'package:ecommerce_urban/app/services/storage_services.dart';

class OrderService {
  final StorageService storage = StorageService();

  Future<String?> getToken() async {
    return await storage.getToken();
  }

  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  // Get all orders
  Future<List<Order>> getAllOrders() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/orders'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        
        if (data is List) {
          return data.map((o) => Order.fromJson(o as Map<String, dynamic>)).toList();
        } else if (data is Map<String, dynamic> && data['data'] != null) {
          final List orders = data['data'] as List;
          return orders.map((o) => Order.fromJson(o as Map<String, dynamic>)).toList();
        } else if (data is Map<String, dynamic> && data['orders'] != null) {
          final List orders = data['orders'] as List;
          return orders.map((o) => Order.fromJson(o as Map<String, dynamic>)).toList();
        } else {
          print('❌ Unknown response format: $data');
          return [];
        }
      } else {
        print('❌ Status Code: ${response.statusCode}');
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Error: $e');
    }
  }

  // Get single order
  Future<Order> getOrder(int orderId) async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/orders/$orderId'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        
        if (data is Map<String, dynamic> && data['data'] != null) {
          return Order.fromJson(data['data'] as Map<String, dynamic>);
        } else if (data is Map<String, dynamic>) {
          return Order.fromJson(data);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load order');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Error: $e');
    }
  }

  // Get order items
  Future<List<OrderItem>> getOrderItems(int orderId) async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/orders/$orderId/items'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        
        if (data is List) {
          return data.map((i) => OrderItem.fromJson(i as Map<String, dynamic>)).toList();
        } else if (data is Map<String, dynamic> && data['data'] != null) {
          final List items = data['data'] as List;
          return items.map((i) => OrderItem.fromJson(i as Map<String, dynamic>)).toList();
        } else if (data is Map<String, dynamic> && data['items'] != null) {
          final List items = data['items'] as List;
          return items.map((i) => OrderItem.fromJson(i as Map<String, dynamic>)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Error: $e');
    }
  }

  // Update order item quantity
  Future<OrderItem> updateItemQuantity(int itemId, int quantity) async {
    try {
      final headers = await getHeaders();
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/order-items/$itemId'),
        headers: headers,
        body: jsonEncode({'quantity': quantity}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return OrderItem.fromJson(data);
      } else {
        throw Exception('Failed to update quantity');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete order item
  Future<void> deleteItem(int itemId) async {
    try {
      final headers = await getHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/order-items/$itemId'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete item');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create order item
  Future<OrderItem> createItem({
    required int orderId,
    required int productId,
    required int variantId,
    required int quantity,
    required double unitPrice,
    Map<String, dynamic>? taxes,
    Map<String, dynamic>? discounts,
  }) async {
    try {
      final headers = await getHeaders();
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/order-items'),
        headers: headers,
        body: jsonEncode({
          'order_id': orderId,
          'product_id': productId,
          'variant_id': variantId,
          'quantity': quantity,
          'unit_price': unitPrice,
          if (taxes != null) 'taxes': taxes,
          if (discounts != null) 'discounts': discounts,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return OrderItem.fromJson(data);
      } else {
        throw Exception('Failed to create item');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}