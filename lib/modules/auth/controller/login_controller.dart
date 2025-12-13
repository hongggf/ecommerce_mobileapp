import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../app/constants/app_colors.dart';

class LoginController extends GetxController {

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var obscurePassword = true.obs;

  void login() {
    String email = emailController.text;
    String password = passwordController.text;
    ToastWidget.show(message: "Login Success");
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }
}