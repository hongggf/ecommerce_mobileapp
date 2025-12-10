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
      // Get.offAllNamed(AppRoutes.bottomNav);
      //  Get.offAllNamed(AppRoutes.login);
      Get.offAllNamed(AppRoutes.adminbottomnav);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}

/// code below is intergrate api

// import 'package:ecommerce_urban/modules/auth/auth_controller.dart';
// import 'package:ecommerce_urban/route/app_routes.dart';
// import 'package:get/get.dart';

// class SplashController extends GetxController {
//   final AuthController auth = Get.find();

//   @override
//   void onInit() {
//     super.onInit();
//     checkLogin();
//   }

//   Future<void> checkLogin() async {
//     await Future.delayed(const Duration(seconds: 2));

//     bool loggedIn = await auth.isLoggedIn();

//     if (!loggedIn) {
//       Get.offAllNamed(AppRoutes.login);
//       return;
//     }

//     // 🔥 Get the user role from AuthController
//     String? role = await auth.getUserRole(); // "admin" or "customer"

//     if (role == "admin") {
//       Get.offAllNamed(AppRoutes.adminbottomnav);
//     } else {
//       Get.offAllNamed(AppRoutes.bottomNav);
//     }
//   }
// }
