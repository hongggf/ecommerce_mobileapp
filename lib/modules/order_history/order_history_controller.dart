
import 'package:ecommerce_urban/modules/order_history/order_model.dart';
import 'package:get/get.dart';


class OrderHistoryController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    isLoading.value = true;
    
    // Simulating API call with dummy data
    Future.delayed(const Duration(seconds: 1), () {
      orders.value = [
        OrderModel(
          id: '#ORD-2024-001',
          productName: 'Wireless Headphones Pro',
          productImage: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
          price: 299.99,
          quantity: 1,
          orderDate: DateTime.now().subtract(const Duration(days: 2)),
          status: 'delivered',
          trackingNumber: 'TRK123456789',
        ),
        OrderModel(
          id: '#ORD-2024-002',
          productName: 'Smart Watch Ultra',
          productImage: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
          price: 499.99,
          quantity: 1,
          orderDate: DateTime.now().subtract(const Duration(days: 5)),
          status: 'processing',
          trackingNumber: 'TRK987654321',
        ),
        OrderModel(
          id: '#ORD-2024-003',
          productName: 'Premium Backpack',
          productImage: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
          price: 89.99,
          quantity: 2,
          orderDate: DateTime.now().subtract(const Duration(days: 10)),
          status: 'delivered',
          trackingNumber: 'TRK456789123',
        ),
        OrderModel(
          id: '#ORD-2024-004',
          productName: 'Laptop Stand Aluminum',
          productImage: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400',
          price: 59.99,
          quantity: 1,
          orderDate: DateTime.now().subtract(const Duration(days: 15)),
          status: 'cancelled',
          trackingNumber: 'TRK789123456',
        ),
      ];
      isLoading.value = false;
    });
  }

  List<OrderModel> get filteredOrders {
    if (selectedFilter.value == 'all') {
      return orders;
    }
    return orders.where((order) => order.status == selectedFilter.value).toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void reorderProduct(OrderModel order) {
    Get.snackbar(
      'Reorder',
      'Reordering ${order.productName}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void trackOrder(OrderModel order) {
    Get.snackbar(
      'Track Order',
      'Tracking ${order.trackingNumber}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}