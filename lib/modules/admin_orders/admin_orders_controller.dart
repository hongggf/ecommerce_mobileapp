import 'package:ecommerce_urban/modules/admin_orders/model/order_items_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/service/order_service.dart';
import 'package:get/get.dart';

class AdminOrderController extends GetxController {
  final OrderService orderService = OrderService();

  var orders = <Order>[].obs;
  var orderItems = <OrderItem>[].obs;
  var selectedOrder = Rxn<Order>();
  var isLoading = false.obs;
  var statusFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllOrders();
  }

  void loadAllOrders() async {
    isLoading.value = true;
    try {
      final result = await orderService.getAllOrders();
      orders.value = result;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void loadOrderDetails(int orderId) async {
    isLoading.value = true;
    try {
      final order = await orderService.getOrder(orderId);
      selectedOrder.value = order;
       loadOrderItems(orderId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void loadOrderItems(int orderId) async {
    try {
      final items = await orderService.getOrderItems(orderId);
      orderItems.value = items;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void updateQuantity(int itemId, int quantity) async {
    try {
      await orderService.updateItemQuantity(itemId, quantity);
      Get.snackbar('Success', 'Quantity updated');
       loadOrderItems(selectedOrder.value!.id);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void removeItem(int itemId) async {
    try {
      await orderService.deleteItem(itemId);
      Get.snackbar('Success', 'Item removed');
      if (selectedOrder.value != null) {
         loadOrderItems(selectedOrder.value!.id);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void addItem({
    required int orderId,
    required int productId,
    required int variantId,
    required int quantity,
    required double unitPrice,
    Map<String, dynamic>? taxes,
    Map<String, dynamic>? discounts,
  }) async {
    try {
      await orderService.createItem(
        orderId: orderId,
        productId: productId,
        variantId: variantId,
        quantity: quantity,
        unitPrice: unitPrice,
        taxes: taxes,
        discounts: discounts,
      );
      Get.snackbar('Success', 'Item added');
       loadOrderItems(orderId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  List<Order> getFilteredOrders() {
    if (statusFilter.value.isEmpty) {
      return orders;
    }
    return orders.where((o) => o.status == statusFilter.value).toList();
  }
}