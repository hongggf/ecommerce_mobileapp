import 'package:dio/dio.dart';
import 'package:ecommerce_urban/api/model/order_item_model.dart';
import 'package:ecommerce_urban/api/model/order_model.dart';
import 'package:ecommerce_urban/app/constants/app_constant.dart';

class OrderService {
  final Dio _dio;

  OrderService(this._dio);

  // Create Order
  Future<OrderModel> createOrder({
    required int addressId,
    required double subtotal,
    required double shippingFee,
    required double discount,
  }) async {
    try {
      print('🔵 POST ${AppConstant.baseUrl}${AppConstant.orders}');
      print('📦 Data: address_id=$addressId, subtotal=$subtotal, shipping_fee=$shippingFee, discount=$discount');

      final response = await _dio.post(
        '${AppConstant.baseUrl}${AppConstant.orders}',
        data: {
          'address_id': addressId,
          'subtotal': subtotal,
          'shipping_fee': shippingFee,
          'discount': discount,
        },
      );

      print('✅ Response Status: ${response.statusCode}');
      print('✅ Response Data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final orderData = response.data is Map<String, dynamic> && response.data.containsKey('data')
            ? response.data['data']
            : response.data;
        return OrderModel.fromJson(orderData);
      }
      throw Exception('Failed to create order: Status ${response.statusCode}');
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response: ${e.response?.data}');
      throw Exception('Error creating order: ${e.message}');
    }
  }

  // Add Order Item
  Future<OrderItemModel> addOrderItem({
    required int orderId,
    required int productId,
    required int quantity,
  }) async {
    try {
      print('🔵 POST ${AppConstant.baseUrl}${AppConstant.orderItemsCreate}');
      print('📦 Data: order_id=$orderId, product_id=$productId, quantity=$quantity');

      final response = await _dio.post(
        '${AppConstant.baseUrl}${AppConstant.orderItemsCreate}',
        data: {
          'order_id': orderId,
          'product_id': productId,
          'quantity': quantity,
        },
      );

      print('✅ Response Status: ${response.statusCode}');
      print('✅ Response Data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final itemData = response.data is Map<String, dynamic> && response.data.containsKey('data')
            ? response.data['data']
            : response.data;
        return OrderItemModel.fromJson(itemData);
      }
      throw Exception('Failed to add order item: Status ${response.statusCode}');
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response: ${e.response?.data}');
      throw Exception('Error adding order item: ${e.message}');
    }
  }

  // Get Order Items
  Future<List<OrderItemModel>> getOrderItems(int orderId) async {
    try {
      print('🔵 GET ${AppConstant.baseUrl}${AppConstant.orderItems(orderId)}');

      final response = await _dio.get(
        '${AppConstant.baseUrl}${AppConstant.orderItems(orderId)}',
      );

      print('✅ Response Status: ${response.statusCode}');
      print('✅ Response Data: ${response.data}');

      if (response.statusCode == 200) {
        List<OrderItemModel> items = [];

        final itemsData = response.data is Map<String, dynamic> && response.data.containsKey('data')
            ? response.data['data']
            : response.data;

        if (itemsData is List) {
          for (var item in itemsData) {
            items.add(OrderItemModel.fromJson(item));
          }
        }
        return items;
      }
      throw Exception('Failed to fetch order items: Status ${response.statusCode}');
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response: ${e.response?.data}');
      throw Exception('Error fetching order items: ${e.message}');
    }
  }

  // Get Order by ID
  Future<OrderModel> getOrder(int orderId) async {
    try {
      print('🔵 GET ${AppConstant.baseUrl}${AppConstant.orderById(orderId)}');

      final response = await _dio.get(
        '${AppConstant.baseUrl}${AppConstant.orderById(orderId)}',
      );

      print('✅ Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final orderData = response.data is Map<String, dynamic> && response.data.containsKey('data')
            ? response.data['data']
            : response.data;
        return OrderModel.fromJson(orderData);
      }
      throw Exception('Failed to fetch order: Status ${response.statusCode}');
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      throw Exception('Error fetching order: ${e.message}');
    }
  }

  // Update Order Status
  Future<OrderModel> updateOrderStatus({
    required int orderId,
    required String status,
    required String paymentStatus,
  }) async {
    try {
      print('🔵 PUT ${AppConstant.baseUrl}${AppConstant.orderById(orderId)}');
      print('📦 Data: status=$status, payment_status=$paymentStatus');

      final response = await _dio.put(
        '${AppConstant.baseUrl}${AppConstant.orderById(orderId)}',
        data: {
          'status': status,
          'payment_status': paymentStatus,
        },
      );

      print('✅ Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final orderData = response.data is Map<String, dynamic> && response.data.containsKey('data')
            ? response.data['data']
            : response.data;
        return OrderModel.fromJson(orderData);
      }
      throw Exception('Failed to update order: Status ${response.statusCode}');
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      throw Exception('Error updating order: ${e.message}');
    }
  }

  // Delete Order Item
  Future<void> deleteOrderItem(int orderItemId) async {
    try {
      print('🔵 DELETE ${AppConstant.baseUrl}${AppConstant.orderItemById(orderItemId)}');

      final response = await _dio.delete(
        '${AppConstant.baseUrl}${AppConstant.orderItemById(orderItemId)}',
      );

      print('✅ Response Status: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete order item: Status ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      throw Exception('Error deleting order item: ${e.message}');
    }
  }
}