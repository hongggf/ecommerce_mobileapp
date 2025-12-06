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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Product Variants'),
            ElevatedButton.icon(
              onPressed: () {
                variantNameController.clear();
                variantSkuController.clear();
                variantPriceController.clear();
                controller.openVariantForm();
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Variant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.showVariantForm.value) {
            return VariantFormWidget(
              controller: controller,
              variantNameController: variantNameController,
              variantSkuController: variantSkuController,
              variantPriceController: variantPriceController,
            );
          }
          return const SizedBox.shrink();
        }),
        Obx(() {
          if (controller.isLoadingVariants.value) {
            return _buildVariantsShimmer();
          }

          if (controller.variants.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No variants yet. Create one to get started!',
                  style: TextStyle(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildVariantsShimmer() {
    return Column(
      children: List.generate(
        3,
        (index) => Card(
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
                          _buildShimmerBox(width: 150, height: 16),
                          const SizedBox(height: 8),
                          _buildShimmerBox(width: 100, height: 12),
                        ],
                      ),
                    ),
                    _buildShimmerBox(width: 60, height: 24),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerBox(width: 80, height: 20),
                    Row(
                      children: [
                        _buildShimmerBox(width: 70, height: 36),
                        const SizedBox(width: 8),
                        _buildShimmerBox(width: 70, height: 36),
                        const SizedBox(width: 8),
                        _buildShimmerBox(width: 70, height: 36),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
      child: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.grey.shade300,
              Colors.grey.shade100,
              Colors.grey.shade300,
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds);
        },
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}