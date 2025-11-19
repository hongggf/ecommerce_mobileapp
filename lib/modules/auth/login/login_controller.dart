import 'package:ecommerce_urban/app/services/auth_services.dart';
import 'package:ecommerce_urban/modules/auth/auth_model.dart';
import 'package:ecommerce_urban/modules/bottom_nav/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter username and password');
      return;
    }

    try {
      isLoading.value = true;
      final AuthModel user = await _authService.login(username, password);

      Get.snackbar('Success', 'Welcome ${user.username}');
      Get.offAll(() => BottomNav());

      // Save token to storage later if needed
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  } // check if user already logged in

  

  void goToRegister() {
    Get.toNamed('/register');
  }
}
