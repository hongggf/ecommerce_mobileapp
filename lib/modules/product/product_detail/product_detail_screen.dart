import 'package:ecommerce_urban/app/constants/app_fontsizes.dart';
import 'package:ecommerce_urban/app/constants/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/modules/product/product_detail/product_detail_controller.dart';

class ProductDetailScreen extends GetView<ProductDetailController> {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildProductInfo(context),
                  const SizedBox(height: 24),
                  _buildSizeSelector(context),
                  const SizedBox(height: 24),
                  _buildDescription(context),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2))
            ],
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(10),
          child: Obx(() => GestureDetector(
                onTap: controller.toggleFavorite,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Icon(
                    controller.isFavorite.value
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.white,
                    size: AppWidgetSize.iconM,
                  ),
                ),
              )),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Obx(() => PageView.builder(
              onPageChanged: (index) =>
                  controller.selectedImageIndex.value = index,
              itemCount: controller.productImages.length,
              itemBuilder: (context, index) {
                return Image.network(
                  controller.productImages[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(Icons.image, size: AppWidgetSize.imageL),
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.productName,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Obx(() => Text(
                '\$${controller.currentPrice.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: AppFontSize.titleLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary),
              )),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              const Text('4.5 (120 reviews)',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Size',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            controller.productDesc,
            style: TextStyle(height: 1.5, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
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
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: controller.incrementQuantity,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                      fontSize: AppFontSize.titleLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
