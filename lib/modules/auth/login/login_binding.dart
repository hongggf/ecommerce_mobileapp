import 'package:ecommerce_urban/modules/auth/login/login_controller.dart';
import 'package:ecommerce_urban/modules/bottom_nav/bottom_controller.dart';
import 'package:get/get.dart';


class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<BottomNavController>(()=>BottomNavController());
  }
}
