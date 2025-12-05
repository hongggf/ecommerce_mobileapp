import 'package:ecommerce_urban/modules/admin_orders/admin_orders_controller.dart';

import 'package:get/get.dart';

class AdminOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminOrdersController>(() => AdminOrdersController());
  }
}
