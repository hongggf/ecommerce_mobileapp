import 'package:ecommerce_urban/modules/order_management.dart/order_management_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageOrdersController extends GetxController {
  final orders = <OrderModel>[].obs;
  final filteredOrders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final selectedStatus = Rx<OrderStatus?>(null);
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    
    // Simulate API call with dummy data
    await Future.delayed(const Duration(seconds: 1));
    
    orders.value = _getDummyOrders();
    filteredOrders.value = orders;
    
    isLoading.value = false;
  }

  void filterByStatus(OrderStatus? status) {
    selectedStatus.value = status;
    applyFilters();
  }

  void searchOrders(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void applyFilters() {
    filteredOrders.value = orders.where((order) {
      final matchesStatus = selectedStatus.value == null || 
          order.status == selectedStatus.value;
      final matchesSearch = searchQuery.value.isEmpty ||
          order.orderNumber.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          order.customerName.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    isLoading.value = true;
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    final index = orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      // Create updated order with new status
      final updatedOrder = OrderModel(
        id: orders[index].id,
        orderNumber: orders[index].orderNumber,
        customerName: orders[index].customerName,
        customerEmail: orders[index].customerEmail,
        customerPhone: orders[index].customerPhone,
        totalAmount: orders[index].totalAmount,
        status: newStatus,
        orderDate: orders[index].orderDate,
        items: orders[index].items,
        shippingAddress: orders[index].shippingAddress,
        paymentMethod: orders[index].paymentMethod,
      );
      
      orders[index] = updatedOrder;
      applyFilters();
      
      Get.snackbar(
        'Success',
        'Order status updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Colors.white,
      );
    }
    
    isLoading.value = false;
  }

  int getOrderCountByStatus(OrderStatus status) {
    return orders.where((order) => order.status == status).length;
  }

  // Dummy data for demonstration
  List<OrderModel> _getDummyOrders() {
    return [
      OrderModel(
        id: '1',
        orderNumber: 'ORD-2024-001',
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        customerPhone: '+1234567890',
        totalAmount: 299.99,
        status: OrderStatus.pending,
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
        items: [
          OrderItem(
            productId: 'p1',
            productName: 'Wireless Headphones',
            quantity: 1,
            price: 149.99,
            imageUrl: 'https://via.placeholder.com/100',
          ),
          OrderItem(
            productId: 'p2',
            productName: 'Phone Case',
            quantity: 2,
            price: 75.00,
            imageUrl: 'https://via.placeholder.com/100',
          ),
        ],
        shippingAddress: '123 Main St, New York, NY 10001',
        paymentMethod: 'Credit Card',
      ),
      OrderModel(
        id: '2',
        orderNumber: 'ORD-2024-002',
        customerName: 'Jane Smith',
        customerEmail: 'jane@example.com',
        customerPhone: '+1234567891',
        totalAmount: 599.99,
        status: OrderStatus.processing,
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        items: [
          OrderItem(
            productId: 'p3',
            productName: 'Smart Watch',
            quantity: 1,
            price: 599.99,
            imageUrl: 'https://via.placeholder.com/100',
          ),
        ],
        shippingAddress: '456 Oak Ave, Los Angeles, CA 90001',
        paymentMethod: 'PayPal',
      ),
      OrderModel(
        id: '3',
        orderNumber: 'ORD-2024-003',
        customerName: 'Mike Johnson',
        customerEmail: 'mike@example.com',
        customerPhone: '+1234567892',
        totalAmount: 1299.99,
        status: OrderStatus.shipped,
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        items: [
          OrderItem(
            productId: 'p4',
            productName: 'Laptop',
            quantity: 1,
            price: 1299.99,
            imageUrl: 'https://via.placeholder.com/100',
          ),
        ],
        shippingAddress: '789 Pine Rd, Chicago, IL 60601',
        paymentMethod: 'Credit Card',
      ),
      OrderModel(
        id: '4',
        orderNumber: 'ORD-2024-004',
        customerName: 'Sarah Williams',
        customerEmail: 'sarah@example.com',
        customerPhone: '+1234567893',
        totalAmount: 89.99,
        status: OrderStatus.delivered,
        orderDate: DateTime.now().subtract(const Duration(days: 7)),
        items: [
          OrderItem(
            productId: 'p5',
            productName: 'Bluetooth Speaker',
            quantity: 1,
            price: 89.99,
            imageUrl: 'https://via.placeholder.com/100',
          ),
        ],
        shippingAddress: '321 Elm St, Houston, TX 77001',
        paymentMethod: 'Debit Card',
      ),
      OrderModel(
        id: '5',
        orderNumber: 'ORD-2024-005',
        customerName: 'Tom Brown',
        customerEmail: 'tom@example.com',
        customerPhone: '+1234567894',
        totalAmount: 449.99,
        status: OrderStatus.confirmed,
        orderDate: DateTime.now().subtract(const Duration(hours: 5)),
        items: [
          OrderItem(
            productId: 'p6',
            productName: 'Gaming Mouse',
            quantity: 1,
            price: 79.99,
            imageUrl: 'https://via.placeholder.com/100',
          ),
          OrderItem(
            productId: 'p7',
            productName: 'Mechanical Keyboard',
            quantity: 1,
            price: 169.99,
            imageUrl: 'https://via.placeholder.com/100',
          ),
          OrderItem(
            productId: 'p8',
            productName: 'Monitor',
            quantity: 1,
            price: 200.00,
            imageUrl: 'https://via.placeholder.com/100',
          ),
        ],
        shippingAddress: '654 Maple Dr, Phoenix, AZ 85001',
        paymentMethod: 'Credit Card',
      ),
    ];
  }
}
