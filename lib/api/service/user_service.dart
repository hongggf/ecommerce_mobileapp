import 'package:dio/dio.dart';
import 'package:ecommerce_urban/app/services/dio_service.dart';
import '../model/user_model.dart';

class UserService {
  final Dio _dio = DioService.dio;

  /// Fetch users with optional query params: search, role, sort
  Future<UserModel> getUsers({String? search, String? role, String? sort}) async {
    final Map<String, dynamic> query = {};
    if (search != null) query['search'] = search;
    if (role != null) query['role'] = role;
    if (sort != null) query['sort'] = sort;

    final response = await _dio.get('/api/users', queryParameters: query);
    return UserModel.fromJson(response.data);
  }

  /// Create user
  Future<UserModel> createUser({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String role,
  }) async {
    final response = await _dio.post('/api/users/', data: {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "phone": phone,
      "role": role,
    });
    print(response.data);
    return UserModel.fromJson(response.data);
  }

  /// Update user
  Future<UserModel> updateUser({
    required int id,
    required String name,
    required String email,
    String? password,
    String? passwordConfirmation,
    required String phone,
    required String role,
  }) async {
    final data = {
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
    };
    if (password != null && passwordConfirmation != null) {
      data['password'] = password;
      data['password_confirmation'] = passwordConfirmation;
    }

    final response = await _dio.put('/api/users/$id', data: data);
    return UserModel.fromJson(response.data);
  }

  // Delete user
  Future<bool> deleteUser(int id) async {
    await _dio.delete('/api/users/$id');
    return true;
  }
}