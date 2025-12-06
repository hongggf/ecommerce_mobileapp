import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';

class VariantFormWidget extends StatelessWidget {
  final ProductManagementController controller;
  final TextEditingController variantNameController;
  final TextEditingController variantSkuController;
  final TextEditingController variantPriceController;

  const VariantFormWidget({
    required this.controller,
    required this.variantNameController,
    required this.variantSkuController,
    required this.variantPriceController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.selectedVariant.value == null
                  ? 'Add New Variant'
                  : 'Edit Variant',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: variantNameController,
              onChanged: (value) => controller.variantName.value = value,
              decoration: InputDecoration(
                labelText: 'Variant Name',
                hintText: 'e.g., Red - Size L',
                prefixIcon: const Icon(Icons.label),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: variantSkuController,
              onChanged: (value) => controller.variantSku.value = value,
              decoration: InputDecoration(
                labelText: 'SKU',
                hintText: 'e.g., SKU-001-RED-L',
                prefixIcon: const Icon(Icons.qr_code),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: variantPriceController,
              onChanged: (value) => controller.variantPrice.value = value,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                hintText: '0.00',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Active'),
                    value: 'active',
                    groupValue: controller.variantStatus.value,
                    onChanged: (value) {
                      controller.variantStatus.value = value ?? 'active';
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Inactive'),
                    value: 'inactive',
                    groupValue: controller.variantStatus.value,
                    onChanged: (value) {
                      controller.variantStatus.value = value ?? 'active';
                    },
                  ),
                ),
              ],
            )),
            const SizedBox(height: 16),
            Obx(() => Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.closeVariantForm(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.saveVariant(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                        : const Text('Save Variant'),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}