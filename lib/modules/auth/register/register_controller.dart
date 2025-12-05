import 'package:ecommerce_urban/app/services/auth_services.dart';
import 'package:ecommerce_urban/modules/auth/auth_model.dart';

import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final AuthService _authService = AuthService();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> register() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validation
    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (!email.contains('@')) {
      Get.snackbar('Error', 'Please enter valid email');
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }

    if (phone.length < 5) {
      Get.snackbar('Error', 'Please enter valid phone number');
      return;
    }

    try {
      isLoading.value = true;
      final AuthModel user = await _authService.register(
        fullName,
        email,
        password,
        phone,
      );

      Get.snackbar(
          'Success', 'Registration successful! Welcome ${user.fullName}');
      Get.delete<RegisterController>(); // <- manually dispose
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar('Registration Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  
}
