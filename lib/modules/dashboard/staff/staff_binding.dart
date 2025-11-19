import 'package:ecommerce_urban/modules/dashboard/staff/staff_controller.dart';
import 'package:get/get.dart';

class StaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaffController>(() => StaffController());
  }
}