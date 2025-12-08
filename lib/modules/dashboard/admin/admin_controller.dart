import 'package:ecommerce_urban/modules/admin_orders/service/order_service.dart';
import 'package:ecommerce_urban/modules/admin_products/services/adminProductApiService.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/services/user_and_role_service.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
   final OrderService _orderService = OrderService();
  final Adminproductapiservice _productService = Adminproductapiservice();
  final UserService _userService = UserService();

  // Observable counters
  final RxInt totalOrders = 0.obs;
  final RxInt totalProducts = 0.obs;
  final RxInt totalUsers = 0.obs;
  final RxBool isLoadingStats = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardStats();
  }

  Future<void> loadDashboardStats() async {
    try {
      isLoadingStats.value = true;

      // Load orders
      try {
        final orders = await _orderService.fetchOrders();
        totalOrders.value = orders.length;
        print('✅ Orders loaded: ${orders.length}');
      } catch (e) {
        print('⚠️ Error loading orders: $e');
        totalOrders.value = 0;
      }

      // Load products
      try {
        final products = await _productService.getProducts();
        totalProducts.value = products.length;
        print('✅ Products loaded: ${products.length}');
      } catch (e) {
        print('⚠️ Error loading products: $e');
        totalProducts.value = 0;
      }

      // Load users
      try {
        final users = await _userService.fetchUsersWithRoles();
        totalUsers.value = users.length;
        print('✅ Users loaded: ${users.length}');
      } catch (e) {
        print('⚠️ Error loading users: $e');
        totalUsers.value = 0;
      }
    } finally {
      isLoadingStats.value = false;
    }
  }

  // Call this when data changes
  void refreshStats() {
    loadDashboardStats();
  }
  // Quick Actions
  var quickActions = <QuickAction>[
    QuickAction(title: 'Add New Product', icon: '➕'),
    QuickAction(title: 'Create Order', icon: '📝'),
    QuickAction(title: 'Add Stock', icon: '📥'),
    QuickAction(title: 'Add User', icon: '👤➕'),
  ].obs;
   var categories = <String>[].obs;

  void addCategory(String name) {
    categories.add(name);
    print('Category Added: $name');
  }
}

class DashboardSummary {
  final String title;
  final String value;
  final String icon;

  DashboardSummary({required this.title, required this.value, required this.icon});
}

class QuickAction {
  final String title;
  final String icon;

  QuickAction({required this.title, required this.icon});
}