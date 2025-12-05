import 'package:ecommerce_urban/modules/stock_mangement/stock_controller.dart';
import 'package:get/get.dart';


class StockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockController>(() => StockController());
  }
}
