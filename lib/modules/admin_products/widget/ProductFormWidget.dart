import 'package:ecommerce_urban/app/constants/app_colors.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Product Information', Icons.inventory_2_rounded, isDark),
        const SizedBox(height: 20),
        
        // Product Name Field
        _buildModernTextField(
          controller: productNameController,
          label: 'Product Name',
          hint: 'Enter product name',
          icon: Icons.shopping_bag_rounded,
          onChanged: (value) => controller.productName.value = value,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        
        // Product Description Field
        _buildModernTextField(
          controller: productDescriptionController,
          label: 'Description',
          hint: 'Enter product description',
          icon: Icons.description_rounded,
          maxLines: 5,
          onChanged: (value) => controller.productDescription.value = value,
          isDark: isDark,
        ),
        const SizedBox(height: 28),
        
        _buildSectionHeader('Category', Icons.category_rounded, isDark),
        const SizedBox(height: 16),
        
        // Category Dropdown
        Obx(() => Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  hint: Row(
                    children: [
                      Icon(
                        Icons.category_rounded,
                        size: 20,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Select Category',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  value: controller.selectedCategoryId.value,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  items: controller.categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Row(
                        children: [
                          Icon(
                            Icons.label_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            category.name,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedCategoryId.value = value;
                  },
                ),
              ),
            )),
        const SizedBox(height: 28),
        
        _buildSectionHeader('Product Status', Icons.toggle_on_rounded, isDark),
        const SizedBox(height: 16),
        
        // Status Selection
        Obx(() => Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
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
                      controller.productStatus.value == 'active',
                      (value) {
                        controller.productStatus.value = value ?? 'active';
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
                      controller.productStatus.value == 'inactive',
                      (value) {
                        controller.productStatus.value = value ?? 'active';
                      },
                      isDark,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
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
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.grey[900],
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    required bool isDark,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: maxLines,
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
          fillColor: isDark ? Colors.grey[850] : Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
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
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? color : (isDark ? Colors.grey[500] : Colors.grey[400]),
              ),
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
            const SizedBox(width: 8),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 18,
                color: color,
              ),
          ],
        ),
      ),
    );
  }
}