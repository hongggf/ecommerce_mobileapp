import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/route/app_routes.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  

  void goToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
