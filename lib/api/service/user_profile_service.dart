import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ecommerce_urban/api/model/user_profile_model.dart';
import 'package:ecommerce_urban/app/constants/app_constant.dart';
import 'package:ecommerce_urban/app/services/dio_service.dart';

class UserProfileService {
  final Dio _dio = DioService.dio;

  /// GET /api/me
  Future<UserProfileModel> fetchMe() async {
    final response = await _dio.get(AppConstant.me);

    return UserProfileModel.fromJson(response.data['data']);
  }

  /// POST /api/me/update
  Future<UserProfileModel> updateMe({
    required String name,
    required String phone,
    File? avatar,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'phone': phone,
    });

    if (avatar != null) {
      formData.files.add(
        MapEntry(
          'avatar',
          await MultipartFile.fromFile(
            avatar.path,
            filename: avatar.path.split('/').last,
          ),
        ),
      );
    }

    final response = await _dio.post(
      AppConstant.meUpdate,
      data: formData,
    );

    return UserProfileModel.fromJson(response.data['data']);
  }
}