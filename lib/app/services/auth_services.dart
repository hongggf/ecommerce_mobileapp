import 'dart:convert';
import 'package:ecommerce_urban/modules/auth/auth_model.dart';
import 'package:ecommerce_urban/modules/auth/login/login_request.dart';
import 'package:ecommerce_urban/modules/auth/register/register_request.dart';
import 'package:http/http.dart' as http;

import 'package:ecommerce_urban/app/services/storage_services.dart';

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final StorageService _storage = StorageService();

  Future<AuthModel> register(
    String fullName,
    String email,
    String password,
    String phone,
  ) async {
    try {
      final request = RegisterRequest(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authModel = AuthModel.fromJson(jsonDecode(response.body));

        // Save token and user data
        if (authModel.token != null) {
          await _storage.saveToken(authModel.token!);
        }
        await _storage.saveUserData(authModel.toJson());

        return authModel;
      }
      throw Exception('Registration failed: ${response.reasonPhrase}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AuthModel> login(String email, String password) async {
    try {
      final request = LoginRequest(
        email: email,
        password: password,
      );
      print('🔐 Login Request: ${request.toJson()}');
      print('🔐 Login URL: $_baseUrl/login');

      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );
      print('🔐 Login Response Status: ${response.statusCode}');
      print('🔐 Login Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final authModel = AuthModel.fromJson(jsonDecode(response.body));

        // Save token and user data
        if (authModel.token != null) {
          await _storage.saveToken(authModel.token!);
        }
        await _storage.saveUserData(authModel.toJson());

        return authModel;
      }
      throw Exception('Login failed: ${response.reasonPhrase}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      final token = await _storage.getToken();

      if (token != null) {
        await http.post(
          Uri.parse('$_baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      // Clear local storage
      await _storage.clear();
    } catch (e) {
      await _storage.clear();
      throw Exception(e.toString());
    }
  }

  Future<bool> isTokenValid() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getToken() async {
    return await _storage.getToken();
  }

  Future<String> getAuthHeader() async {
    final token = await _storage.getToken();
    return 'Bearer ${token ?? ''}';
  }
}
