import 'package:ecommerce_urban/modules/admin_orders/admin_orders_controller.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/service/order_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController {
  final int orderId;
  final OrderService _orderService = OrderService();

  final Rx<OrderModel?> order = Rx<OrderModel?>(null);
  final RxBool isLoading = false.obs;

  OrderDetailController(this.orderId);

  @override
  void onInit() {
    super.onInit();
    loadOrderDetails();
  }

  Future<void> loadOrderDetails() async {
    try {
      isLoading.value = true;
      final fetchedOrder = await _orderService.fetchOrderDetails(orderId);
      if (fetchedOrder != null) {
        order.value = fetchedOrder;
        print('✅ Order loaded: ${fetchedOrder.status}');
      }
    } catch (e) {
      print('❌ Error loading order: $e');
      Get.snackbar('Error', 'Failed to load order: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(String newStatus) async {
    if (order.value == null) {
      Get.snackbar('Error', 'Order not loaded',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      final currentOrder = order.value!;
      
      print('🔄 Updating order $orderId from ${currentOrder.status} to $newStatus');

      // Call server API
      final success = await _orderService.updateOrderStatus(orderId, newStatus);

      if (success) {
        print('✅ Server update successful');

        // Update local order object
        final updatedOrder = OrderModel(
          id: currentOrder.id,
          orderNumber: currentOrder.orderNumber,
          userId: currentOrder.userId,
          status: newStatus,
          financialStatus: currentOrder.financialStatus,
          shippingAddressSnapshot: currentOrder.shippingAddressSnapshot,
          billingAddressSnapshot: currentOrder.billingAddressSnapshot,
          subtotal: currentOrder.subtotal,
          discountTotal: currentOrder.discountTotal,
          taxTotal: currentOrder.taxTotal,
          shippingTotal: currentOrder.shippingTotal,
          grandTotal: currentOrder.grandTotal,
          notes: currentOrder.notes,
          createdAt: currentOrder.createdAt,
          updatedAt: DateTime.now(),
          items: currentOrder.items,
        );

        // Update the local state
        order.value = updatedOrder;
        order.refresh();
        print('✅ Local order updated: ${order.value!.status}');

        // Update the main orders list if controller exists
        try {
          final adminController = Get.find<AdminOrdersController>();
          print('🔄 Syncing with AdminOrdersController...');
          await adminController.updateOrderStatusFromDetail(orderId, newStatus);
          print('✅ AdminOrdersController synced');
        } catch (e) {
          print('⚠️ AdminOrdersController not found: $e');
        }

        Get.snackbar(
          'Success',
          'Order status updated to $newStatus',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(255, 76, 175, 80),
        );
      } else {
        print('❌ Server returned false');
        Get.snackbar(
          'Error',
          'Failed to update order status',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('❌ Exception: $e');
      Get.snackbar(
        'Error',
        'Error: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteOrderItem(int itemId) async {
    try {
      isLoading.value = true;
      final success = await _orderService.deleteOrderItem(itemId);
      
      if (success) {
        print('✅ Item deleted, reloading order...');
        await loadOrderDetails();
        Get.snackbar('Success', 'Item removed from order',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      } else {
        Get.snackbar('Error', 'Failed to remove item',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('❌ Error deleting item: $e');
      Get.snackbar('Error', 'Failed to remove item: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}