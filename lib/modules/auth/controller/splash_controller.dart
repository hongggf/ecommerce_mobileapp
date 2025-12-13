import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';
import 'dart:async';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _navigateToMain();
  }

  void _navigateToMain() {
    Timer(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.adminMain);
    });
  }

}