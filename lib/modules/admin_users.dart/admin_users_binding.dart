import 'package:ecommerce_urban/modules/admin_users.dart/admin_users_controller.dart';
import 'package:get/get.dart';

class AdminUsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminUsersController>(() => AdminUsersController());
  }
}