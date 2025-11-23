import 'package:ecommerce_urban/modules/profile_management/profile_management_controller.dart';
import 'package:get/get.dart';

class ProfileManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileManagementController>(
      () => ProfileManagementController(),
    );
  }
}
