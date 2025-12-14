import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:ecommerce_urban/modules/admin/admin_user/admin_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUserForm extends StatelessWidget {
  final AdminUserController controller;

  const AdminUserForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.editingUserId.value != null;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final _formKey = GlobalKey<FormState>();

    return Padding(
      padding: EdgeInsets.all(AppSpacing.paddingSM),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              TitleWidget(title: isEditing ? "Edit User" : "Create User"),
              SizedBox(height: AppSpacing.paddingSM),

              // Name
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: const OutlineInputBorder(),
                  labelStyle: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onBackground),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.paddingS),

              // Email
              TextFormField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: const OutlineInputBorder(),
                  labelStyle: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onBackground),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email is required";
                  } else if (!GetUtils.isEmail(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.paddingS),

              // Phone
              TextFormField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                  border: const OutlineInputBorder(),
                  labelStyle: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onBackground),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Phone is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.paddingS),

              // Password (only for creating new user)
              if (!isEditing) ...[
                TextFormField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    labelStyle: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onBackground),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.paddingS),
                TextFormField(
                  controller: controller.passwordConfirmController,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: const OutlineInputBorder(),
                    labelStyle: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onBackground),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != controller.passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.paddingS),
              ],

              // Role Dropdown (default customer)
              Obx(() {
                if (controller.role.value.isEmpty) {
                  controller.role.value = "customer"; // default
                }
                return DropdownButtonFormField<String>(
                  value: controller.role.value,
                  decoration: InputDecoration(
                    labelText: "Role",
                    border: const OutlineInputBorder(),
                    labelStyle: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onBackground),
                  ),
                  items: ["customer", "admin"]
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: textTheme.bodyMedium),
                  ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) controller.role.value = v;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Role is required";
                    }
                    return null;
                  },
                );
              }),
              SizedBox(height: AppSpacing.paddingL),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Get.back();
                      controller.submitUserForm();
                    }
                  },
                  child: Text(isEditing ? "Update User" : "Create User"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Call this method to show the bottom sheet
  static void show({required AdminUserController controller}) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (_) => AdminUserForm(controller: controller),
    );
  }
}