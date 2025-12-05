import 'package:ecommerce_urban/app/services/auth_services.dart';
import 'package:ecommerce_urban/modules/auth/auth_model.dart';

import 'package:ecommerce_urban/modules/bottom_nav/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }

    if (!email.contains('@')) {
      Get.snackbar('Error', 'Please enter valid email');
      return;
    }

    try {
      isLoading.value = true;
      final AuthModel user = await _authService.login(email, password);

      Get.snackbar('Success', 'Welcome ${user.fullName}');
      Get.offAll(() => BottomNav());
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed('/register');
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }
}