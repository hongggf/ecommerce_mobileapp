import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/modules/admin/admin_category/admin_category_controller.dart';

class AdminCategoryForm extends StatelessWidget {
  final AdminCategoryController controller;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  AdminCategoryForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.editingCategoryId.value != null;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.paddingSM),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Top handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              /// Title
              TitleWidget(title: isEditing ? "Edit Category" : "Create Category"),
              SizedBox(height: AppSpacing.paddingSM),

              /// Name
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.paddingS),

              /// Slug
              TextFormField(
                controller: controller.slugController,
                decoration: InputDecoration(
                  labelText: "Slug",
                  // border: const OutlineInputBorder(),
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Slug is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.paddingL),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.back();
                      controller.submitCategoryForm();
                    }
                  },
                  child: Text(
                    isEditing ? "Update Category" : "Create Category",
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.paddingL),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- SHOW BOTTOM SHEET ----------------
  static void show({required AdminCategoryController controller}) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (_) => AdminCategoryForm(controller: controller),
    );
  }
}