// lib/modules/product/product_detail/product_detail_screen.dart

import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/app/constants/app_fontsizes.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/modules/product/product_detail/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key});
  final ProductDetailController controller = Get.put(ProductDetailController());
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.product.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.product.value == null) {
          return const Center(child: Text('Product not found'));
        }

        return CustomScrollView(
          slivers: [
            _buildAppBar(controller),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSpacing.paddingM),
                  _buildProductInfo(controller),
                  SizedBox(height: AppSpacing.paddingM),
                  if (controller.sizes.isNotEmpty) ...[
                    _buildSizeSelector(controller),
                    SizedBox(height: AppSpacing.paddingM),
                  ],
                  _buildDescription(controller),
                  SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() => controller.product.value != null
          ? _buildBottomBar(controller)
          : const SizedBox.shrink()),
    );
  }

  Widget _buildAppBar(ProductDetailController controller) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back),
        ),
        onPressed: () => Get.back(),
      ),
      actions: [
        Obx(() => IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  controller.isFavorite.value
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                ),
              ),
              onPressed: controller.toggleFavorite,
            )),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Obx(() => PageView.builder(
              controller: pageController,
              onPageChanged: (index) {
                controller.selectedImageIndex.value = index;
              },
              itemCount: controller.productImages.length,
              itemBuilder: (context, index) {
                return Image.network(
                  controller.productImages[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, size: 100),
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget _buildProductInfo(ProductDetailController controller) {
    final product = controller.product.value!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: TextStyle(
              fontSize: AppFontSize.headlineMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Row(
                children: [
                  Text(
                    '\$${controller.currentPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildSizeSelector(ProductDetailController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Size/Variant',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 12,
                children: controller.sizes.map((size) {
                  final isSelected = controller.selectedSize.value == size;
                  return GestureDetector(
                    onTap: () => controller.selectSize(size),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          size,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }

  Widget _buildDescription(ProductDetailController controller) {
    final product = controller.product.value!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description ?? 'No description available',
            style: const TextStyle(
              height: 1.5,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ProductDetailController controller) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Quantity Selector
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: controller.decrementQuantity,
                  ),
                  Obx(() => Text(
                        '${controller.quantity.value}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: controller.incrementQuantity,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Add to Cart Button
            Expanded(
              child: ElevatedButton(
                onPressed: controller.addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}