import 'dart:io';

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
    File? avatar,
  }) async {

    final formData = FormData.fromMap({
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "phone": phone,
      "role": role,

      if (avatar != null)
        "avatar": await MultipartFile.fromFile(
          avatar.path,
          filename: avatar.path.split('/').last,
        ),
    });

    final response = await _dio.post(
      '/api/users',
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
        },
      ),
    );

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
    File? avatar,
  }) async {

    final formData = FormData.fromMap({
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,

      if (password != null && passwordConfirmation != null) ...{
        "password": password,
        "password_confirmation": passwordConfirmation,
      },

      if (avatar != null)
        "avatar": await MultipartFile.fromFile(
          avatar.path,
        ),
    });
    final response = await _dio.post(
      '/api/users/$id',
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
          'X-HTTP-Method-Override': 'PUT'
        },
      ),
    );

    return UserModel.fromJson(response.data);
  }

  // Delete user
  Future<bool> deleteUser(int id) async {
    await _dio.delete('/api/users/$id');
    return true;
  }
}