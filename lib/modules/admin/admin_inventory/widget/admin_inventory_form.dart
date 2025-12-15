import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:ecommerce_urban/modules/admin/admin_category/admin_category_controller.dart';
import 'package:ecommerce_urban/modules/admin/admin_inventory/admin_inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminInventoryForm extends StatelessWidget {
  final AdminInventoryController controller;
  final _formKey = GlobalKey<FormState>();

  AdminInventoryForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.editingProductId.value != null;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.paddingSM),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
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
              TitleWidget(title: isEditing ? "Edit Product" : "Create Product"),
              SizedBox(height: AppSpacing.paddingM),

              // Product Name
              _buildTextField(
                controller: controller.nameController,
                label: "Product Name",
                validator: "Name is required",
              ),

              // Description
              _buildTextField(
                controller: controller.descController,
                label: "Description",
                maxLines: 3,
              ),

              // Price
              _buildTextField(
                controller: controller.priceController,
                label: "Price",
                keyboardType: TextInputType.number,
                validator: "Price is required",
              ),

              // Compare Price
              _buildTextField(
                controller: controller.comparePriceController,
                label: "Compare Price",
                keyboardType: TextInputType.number,
              ),

              // Stock Quantity
              _buildTextField(
                controller: controller.stockController,
                label: "Stock Quantity",
                keyboardType: TextInputType.number,
              ),

              // Low Stock Alert
              _buildTextField(
                controller: controller.lowStockController,
                label: "Low Stock Alert",
                keyboardType: TextInputType.number,
              ),

              // Category Dropdown
              _buildCategoryDropdown(),

              SizedBox(height: AppSpacing.paddingM),

              // Image Picker
              _buildImagesSection(),

              SizedBox(height: AppSpacing.paddingL),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await controller.submitProductForm();
                      Get.back();
                    }
                  },
                  child: Text(isEditing ? "Update Product" : "Create Product"),
                ),
              ),
              SizedBox(height: AppSpacing.paddingL),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- TEXT FIELD ----------------
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: validator == null
            ? null
            : (v) => v == null || v.trim().isEmpty ? validator : null,
      ),
    );
  }

  /// ---------------- CATEGORY DROPDOWN ----------------
  Widget _buildCategoryDropdown() {
    final categoryController = Get.find<AdminCategoryController>();

    return Obx(() {
      if (categoryController.isLoading.value) {
        return const CircularProgressIndicator();
      }

      return DropdownButtonFormField<int>(
        value: controller.selectedCategoryId.value,
        decoration: const InputDecoration(labelText: "Category"),
        items: categoryController.categories.map((c) {
          return DropdownMenuItem<int>(
            value: c.id,
            child: Text(c.name.toString()),
          );
        }).toList(),
        onChanged: (value) {
          controller.selectedCategoryId.value = value;
        },
        validator: (value) {
          if (value == null) return "Category is required";
          return null;
        },
      );
    });
  }

  /// ---------------- IMAGE PICKER SECTION ----------------
  Widget _buildImagesSection() {
    return Obx(() {
      final isEditing = controller.editingProductId.value != null;
      final hasNewImage = controller.imageFile != null;

      // Only show old image if editing and no new image picked
      final existingImage = isEditing && !hasNewImage
          ? controller.products
          .firstWhere((p) => p.id == controller.editingProductId.value)
          .image
          : null;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Product Image", style: Get.textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              // New picked image
              if (controller.imageFile.value != null)
                Stack(
                  children: [
                    Image.file(
                      controller.imageFile.value!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 0,
                      child: InkWell(
                        onTap: () => controller.imageFile.value = null,
                        child: const CircleAvatar(
                          radius: 10,
                          child: Icon(Icons.close, size: 12),
                        ),
                      ),
                    ),
                  ],
                )

              // Existing product image
              else if (existingImage != null && existingImage.isNotEmpty)
                Image.network(
                  existingImage,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  ),
                )
              // No image
              else
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image),
                ),
              const SizedBox(width: 8),
              // Pick new image button
              InkWell(
                onTap: controller.pickImage,
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  /// ---------------- SHOW FORM ----------------
  static void show({required AdminInventoryController controller}) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (_) => AdminInventoryForm(controller: controller),
    );
  }
}