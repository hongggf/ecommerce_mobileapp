import 'dart:async';
import 'package:ecommerce_urban/app/services/storage_services.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToMain();
  }

  void _navigateToMain() {
    Timer(const Duration(seconds: 2), () {
      final token = StorageService.token;
      final role = StorageService.role;

      // ❌ Not logged in
      if (token == null || token.isEmpty) {
        Get.offAllNamed(AppRoutes.login);
        return;
      }

      // ✅ Logged in → check role
      if (role == 'admin') {
        Get.offAllNamed(AppRoutes.adminMain);
      } else {
        Get.offAllNamed(AppRoutes.userMain);
      }
    });
  }
}