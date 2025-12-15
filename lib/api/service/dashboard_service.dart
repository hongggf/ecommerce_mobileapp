import 'package:dio/dio.dart';
import 'package:ecommerce_urban/api/model/dashboard_model.dart';
import 'package:ecommerce_urban/app/constants/app_constant.dart';
import 'package:ecommerce_urban/app/services/dio_service.dart';

class DashboardService {
  final Dio _dio = DioService.dio;

  Future<DashboardModel> fetchDashboard() async {
    final response = await _dio.get(AppConstant.dashboard);
    if (response.statusCode == 200 && response.data['success'] == true) {
      return DashboardModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }
}