import 'package:ecommerce_urban/modules/customer_profile_management/profile_management_controller.dart';
import 'package:get/get.dart';

class ProfileManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileManagementController>(
      () => ProfileManagementController(),
    );
  }
}
