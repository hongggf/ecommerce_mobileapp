import 'dart:convert';
import 'package:ecommerce_urban/app/modules/auth/models/auth_model.dart';
import 'package:http/http.dart' as http;


class AuthService {
  final String baseUrl = 'https://dummyjson.com/auth/login';

  Future<AuthModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthModel.fromJson(data);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }
}
