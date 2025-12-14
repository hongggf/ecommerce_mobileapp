import 'package:dio/dio.dart';
import 'package:ecommerce_urban/api/model/auth_model.dart';
import 'package:ecommerce_urban/app/constants/app_constant.dart';
import 'package:ecommerce_urban/app/services/dio_service.dart';

class AuthService {
  final Dio _dio = DioService.dio;

  /// LOGIN
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      AppConstant.login,
      data: {
        "email": email,
        "password": password,
      },
    );

    return AuthModel.fromJson(response.data);
  }

  /// REGISTER
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    String role = "customer",
  }) async {
    await _dio.post(
      AppConstant.register,
      data: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "phone": phone,
        "role": role,
      },
    );
  }

  /// LOGOUT
  Future<void> logout() async {
    await _dio.post(AppConstant.logout);
  }
}