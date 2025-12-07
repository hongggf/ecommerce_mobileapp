import 'dart:convert';
import 'package:ecommerce_urban/modules/admin_orders/model/create_order_request_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_items_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_model.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_urban/app/constants/constants.dart';
import 'package:ecommerce_urban/app/services/storage_services.dart';

class OrderService {
  final String _baseUrl = ApiConstants.baseUrl;
  final StorageService _storage = StorageService();

  Future<Map<String, String>> get _headers async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  // Fetch all orders
  Future<List<OrderModel>> fetchOrders() async {
    try {
      final headers = await _headers;
      print('📡 Fetching orders from: $_baseUrl/orders');
      print('🔑 Headers: $headers');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/orders'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('✅ Orders loaded: ${jsonData.length}');
        return jsonData.map((json) => OrderModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching orders: $e');
      throw Exception('Network error: $e');
    }
  }

  // Fetch single order details
  Future<OrderModel?> fetchOrderDetails(int orderId) async {
    try {
      final headers = await _headers;
      print('📡 Fetching order details: $_baseUrl/orders/$orderId');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/orders/$orderId'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('✅ Order details loaded');
        return OrderModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Failed to load order details: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching order details: $e');
      throw Exception('Network error: $e');
    }
  }

  // Create new order
  Future<OrderModel?> createOrder(CreateOrderRequest request) async {
    try {
      final headers = await _headers;
      final body = json.encode(request.toJson());
      
      print('📡 Creating order: $_baseUrl/orders');
      print('📦 Request Body: $body');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/orders'),
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print('✅ Order created');
        return OrderModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error creating order: $e');
      throw Exception('Network error: $e');
    }
  }

  // Update order status - FIXED (Using POST instead of PUT)
  Future<bool> updateOrderStatus(int orderId, String newStatus) async {
    try {
      final headers = await _headers;
      final body = json.encode({'status': newStatus});
      final url = '$_baseUrl/orders/$orderId/status';
      
      print('═' * 60);
      print('🔄 UPDATING ORDER STATUS');
      print('📡 URL: $url');
      print('📦 Payload: $body');
      print('🔑 Token: ${headers['Authorization']}');
      print('═' * 60);
      
      // Try POST first (more common in Laravel)
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Headers: ${response.headers}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 401) {
        print('❌ Unauthorized - token invalid or expired');
        throw Exception('Unauthorized. Please login again.');
      }

      // If POST doesn't work, try PATCH
      if (response.statusCode == 405) {
        print('⚠️ POST not supported, trying PATCH...');
        response = await http.patch(
          Uri.parse('$_baseUrl/orders/$orderId'),
          headers: headers,
          body: body,
        ).timeout(const Duration(seconds: 15));
        
        print('📥 PATCH Response Status: ${response.statusCode}');
        print('📥 PATCH Response Body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Order status updated successfully to: $newStatus');
        return true;
      } else {
        print('❌ Server error: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        throw Exception('Failed to update status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Exception during status update: $e');
      throw Exception('Network error: $e');
    }
  }

  // Delete order
  Future<bool> deleteOrder(int orderId) async {
    try {
      final headers = await _headers;
      print('📡 Deleting order: $_baseUrl/orders/$orderId');
      
      final response = await http.delete(
        Uri.parse('$_baseUrl/orders/$orderId'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      }

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('❌ Error deleting order: $e');
      throw Exception('Network error: $e');
    }
  }

  // Create order item
  Future<OrderItem?> createOrderItem(OrderItem item) async {
    try {
      final headers = await _headers;
      final body = json.encode(item.toJson());
      
      print('📡 Creating order item: $_baseUrl/order-items');
      print('📦 Request Body: $body');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/order-items'),
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print('✅ Order item created');
        return OrderItem.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Failed to create order item: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error creating order item: $e');
      throw Exception('Network error: $e');
    }
  }

  // Update order item
  Future<bool> updateOrderItem(OrderItem item) async {
    try {
      final headers = await _headers;
      final body = json.encode(item.toJson());
      
      print('📡 Updating order item: $_baseUrl/order-items/${item.id}');
      print('📦 Request Body: $body');
      
      final response = await http.put(
        Uri.parse('$_baseUrl/order-items/${item.id}'),
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      }

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error updating order item: $e');
      throw Exception('Network error: $e');
    }
  }

  // Delete order item
  Future<bool> deleteOrderItem(int itemId) async {
    try {
      final headers = await _headers;
      print('📡 Deleting order item: $_baseUrl/order-items/$itemId');
      
      final response = await http.delete(
        Uri.parse('$_baseUrl/order-items/$itemId'),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      }

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('❌ Error deleting order item: $e');
      throw Exception('Network error: $e');
    }
  }
}