import 'package:ecommerce_urban/modules/admin_products/admin_products_controller.dart';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';


import 'package:get/get.dart';

class AdminProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminProductsController>(()=> AdminProductsController());
    Get.lazyPut<ProductManagementController>(() => ProductManagementController());
  }
}
