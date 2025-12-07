import 'package:ecommerce_urban/modules/admin_orders/model/create_order_request_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_items_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/shipmment_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/service/order_service.dart';
import 'package:ecommerce_urban/modules/admin_orders/service/shipment_service.dart';
import 'package:get/get.dart';

class AdminOrdersController extends GetxController {
  final OrderService _orderService = OrderService();
  final ShipmentService _shipmentService = ShipmentService();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<OrderModel> filteredOrders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedStatus = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      final fetchedOrders = await _orderService.fetchOrders();
      orders.assignAll(fetchedOrders);
      applyFilters();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<OrderModel?> loadOrderDetails(int orderId) async {
    try {
      return await _orderService.fetchOrderDetails(orderId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load order details: $e',
          snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

  Future<bool> createOrder(CreateOrderRequest request) async {
    try {
      isLoading.value = true;
      final newOrder = await _orderService.createOrder(request);
      if (newOrder != null) {
        orders.insert(0, newOrder);
        applyFilters();
        Get.snackbar('Success', 'Order created successfully',
            snackPosition: SnackPosition.BOTTOM);
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateOrderStatus(int orderId, String newStatus) async {
    try {
      isLoading.value = true;
      final success = await _orderService.updateOrderStatus(orderId, newStatus);
      if (success) {
        _updateOrderInList(orderId, newStatus);
        Get.snackbar('Success', 'Order status updated',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // This method is called from ShipmentController to sync updates
  Future<void> updateOrderStatusFromDetail(int orderId, String newStatus) async {
    try {
      // First update on server
      final success = await _orderService.updateOrderStatus(orderId, newStatus);
      if (success) {
        // Then update locally
        _updateOrderInList(orderId, newStatus);
      }
    } catch (e) {
      print('Error updating order status from detail: $e');
    }
  }

  void _updateOrderInList(int orderId, String newStatus) {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final updatedOrder = OrderModel(
        id: orders[index].id,
        orderNumber: orders[index].orderNumber,
        userId: orders[index].userId,
        status: newStatus,
        financialStatus: orders[index].financialStatus,
        shippingAddressSnapshot: orders[index].shippingAddressSnapshot,
        billingAddressSnapshot: orders[index].billingAddressSnapshot,
        subtotal: orders[index].subtotal,
        discountTotal: orders[index].discountTotal,
        taxTotal: orders[index].taxTotal,
        shippingTotal: orders[index].shippingTotal,
        grandTotal: orders[index].grandTotal,
        notes: orders[index].notes,
        createdAt: orders[index].createdAt,
        updatedAt: DateTime.now(),
        items: orders[index].items,
      );
      orders[index] = updatedOrder;
      orders.refresh();
      applyFilters();
    }
  }

  Future<bool> deleteOrder(int orderId) async {
    try {
      final success = await _orderService.deleteOrder(orderId);
      if (success) {
        orders.removeWhere((o) => o.id == orderId);
        applyFilters();
        Get.snackbar('Success', 'Order deleted successfully',
            snackPosition: SnackPosition.BOTTOM);
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete order: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> createOrderItem(OrderItem item) async {
    try {
      final newItem = await _orderService.createOrderItem(item);
      if (newItem != null) {
        Get.snackbar('Success', 'Item added to order',
            snackPosition: SnackPosition.BOTTOM);
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> updateOrderItem(OrderItem item) async {
    try {
      final success = await _orderService.updateOrderItem(item);
      if (success) {
        Get.snackbar('Success', 'Item updated successfully',
            snackPosition: SnackPosition.BOTTOM);
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> deleteOrderItem(int itemId) async {
    try {
      final success = await _orderService.deleteOrderItem(itemId);
      if (success) {
        Get.snackbar('Success', 'Item removed from order',
            snackPosition: SnackPosition.BOTTOM);
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove item: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  // Shipment methods
  Future<bool> createShipment(CreateShipmentRequest request) async {
    try {
      final shipment = await _shipmentService.createShipment(request);
      if (shipment != null) {
        Get.snackbar('Success', 'Shipment created successfully',
            snackPosition: SnackPosition.BOTTOM);
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create shipment: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> updateShipment(int shipmentId, UpdateShipmentRequest request) async {
    try {
      final success = await _shipmentService.updateShipment(shipmentId, request);
      if (success) {
        Get.snackbar('Success', 'Shipment updated successfully',
            snackPosition: SnackPosition.BOTTOM);
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update shipment: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> markAsShipped(int shipmentId, MarkShippedRequest request) async {
    try {
      final success = await _shipmentService.markAsShipped(shipmentId, request);
      if (success) {
        Get.snackbar('Success', 'Marked as shipped',
            snackPosition: SnackPosition.BOTTOM);
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark as shipped: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> markAsDelivered(int shipmentId, MarkShippedRequest request) async {
    try {
      final success = await _shipmentService.markAsDelivered(shipmentId, request);
      if (success) {
        Get.snackbar('Success', 'Marked as delivered',
            snackPosition: SnackPosition.BOTTOM);
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark as delivered: $e',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<List<ShipmentModel>> getOrderShipments(int orderId) async {
    try {
      return await _shipmentService.getOrderShipments(orderId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load shipments: $e',
          snackPosition: SnackPosition.BOTTOM);
      return [];
    }
  }

  void searchOrders(String query) {
    searchQuery.value = query.toLowerCase();
    applyFilters();
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    applyFilters();
  }

  void applyFilters() {
    var filtered = orders.toList();

    // Apply status filter
    if (selectedStatus.value != 'all') {
      filtered = filtered.where((o) => o.status == selectedStatus.value).toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((o) {
        return o.orderNumber.toLowerCase().contains(searchQuery.value) ||
            o.shippingAddressSnapshot.recipientName.toLowerCase().contains(searchQuery.value);
      }).toList();
    }

    filteredOrders.assignAll(filtered);
  }

  int getOrderCountByStatus(String status) {
    return orders.where((o) => o.status == status).length;
  }
}