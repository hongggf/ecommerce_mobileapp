import 'package:ecommerce_urban/modules/add_product/add_product_controller.dart';
import 'package:get/get.dart';

class AddProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminAddProductController>(() =>AdminAddProductController());
  }

}