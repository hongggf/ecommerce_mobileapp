import 'package:flutter/material.dart';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_varaint_model.dart';

class VariantCardWidget extends StatelessWidget {
  final ProductVariant variant;
  final ProductManagementController controller;
  final TextEditingController variantNameController;
  final TextEditingController variantSkuController;
  final TextEditingController variantPriceController;

  const VariantCardWidget({
    required this.variant,
    required this.controller,
    required this.variantNameController,
    required this.variantSkuController,
    required this.variantPriceController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        variant.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SKU: ${variant.sku}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: variant.status == 'active'
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    variant.status,
                    style: TextStyle(
                      fontSize: 11,
                      color: variant.status == 'active'
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${variant.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () =>
                          controller.selectVariantForAssets(variant),
                      icon: const Icon(Icons.image, size: 16),
                      label: const Text('Assets'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        variantNameController.text = variant.name;
                        variantSkuController.text = variant.sku;
                        variantPriceController.text = variant.price.toString();
                        controller.openVariantForm(variant);
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _showDeleteDialog(context, variant),
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ProductVariant variant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Variant'),
        content: const Text('Are you sure you want to delete this variant?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteVariant(variant);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}