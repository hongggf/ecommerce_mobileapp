import 'package:ecommerce_urban/modules/dashboard/admin/admin_controller.dart';
import 'package:get/get.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(() => AdminController());
    
  }
}