import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/modules/admin_products/widget/VaraintCardWidget.dart';
import 'package:ecommerce_urban/modules/admin_products/widget/VariantFormWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';

class VariantsSectionWidget extends StatelessWidget {
  final ProductManagementController controller;
  final ImagePicker picker;
  final TextEditingController variantNameController;
  final TextEditingController variantSkuController;
  final TextEditingController variantPriceController;

  const VariantsSectionWidget({
    required this.controller,
    required this.picker,
    required this.variantNameController,
    required this.variantSkuController,
    required this.variantPriceController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Add Button
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.layers_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Variants',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Manage product variations',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              FilledButton.icon(
                onPressed: () {
                  variantNameController.clear();
                  variantSkuController.clear();
                  variantPriceController.clear();
                  controller.openVariantForm();
                },
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Variant Form (if visible)
        Obx(() {
          if (controller.showVariantForm.value) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: VariantFormWidget(
                controller: controller,
                variantNameController: variantNameController,
                variantSkuController: variantSkuController,
                variantPriceController: variantPriceController,
              ),
            );
          }
          return const SizedBox.shrink();
        }),

        // Variants List
        Obx(() {
          if (controller.isLoadingVariants.value) {
            return _buildVariantsShimmer(isDark);
          }

          if (controller.variants.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey[800]
                            : Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 48,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No Variants Yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first variant to get started',
                      style: TextStyle(
                        color: isDark ? Colors.grey[500] : Colors.grey[600],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.variants.length,
            itemBuilder: (context, index) {
              final variant = controller.variants[index];
              return VariantCardWidget(
                variant: variant,
                controller: controller,
                variantNameController: variantNameController,
                variantSkuController: variantSkuController,
                variantPriceController: variantPriceController,
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildVariantsShimmer(bool isDark) {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
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
                        _buildShimmerBox(180, 16, isDark),
                        const SizedBox(height: 10),
                        _buildShimmerBox(120, 14, isDark),
                      ],
                    ),
                  ),
                  _buildShimmerBox(70, 28, isDark),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShimmerBox(90, 24, isDark),
                  Row(
                    children: [
                      _buildShimmerBox(80, 36, isDark),
                      const SizedBox(width: 8),
                      _buildShimmerBox(70, 36, isDark),
                      const SizedBox(width: 8),
                      _buildShimmerBox(80, 36, isDark),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height, bool isDark) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: isDark
                ? [
                    Colors.grey[800]!,
                    Colors.grey[700]!,
                    Colors.grey[800]!,
                  ]
                : [
                    Colors.grey[300]!,
                    Colors.grey[100]!,
                    Colors.grey[300]!,
                  ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}