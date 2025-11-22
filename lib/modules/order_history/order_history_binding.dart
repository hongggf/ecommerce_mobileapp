import 'package:ecommerce_urban/modules/order_history/order_history_controller.dart';
import 'package:get/get.dart';


class OrderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderHistoryController>(() => OrderHistoryController());
  }
}