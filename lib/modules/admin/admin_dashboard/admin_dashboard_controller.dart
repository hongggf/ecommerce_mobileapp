import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/api/model/dashboard_model.dart';
import 'package:ecommerce_urban/api/service/dashboard_service.dart';

class AdminDashboardController extends GetxController {
  final DashboardService _service = DashboardService();

  var isLoading = true.obs;

  // Dashboard Data
  var totals = Totals(
    totalOrders: 0,
    totalSales: 0,
    totalCustomers: 0,
    totalProducts: 0,
  ).obs;

  var totalOrders = 0.obs;
  var totalSales = 0.obs;
  var totalCustomers = 0.obs;
  var totalProducts = 0.obs;

  var salesSummary = <int>[].obs; // weekly sales summary
  var days = <String>[].obs;      // weekly days
  var lowStockProducts = <Product>[].obs; // Fixed type
  var topNewUsers = <User>[].obs;         // Fixed type
  var currentUser = Rxn<User>(); // current_user

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  void fetchDashboard() async {
    try {
      isLoading.value = true;

      final dashboard = await _service.fetchDashboard();

      /// Totals
      totals.value = dashboard.totals;
      totalProducts.value = dashboard.totals.totalProducts.toInt();
      totalCustomers.value = dashboard.totals.totalCustomers.toInt();
      totalSales.value = dashboard.totals.totalSales.toInt();
      totalOrders.value = dashboard.totals.totalOrders.toInt();

      /// Weekly Sales
      salesSummary.value = dashboard.weeklySales.salesSummary;
      days.value = dashboard.weeklySales.days;

      /// Low stock products
      lowStockProducts.value = dashboard.lowStockProducts;

      /// Top new users
      topNewUsers.value = dashboard.topNewUsers;

      /// Current User
      currentUser.value = dashboard.currentUser;

    } catch (e) {
      ToastWidget.show(message: "Failed to fetch dashboard data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}