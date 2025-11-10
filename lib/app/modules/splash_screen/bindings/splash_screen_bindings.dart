import 'package:ecommerce_urban/app/modules/splash_screen/controller/splash_screen_controller.dart';
import 'package:get/get.dart';


class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
