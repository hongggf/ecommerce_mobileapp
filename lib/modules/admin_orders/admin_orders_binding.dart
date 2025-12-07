// lib/modules/admin_orders/admin_order_binding.dart
import 'package:ecommerce_urban/modules/admin_orders/admin_create_order_controller.dart';
import 'package:ecommerce_urban/modules/admin_orders/admin_edit_order_controller.dart';
import 'package:ecommerce_urban/modules/admin_orders/admin_order_detail_controller.dart';
import 'package:ecommerce_urban/modules/admin_orders/admin_orders_controller.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_items_model.dart';
import 'package:get/get.dart';

class AdminOrderBinding extends Bindings {
  @override
  void dependencies() {
    // Core controllers (no args)
    Get.lazyPut<AdminOrdersController>(() => AdminOrdersController());
    Get.lazyPut<CreateOrderController>(() => CreateOrderController());

    // Try to get args (works when using named routing with binding)
    final args = Get.arguments ?? {};
    final int? orderId = args['orderId'] as int?;
    final OrderItem? item = args['item'] as OrderItem?;

    // Bind OrderDetailController if orderId is provided
    if (orderId != null) {
      // Use a tag to make it easy to find specific order controller instances
      final tag = 'order_$orderId';
      Get.lazyPut<OrderDetailController>(
        () => OrderDetailController(orderId),
        tag: tag,
      );

      // Optionally also prepare an EditOrderItemController if item info was passed
      // Tag should match how screens will try to find it
      final editTag = 'edit_item_${item?.id ?? 'new'}';
      Get.lazyPut<EditOrderItemController>(
        () => EditOrderItemController(orderId: orderId, item: item),
        tag: editTag,
      );
    }
  }
}
