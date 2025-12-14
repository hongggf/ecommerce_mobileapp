import 'package:dio/dio.dart';
import 'package:ecommerce_urban/app/constants/app_constant.dart';
import 'package:ecommerce_urban/app/services/storage_services.dart';

class DioService {
  static Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstant.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // Attach token automatically
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = StorageService.token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    return dio;
  }
}