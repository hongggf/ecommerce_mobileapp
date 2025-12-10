import 'package:ecommerce_urban/app/constants/app_colors.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    controller.selectedVariant.value == null
                        ? Icons.add_rounded
                        : Icons.edit_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  controller.selectedVariant.value == null
                      ? 'Add New Variant'
                      : 'Edit Variant',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Variant Name
            _buildTextField(
              controller: variantNameController,
              label: 'Variant Name',
              hint: 'e.g., Red - Size L',
              icon: Icons.label_rounded,
              onChanged: (value) => controller.variantName.value = value,
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            
            // SKU
            _buildTextField(
              controller: variantSkuController,
              label: 'SKU',
              hint: 'e.g., SKU-001-RED-L',
              icon: Icons.qr_code_rounded,
              onChanged: (value) => controller.variantSku.value = value,
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            
            // Price
            _buildTextField(
              controller: variantPriceController,
              label: 'Price',
              hint: '0.00',
              icon: Icons.attach_money_rounded,
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.variantPrice.value = value,
              isDark: isDark,
            ),
            const SizedBox(height: 20),
            
            // Status Selection
            Text(
              'Status',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatusOption(
                          'Active',
                          'active',
                          Icons.check_circle_rounded,
                          Colors.green,
                          controller.variantStatus.value == 'active',
                          (value) {
                            controller.variantStatus.value = value ?? 'active';
                          },
                          isDark,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: isDark ? Colors.grey[700] : Colors.grey[300],
                      ),
                      Expanded(
                        child: _buildStatusOption(
                          'Inactive',
                          'inactive',
                          Icons.cancel_rounded,
                          Colors.orange,
                          controller.variantStatus.value == 'inactive',
                          (value) {
                            controller.variantStatus.value = value ?? 'active';
                          },
                          isDark,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            
            // Action Buttons
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.closeVariantForm(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.saveVariant(),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: controller.isLoading.value
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
                            : const Icon(Icons.save_rounded, size: 18),
                        label: Text(
                          controller.isLoading.value
                              ? 'Saving...'
                              : 'Save Variant',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    required bool isDark,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.grey[900],
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[600] : Colors.grey[400],
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: isDark ? Colors.grey[900] : Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildStatusOption(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isSelected,
    Function(String?) onChanged,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? color : (isDark ? Colors.grey[600] : Colors.grey[400]),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : Colors.grey[900])
                    : (isDark ? Colors.grey[500] : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}