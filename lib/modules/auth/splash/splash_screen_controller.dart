import 'package:ecommerce_urban/modules/auth/auth_controller.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';


class SplashController extends GetxController {
  final AuthController auth = Get.find();

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    bool loggedIn = await auth.isLoggedIn();
    if (loggedIn) {
      Get.offAllNamed(AppRoutes.bottomNav);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
