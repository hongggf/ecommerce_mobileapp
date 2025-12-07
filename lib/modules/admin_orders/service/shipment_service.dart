import 'dart:convert';
import 'package:ecommerce_urban/modules/admin_orders/model/shipmment_model.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_urban/app/constants/constants.dart';
import 'package:ecommerce_urban/app/services/storage_services.dart';


class ShipmentService {
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

  // Create new shipment
  Future<ShipmentModel?> createShipment(CreateShipmentRequest request) async {
    try {
      final headers = await _headers;
      final response = await http.post(
        Uri.parse('$_baseUrl/shipments'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return ShipmentModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Failed to create shipment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update shipment
  Future<bool> updateShipment(int shipmentId, UpdateShipmentRequest request) async {
    try {
      final headers = await _headers;
      final response = await http.put(
        Uri.parse('$_baseUrl/shipments/$shipmentId'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      }

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Mark as shipped
  Future<bool> markAsShipped(int shipmentId, MarkShippedRequest request) async {
    try {
      final headers = await _headers;
      final response = await http.post(
        Uri.parse('$_baseUrl/shipments/$shipmentId/mark-shipped'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      }

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Mark as delivered
  Future<bool> markAsDelivered(int shipmentId, MarkShippedRequest request) async {
    try {
      final headers = await _headers;
      final response = await http.post(
        Uri.parse('$_baseUrl/shipments/$shipmentId/mark-delivered'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      }

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get shipments for an order
  Future<List<ShipmentModel>> getOrderShipments(int orderId) async {
    try {
      final headers = await _headers;
      final response = await http.get(
        Uri.parse('$_baseUrl/shipments?order_id=$orderId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => ShipmentModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Failed to load shipments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Delete shipment
  Future<bool> deleteShipment(int shipmentId) async {
    try {
      final headers = await _headers;
      final response = await http.delete(
        Uri.parse('$_baseUrl/shipments/$shipmentId'),
        headers: headers,
      );

      if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      }

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}