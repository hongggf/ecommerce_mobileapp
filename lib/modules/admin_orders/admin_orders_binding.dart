import 'package:ecommerce_urban/modules/admin_orders/admin_orders_controller.dart';
import 'package:get/get.dart';

class AdminOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminOrderController>(()=>AdminOrderController());
  }
}