// // import 'package:ecommerce_urban/app/services/auth_services.dart';
// // import 'package:ecommerce_urban/modules/auth/auth_model.dart';

// // import 'package:ecommerce_urban/modules/bottom_nav/bottom_nav.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // class LoginController extends GetxController {
// //   final AuthService _authService = AuthService();

// //   final emailController = TextEditingController();
// //   final passwordController = TextEditingController();
// //   var isLoading = false.obs;

// //   Future<void> login() async {
// //     final email = emailController.text.trim();
// //     final password = passwordController.text.trim();

// //     if (email.isEmpty || password.isEmpty) {
// //       Get.snackbar('Error', 'Please enter email and password');
// //       return;
// //     }

// //     if (!email.contains('@')) {
// //       Get.snackbar('Error', 'Please enter valid email');
// //       return;
// //     }

// //     try {
// //       isLoading.value = true;
// //       final AuthModel user = await _authService.login(email, password);

// //       Get.snackbar('Success', 'Welcome ${user.fullName}');
// //       Get.offAll(() => BottomNav());
// //     } catch (e) {
// //       Get.snackbar('Login Failed', e.toString());
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   void goToRegister() {
// //     Get.toNamed('/register');
// //   }

// //   // @override
// //   // void onClose() {
// //   //   emailController.dispose();
// //   //   passwordController.dispose();
// //   //   super.onClose();
// //   // }
// // }
// import 'package:ecommerce_urban/app/services/auth_services.dart';
// import 'package:ecommerce_urban/modules/adminbottomnav/adminbottomnav.dart';
// import 'package:ecommerce_urban/modules/auth/auth_model.dart';
// import 'package:ecommerce_urban/modules/bottom_nav/bottom_nav.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginController extends GetxController {
//   final AuthService _authService = AuthService();

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   var isLoading = false.obs;

//   Future<void> login() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       Get.snackbar('Error', 'Please enter email and password');
//       return;
//     }

//     if (!email.contains('@')) {
//       Get.snackbar('Error', 'Please enter a valid email');
//       return;
//     }

//     try {
//       isLoading.value = true;

//       // 1️⃣ Login and get user model
//       final AuthModel user = await _authService.login(email, password);

//       // 2️⃣ Fetch saved role from StorageService
//       final role = await _authService.getSavedRole(); // << NEW

//       Get.snackbar('Success', 'Welcome ${user.fullName}');

//       // 3️⃣ Navigate based on role

//       if (role?.toLowerCase().trim() == "admin") {
//         Get.offAll(() => Adminbottomnav());
//       } else {
//         Get.offAll(() => BottomNav());
//       }
//     } catch (e) {
//       Get.snackbar('Login Failed', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void goToRegister() {
//     Get.toNamed('/register');
//   }
// }
import 'package:ecommerce_urban/app/services/auth_services.dart';
import 'package:ecommerce_urban/modules/auth/auth_model.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }

    if (!email.contains('@')) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }

    try {
      isLoading.value = true;

      // 1️⃣ Login and get user model
      final AuthModel user = await _authService.login(email, password);

      // 2️⃣ Wait a moment to ensure role is saved
      await Future.delayed(Duration(milliseconds: 500));

      // 3️⃣ Fetch saved role from StorageService
      final role = await _authService.getSavedRole();

      print('🔐 DEBUG - User Role: $role');
      print('🔐 DEBUG - Role type: ${role.runtimeType}');

      Get.snackbar('Success', 'Welcome ${user.fullName}');

      // 4️⃣ Navigate based on role using named routes so bindings run
      if (role != null && role.toLowerCase().trim() == "admin") {
        print('🔐 Navigating to Admin Panel');
        Get.offAllNamed(AppRoutes.adminbottomnav);
      } else {
        print('🔐 Navigating to User Panel');
        Get.offAllNamed(AppRoutes.bottomNav);
      }
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
      print('🔐 Login Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void goToRegister() {
    Get.toNamed('/register');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
