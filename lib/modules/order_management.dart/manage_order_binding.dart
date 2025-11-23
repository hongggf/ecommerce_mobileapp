import 'package:ecommerce_urban/modules/order_management.dart/manage_order_controller.dart';
import 'package:get/get.dart';

class ManageOrderBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ManageOrdersController>(() => ManageOrdersController());
  }
  }
