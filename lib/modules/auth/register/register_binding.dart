import 'package:ecommerce_urban/modules/auth/register/register_controller.dart';
import 'package:ecommerce_urban/modules/bottom_nav/bottom_controller.dart';
import 'package:get/get.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
    Get.lazyPut<BottomNavController>(()=>BottomNavController());
  }
}
