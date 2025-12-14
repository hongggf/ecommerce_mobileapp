import 'package:ecommerce_urban/api/controller/auth_controller.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {

  final AuthController authController = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var obscurePassword = true.obs;

  void login() {
    String email = emailController.text;
    String password = passwordController.text;
    if (formKey.currentState!.validate()) {
      authController.login(email, password);
    }
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }
}