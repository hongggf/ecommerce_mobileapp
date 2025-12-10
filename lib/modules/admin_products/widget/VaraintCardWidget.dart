import 'package:flutter/material.dart';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_varaint_model.dart';
import 'package:ecommerce_urban/app/constants/app_colors.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        variant.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey[800]
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.qr_code_rounded,
                              size: 14,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              variant.sku,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: variant.status == 'active'
                        ? Colors.green.withOpacity(0.15)
                        : Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: variant.status == 'active'
                              ? Colors.green[600]
                              : Colors.orange[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        variant.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          color: variant.status == 'active'
                              ? Colors.green[700]
                              : Colors.orange[700],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Divider
            Divider(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              height: 1,
            ),
            const SizedBox(height: 16),
            
            // Price and Actions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_money_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      Text(
                        variant.price.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.image_rounded,
                      label: 'Assets',
                      onPressed: () => controller.selectVariantForAssets(variant),
                      color: Colors.blue[700]!,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.edit_rounded,
                      label: 'Edit',
                      onPressed: () {
                        variantNameController.text = variant.name;
                        variantSkuController.text = variant.sku;
                        variantPriceController.text = variant.price.toString();
                        controller.openVariantForm(variant);
                      },
                      color: Colors.orange[700]!,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.delete_rounded,
                      label: 'Delete',
                      onPressed: () => _showDeleteDialog(context, variant, isDark),
                      color: Colors.red[700]!,
                      isDark: isDark,
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ProductVariant variant, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(width: 12),
            const Text('Delete Variant'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${variant.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              controller.deleteVariant(variant);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red[700],
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}