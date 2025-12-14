import 'package:ecommerce_urban/api/controller/auth_controller.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Obscure password toggle
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  // Role (customer by default)
  final role = 'customer'.obs;

  // Toggle password visibility
  void togglePassword() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPassword() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  // Submit register
  void register() {
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ToastWidget.show(
          type: "error",
          message: "Passwords do not match",
        );
        return;
      }

      authController.register(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
          phone: phoneController.text,
          role: "customer"
      );

      // Clear fields
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}