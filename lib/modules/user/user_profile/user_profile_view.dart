import 'dart:io';
import 'package:ecommerce_urban/api/controller/auth_controller.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/modules/admin/admin_profile/admin_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileView extends StatelessWidget {
  UserProfileView({super.key});

  final controller = Get.put(AdminProfileController());
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchProfile,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: authController.logout,
        child: Icon(Icons.logout, color: Colors.red),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user.value;
        if (user == null) return const SizedBox();

        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.paddingSM),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.paddingXL),
              _avatarSection(context, user.avatar),
              SizedBox(height: AppSpacing.paddingXXL),

              _field("Name", controller.nameController),
              _field("Email", controller.emailController, readOnly: true),
              _field("Phone", controller.phoneController),
              _field("Role", controller.roleController, readOnly: true),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.updateProfile,
                child: const Text("Update Profile"),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// ---------- Avatar with edit icon ----------
  Widget _avatarSection(BuildContext context, String avatarUrl) {
    return Center(
      child: Stack(
        children: [
          Obx(() {
            final File? file = controller.avatarFile.value;

            return CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey[300],
              backgroundImage: file != null
                  ? FileImage(file)
                  : (avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null) as ImageProvider?,
              child: file == null && avatarUrl.isEmpty
                  ? Text(
                controller.nameController.text.isNotEmpty
                    ? controller.nameController.text[0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
                  : null,
            );
          }),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: controller.pickAvatar,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
      String label,
      TextEditingController controller, {
        bool readOnly = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}