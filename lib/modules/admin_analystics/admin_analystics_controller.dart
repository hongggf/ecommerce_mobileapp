import 'package:ecommerce_urban/modules/admin_orders/model/order_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/service/order_service.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_model.dart';
import 'package:ecommerce_urban/modules/admin_products/services/adminProductApiService.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/model/user_model.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/services/user_and_role_service.dart';
import 'package:get/get.dart';

class ProductSalesData {
  final String productName;
  final int quantity;
  final double revenue;
  final String productId;

  ProductSalesData({
    required this.productName,
    required this.quantity,
    required this.revenue,
    required this.productId,
  });
}

class AdminAnalyticsController extends GetxController {
  final OrderService _orderService = OrderService();
  final Adminproductapiservice _productService = Adminproductapiservice();
  final UserService _userService = UserService();

  // Orders Analytics
  final RxList<OrderModel> allOrders = <OrderModel>[].obs;
  final RxInt totalOrders = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;
  final RxInt completedOrders = 0.obs;
  final RxInt pendingOrders = 0.obs;
  final RxInt cancelledOrders = 0.obs;

  // Products Analytics
  final RxList<Product> allProducts = <Product>[].obs;
  final RxInt totalProducts = 0.obs;
  final RxInt activeProducts = 0.obs;
  final RxInt inactiveProducts = 0.obs;
  final RxList<ProductSalesData> topSellingProducts = <ProductSalesData>[].obs;

  // Users Analytics
  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxInt totalUsers = 0.obs;
  final RxInt activeUsers = 0.obs;
  final RxInt inactiveUsers = 0.obs;

  // Chart Data - Order Trend
  final RxList<double> orderTrend = <double>[].obs;
  final RxList<String> orderDates = <String>[].obs;

  // UI State
  final RxBool isLoadingAnalytics = false.obs;
  final RxString selectedTimeframe = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllAnalytics();
  }

  Future<void> loadAllAnalytics() async {
    try {
      isLoadingAnalytics.value = true;
      
      await Future.wait([
        _loadOrdersAnalytics(),
        _loadProductsAnalytics(),
        _loadUsersAnalytics(),
      ]);

      _generateOrderTrendData();
      _calculateTopSellingProducts();
      print('✅ All analytics loaded successfully');
    } catch (e) {
      print('❌ Error loading analytics: $e');
      Get.snackbar('Error', 'Failed to load analytics: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingAnalytics.value = false;
    }
  }

  Future<void> _loadOrdersAnalytics() async {
    try {
      print('📊 Loading orders analytics...');
      final orders = await _orderService.fetchOrders();
      allOrders.assignAll(orders);

      totalOrders.value = orders.length;
      
      double revenue = 0;
      for (var order in orders) {
        try {
          double amount = 0;
          if (order.grandTotal is String) {
            amount = double.parse(order.grandTotal.toString());
          } else if (order.grandTotal is num) {
            amount = (order.grandTotal as num).toDouble();
          } else {
            amount = double.tryParse(order.grandTotal.toString()) ?? 0;
          }
          revenue += amount;
        } catch (e) {
          print('⚠️ Error parsing grandTotal for order ${order.id}: $e');
        }
      }
      totalRevenue.value = revenue;

      completedOrders.value = 
          orders.where((o) => o.status.toLowerCase() == 'completed' || o.status.toLowerCase() == 'delivered').length;
      pendingOrders.value = 
          orders.where((o) => o.status.toLowerCase() == 'pending' || o.status.toLowerCase() == 'processing').length;
      cancelledOrders.value = 
          orders.where((o) => o.status.toLowerCase() == 'cancelled').length;

      print('✅ Orders loaded: Total=$totalOrders, Revenue=$totalRevenue');
    } catch (e) {
      print('⚠️ Error loading orders: $e');
    }
  }

  Future<void> _loadProductsAnalytics() async {
    try {
      print('📦 Loading products analytics...');
      final products = await _productService.getProducts();
      allProducts.assignAll(products);

      totalProducts.value = products.length;
      activeProducts.value = products.where((p) => p.status == 'active').length;
      inactiveProducts.value = products.where((p) => p.status != 'active').length;

      print('✅ Products loaded: Total=$totalProducts, Active=$activeProducts');
    } catch (e) {
      print('⚠️ Error loading products: $e');
    }
  }

  Future<void> _loadUsersAnalytics() async {
    try {
      print('👥 Loading users analytics...');
      final users = await _userService.fetchUsersWithRoles();
      allUsers.assignAll(users);

      totalUsers.value = users.length;
      activeUsers.value = users.where((u) => u.status.toLowerCase() == 'active').length;
      inactiveUsers.value = users.where((u) => u.status.toLowerCase() != 'active').length;

      print('✅ Users loaded: Total=$totalUsers, Active=$activeUsers');
    } catch (e) {
      print('⚠️ Error loading users: $e');
    }
  }

  void _generateOrderTrendData() {
    // Generate order trend data from actual orders
    orderTrend.clear();
    orderDates.clear();

    final now = DateTime.now();
    final last7Days = <String, int>{};

    // Initialize last 7 days with 0 orders
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.month}/${date.day}';
      last7Days[dateKey] = 0;
      orderDates.add(dateKey);
    }

    // Count orders per day
    for (var order in allOrders) {
      final orderDate = order.createdAt;
      final daysDiff = now.difference(orderDate).inDays;
      
      if (daysDiff <= 6) {
        final dateKey = '${orderDate.month}/${orderDate.day}';
        if (last7Days.containsKey(dateKey)) {
          last7Days[dateKey] = (last7Days[dateKey] ?? 0) + 1;
        }
      }
    }

    // Convert to trend list
    for (var date in orderDates) {
      orderTrend.add((last7Days[date] ?? 0).toDouble());
    }

    print('📈 Order trend data generated: $orderTrend');
  }

  void _calculateTopSellingProducts() {
    try {
      // Create a map to track product sales
      final productSales = <String, Map<String, dynamic>>{};

      // Process all orders and their items
      for (var order in allOrders) {
        if (order.items != null && order.items!.isNotEmpty) {
          for (var item in order.items!) {
            try {
              final productId = item.productId.toString();
              final productName = item.productName ?? 'Unknown Product';
              
              // Get unit price using the helper getter from OrderItem
              final itemPrice = item.unitPriceDouble;
              final quantity = item.quantity;

              if (productSales.containsKey(productId)) {
                productSales[productId]!['quantity'] += quantity;
                productSales[productId]!['revenue'] += (itemPrice * quantity);
              } else {
                productSales[productId] = {
                  'name': productName,
                  'quantity': quantity,
                  'revenue': itemPrice * quantity,
                };
              }

              print('📦 Product: $productName, Qty: $quantity, Price: $itemPrice');
            } catch (itemError) {
              print('⚠️ Error processing order item: $itemError');
            }
          }
        }
      }

      // Convert to list and sort by quantity
      final salesList = productSales.entries
          .map((entry) => ProductSalesData(
            productId: entry.key,
            productName: entry.value['name'],
            quantity: entry.value['quantity'],
            revenue: entry.value['revenue'],
          ))
          .toList();

      // Sort by quantity descending
      salesList.sort((a, b) => b.quantity.compareTo(a.quantity));

      // Take top 10
      topSellingProducts.assignAll(salesList.take(10).toList());
      
      print('✅ Top selling products calculated: ${topSellingProducts.length} products');
      for (var product in topSellingProducts) {
        print('   📊 ${product.productName}: ${product.quantity} sold, \${product.revenue.toStringAsFixed(2)}');
      }
    } catch (e) {
      print('⚠️ Error calculating top products: $e');
    }
  }

  double get averageOrderValue {
    if (totalOrders.value == 0) return 0;
    return totalRevenue.value / totalOrders.value;
  }

  double get completionRate {
    if (totalOrders.value == 0) return 0;
    return (completedOrders.value / totalOrders.value) * 100;
  }

  void setTimeframe(String timeframe) {
    selectedTimeframe.value = timeframe;
  }

  void refreshAnalytics() {
    loadAllAnalytics();
  }
}