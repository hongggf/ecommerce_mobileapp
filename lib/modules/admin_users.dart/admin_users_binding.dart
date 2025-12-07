import 'package:ecommerce_urban/modules/admin_users.dart/services/user_and_role_service.dart';
import 'package:ecommerce_urban/modules/user_mangement/user_management_controller.dart';
import 'package:get/get.dart';

class AdminUsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserService>(() => UserService());
    Get.lazyPut<UserManagementController>(
      () => UserManagementController(),
    );
  }
}