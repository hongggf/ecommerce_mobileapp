import 'package:ecommerce_urban/api/model/report_model.dart';
import 'package:ecommerce_urban/api/service/report_service.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  final ReportService _service = ReportService();

  var isLoading = false.obs;

  var topSelling = Rxn<ReportData>();
  var leastSelling = Rxn<ReportData>();
  var revenueReport = Rxn<ReportData>();
  var stockLevels = <StockLevel>[].obs;
  var distribution = Rxn<ReportData>();
  var salesByPeriod = Rxn<ProductSalesByPeriod>();

  var period = 'week'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllReports();
  }

  Future<void> fetchAllReports() async {
    isLoading.value = true;
    try {
      topSelling.value = await _service.fetchTopSellingProducts();
      leastSelling.value = await _service.fetchLeastSellingProducts();
      revenueReport.value = await _service.fetchProductRevenue();
      stockLevels.value = await _service.fetchStockLevel();
      distribution.value = await _service.fetchProductDistribution();
      salesByPeriod.value = await _service.fetchProductSalesByPeriod(period.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setPeriod(String newPeriod) async {
    period.value = newPeriod;
    isLoading.value = true;
    try {
      salesByPeriod.value = await _service.fetchProductSalesByPeriod(period.value);
    } finally {
      isLoading.value = false;
    }
  }
}