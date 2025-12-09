// lib/app/services/base_http_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_urban/app/constants/constants.dart';
import 'package:ecommerce_urban/app/services/storage_services.dart';

class BaseHttpService {
  static const String baseUrl = ApiConstants.baseUrl;
  final StorageService _storage = StorageService();

  // Get headers with token
  Future<Map<String, String>> getHeaders({bool includeAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = await _storage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // GET request
  Future<dynamic> get(String endpoint, {bool requireAuth = true}) async {
    try {
      final headers = await getHeaders(includeAuth: requireAuth);
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST request
  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool requireAuth = true,
  }) async {
    try {
      final headers = await getHeaders(includeAuth: requireAuth);
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUT request
  Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> data, {
    bool requireAuth = true,
  }) async {
    try {
      final headers = await getHeaders(includeAuth: requireAuth);
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint, {bool requireAuth = true}) async {
    try {
      final headers = await getHeaders(includeAuth: requireAuth);
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Handle response
  dynamic _handleResponse(http.Response response) {
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized - Please login again');
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden - You don\'t have permission');
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else if (response.statusCode == 422) {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Validation error';
      throw Exception(message);
    } else if (response.statusCode >= 500) {
      throw Exception('Server error - Please try again later');
    } else {
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Request failed');
      } catch (e) {
        throw Exception('Request failed: ${response.statusCode}');
      }
    }
  }
}