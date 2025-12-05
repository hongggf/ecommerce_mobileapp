import 'package:ecommerce_urban/modules/user_mangement/user_management_controller.dart';
import 'package:get/get.dart';

class UserManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManagementController>(
      () => UserManagementController(),
    );
  }
}