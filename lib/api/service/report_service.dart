import 'package:dio/dio.dart';
import 'package:ecommerce_urban/api/model/report_model.dart';
import 'package:ecommerce_urban/app/constants/app_constant.dart';
import 'package:ecommerce_urban/app/services/dio_service.dart';

class ReportService {
  final Dio _dio = DioService.dio;

  Future<ReportData> fetchTopSellingProducts() async {
    final response = await _dio.get(AppConstant.topSellingProducts);
    print(response.data);
    return ReportData.fromJson(response.data['data']);
  }

  Future<ReportData> fetchLeastSellingProducts() async {
    final response = await _dio.get(AppConstant.leastSellingProducts);
    return ReportData.fromJson(response.data['data']);
  }

  Future<ReportData> fetchProductRevenue() async {
    final response = await _dio.get(AppConstant.productRevenue);
    return ReportData.fromJson(response.data['data']);
  }

  Future<List<StockLevel>> fetchStockLevel() async {
    final response = await _dio.get(AppConstant.stockLevel);
    return (response.data['data'] as List)
        .map((e) => StockLevel.fromJson(e))
        .toList();
  }

  Future<ReportData> fetchProductDistribution() async {
    final response = await _dio.get(AppConstant.productDistribution);
    return ReportData.fromJson(response.data['data']);
  }

  Future<ProductSalesByPeriod> fetchProductSalesByPeriod(String period) async {
    final response = await _dio.get(AppConstant.productSalesByPeriod(period));
    return ProductSalesByPeriod.fromJson(response.data);
  }
}