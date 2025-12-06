import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';

class ProductFormWidget extends StatelessWidget {
  final ProductManagementController controller;
  final TextEditingController productNameController;
  final TextEditingController productDescriptionController;

  const ProductFormWidget({
    required this.controller,
    required this.productNameController,
    required this.productDescriptionController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Product Information'),
        const SizedBox(height: 16),
        TextField(
          controller: productNameController,
          onChanged: (value) => controller.productName.value = value,
          decoration: InputDecoration(
            labelText: 'Product Name',
            hintText: 'Enter product name',
            prefixIcon: const Icon(Icons.production_quantity_limits),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: productDescriptionController,
          onChanged: (value) => controller.productDescription.value = value,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Description',
            hintText: 'Enter product description',
            prefixIcon: const Icon(Icons.description),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Category'),
        const SizedBox(height: 16),
        Obx(() => DropdownButton<int>(
          isExpanded: true,
          hint: const Text('Select Category'),
          value: controller.selectedCategoryId.value,
          items: controller.categories.map((category) {
            return DropdownMenuItem<int>(
              value: category.id,
              child: Text(category.name),
            );
          }).toList(),
          onChanged: (value) {
            controller.selectedCategoryId.value = value;
          },
        )),
        const SizedBox(height: 24),
        _buildSectionTitle('Status'),
        const SizedBox(height: 16),
        Obx(() => Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Active'),
                value: 'active',
                groupValue: controller.productStatus.value,
                onChanged: (value) {
                  controller.productStatus.value = value ?? 'active';
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Inactive'),
                value: 'inactive',
                groupValue: controller.productStatus.value,
                onChanged: (value) {
                  controller.productStatus.value = value ?? 'active';
                },
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}