import 'package:get/get.dart';

class AdminDashboardController extends GetxController {

  // Overview Metrics
  var totalOrders = 120.obs;
  var totalSales = 15000.0.obs;
  var totalCustomers = 80.obs;
  var totalProducts = 50.obs;

  // Recent Orders (example)
  var recentOrders = <Map<String, String>>[
    {'id': '#001', 'status': 'Pending'},
    {'id': '#002', 'status': 'Shipped'},
    {'id': '#003', 'status': 'Delivered'},
  ].obs;

  // Low stock products
  var lowStockProducts = <String>['Product A', 'Product B'].obs;

  // New users
  var newUsers = <String>['John Doe', 'Jane Smith'].obs;

  // Summary chart data (example: weekly sales)
  final salesSummary = <double>[1200, 1800, 1500, 2200, 2000, 2500, 3000].obs;
  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  // Simulate fetching data
  void fetchDashboardData() async {
    await Future.delayed(const Duration(seconds: 1));
    totalOrders.value = 150;
    totalSales.value = 17500.0;
    totalCustomers.value = 95;
    totalProducts.value = 60;
  }
}