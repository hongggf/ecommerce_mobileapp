import 'dart:io';
import 'package:ecommerce_urban/app/helper/image_helper.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/api/model/user_profile_model.dart';
import 'package:ecommerce_urban/api/service/user_profile_service.dart';

class AdminProfileController extends GetxController {
  final UserProfileService _service = UserProfileService();

  var isLoading = false.obs;
  var user = Rxn<UserProfileModel>();

  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final roleController = TextEditingController();

  var avatarFile = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final data = await _service.fetchMe();
      user.value = data;

      nameController.text = data.name;
      emailController.text = data.email;
      phoneController.text = data.phone;
      roleController.text = data.role;
    } finally {
      isLoading.value = false;
    }
  }

  /// Pick avatar image
  Future<void> pickAvatar() async {
    avatarFile.value = await ImageHelper.pickFromGallery();
  }

  /// Update profile
  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final updated = await _service.updateMe(
        name: nameController.text,
        phone: phoneController.text,
        avatar: avatarFile.value,
      );

      user.value = updated;
      avatarFile.value = null;

      ToastWidget.show(message: "Profile updated");
    } catch (e) {
      ToastWidget.show(type: 'error', message: "Update failed $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    roleController.dispose();
    super.onClose();
  }
}