import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Mock Models
class OrderModel {
  final int? id;
  final String orderNumber;
  final String status;
  final String financialStatus;
  final DateTime createdAt;
  final ShippingAddress shippingAddressSnapshot;
  final double subtotalDouble;
  final double discountDouble;
  final double taxDouble;
  final double shippingDouble;
  final double grandTotalDouble;
  final String? notes;
  final List<OrderItem>? items;

  OrderModel({
    this.id,
    required this.orderNumber,
    required this.status,
    required this.financialStatus,
    required this.createdAt,
    required this.shippingAddressSnapshot,
    required this.subtotalDouble,
    required this.discountDouble,
    required this.taxDouble,
    required this.shippingDouble,
    required this.grandTotalDouble,
    this.notes,
    this.items,
  });
}

class ShippingAddress {
  final String recipientName;
  final String city;
  final String countryCode;
  String get fullAddress => '$city, $countryCode';

  ShippingAddress({
    required this.recipientName,
    required this.city,
    required this.countryCode,
  });
}

class OrderItem {
  final int? id;
  final int productId;
  final String? productName;
  final int quantity;
  final double unitPriceDouble;
  final double totalPrice;
  final String? imageUrl;

  OrderItem({
    this.id,
    required this.productId,
    this.productName,
    required this.quantity,
    required this.unitPriceDouble,
    required this.totalPrice,
    this.imageUrl,
  });
}

// Admin Orders Controller
class AdminOrdersController extends GetxController {
  var orders = <OrderModel>[].obs;
  var filteredOrders = <OrderModel>[].obs;
  var isLoading = false.obs;
  var selectedStatus = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    await Future.delayed(Duration(milliseconds: 800));
    
    orders.value = [
      OrderModel(
        id: 1,
        orderNumber: 'ORD-2024-001',
        status: 'pending',
        financialStatus: 'paid',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        shippingAddressSnapshot: ShippingAddress(
          recipientName: 'John Doe',
          city: 'New York',
          countryCode: 'US',
        ),
        subtotalDouble: 150.00,
        discountDouble: 15.00,
        taxDouble: 12.00,
        shippingDouble: 10.00,
        grandTotalDouble: 157.00,
      ),
      OrderModel(
        id: 2,
        orderNumber: 'ORD-2024-002',
        status: 'shipped',
        financialStatus: 'paid',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        shippingAddressSnapshot: ShippingAddress(
          recipientName: 'Jane Smith',
          city: 'Los Angeles',
          countryCode: 'US',
        ),
        subtotalDouble: 280.00,
        discountDouble: 0.00,
        taxDouble: 25.00,
        shippingDouble: 15.00,
        grandTotalDouble: 320.00,
      ),
      OrderModel(
        id: 3,
        orderNumber: 'ORD-2024-003',
        status: 'delivered',
        financialStatus: 'paid',
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        shippingAddressSnapshot: ShippingAddress(
          recipientName: 'Bob Johnson',
          city: 'Chicago',
          countryCode: 'US',
        ),
        subtotalDouble: 95.50,
        discountDouble: 5.00,
        taxDouble: 8.00,
        shippingDouble: 8.00,
        grandTotalDouble: 106.50,
      ),
    ];
    
    filteredOrders.value = orders;
    isLoading.value = false;
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    if (status == 'all') {
      filteredOrders.value = orders;
    } else {
      filteredOrders.value = orders.where((o) => o.status == status).toList();
    }
  }

  void searchOrders(String query) {
    if (query.isEmpty) {
      filteredOrders.value = orders;
    } else {
      filteredOrders.value = orders.where((o) {
        return o.orderNumber.toLowerCase().contains(query.toLowerCase()) ||
            o.shippingAddressSnapshot.recipientName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  int getOrderCountByStatus(String status) {
    return orders.where((o) => o.status == status).length;
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    await Future.delayed(Duration(milliseconds: 500));
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      // Update mock order status
      Get.snackbar('Success', 'Order status updated',
          backgroundColor: Colors.green, colorText: Colors.white);
      loadOrders();
    }
  }

  Future<void> deleteOrder(int orderId) async {
    await Future.delayed(Duration(milliseconds: 500));
    orders.removeWhere((o) => o.id == orderId);
    filteredOrders.value = orders;
    Get.snackbar('Success', 'Order deleted',
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}

// Create Order Controller
class CreateOrderController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
  final cartIdController = TextEditingController();
  final shipNameController = TextEditingController();
  final shipLine1Controller = TextEditingController();
  final shipLine2Controller = TextEditingController();
  final shipCityController = TextEditingController();
  final shipStateController = TextEditingController();
  final shipPostalController = TextEditingController();
  final shipCountryController = TextEditingController();
  
  final billNameController = TextEditingController();
  final billLine1Controller = TextEditingController();
  final billLine2Controller = TextEditingController();
  final billCityController = TextEditingController();
  final billStateController = TextEditingController();
  final billPostalController = TextEditingController();
  final billCountryController = TextEditingController();
  
  final discountController = TextEditingController();
  final taxController = TextEditingController();
  final shippingController = TextEditingController();
  final notesController = TextEditingController();
  
  var sameAsShipping = false.obs;
  var isSubmitting = false.obs;

  void copyShippingToBilling() {
    billNameController.text = shipNameController.text;
    billLine1Controller.text = shipLine1Controller.text;
    billLine2Controller.text = shipLine2Controller.text;
    billCityController.text = shipCityController.text;
    billStateController.text = shipStateController.text;
    billPostalController.text = shipPostalController.text;
    billCountryController.text = shipCountryController.text;
  }

  void submitOrder() async {
    if (!formKey.currentState!.validate()) return;
    
    isSubmitting.value = true;
    await Future.delayed(Duration(seconds: 1));
    Get.snackbar('Success', 'Order created successfully',
        backgroundColor: Colors.green, colorText: Colors.white);
    isSubmitting.value = false;
    Get.back();
  }

  @override
  void onClose() {
    cartIdController.dispose();
    shipNameController.dispose();
    shipLine1Controller.dispose();
    shipLine2Controller.dispose();
    shipCityController.dispose();
    shipStateController.dispose();
    shipPostalController.dispose();
    shipCountryController.dispose();
    billNameController.dispose();
    billLine1Controller.dispose();
    billLine2Controller.dispose();
    billCityController.dispose();
    billStateController.dispose();
    billPostalController.dispose();
    billCountryController.dispose();
    discountController.dispose();
    taxController.dispose();
    shippingController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
