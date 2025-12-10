import 'package:ecommerce_urban/app/constants/app_fontsizes.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/modules/product/product/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/app/constants/app_colors.dart';

class ProductListScreen extends GetView<ProductController> {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.categoryName.value)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _openSortFilterDialog,
            icon: const Icon(Icons.filter_alt_outlined),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.loadProducts(refresh: true),
        child: Obx(() {
          if (controller.isLoading.value && controller.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.filteredProducts.isEmpty) {
            return Center(
              child: Text('No products found',
                  style: TextStyle(
                      fontSize: AppFontSize.labelLarge,
                      color: AppColors.warning)),
            );
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!controller.isLoading.value &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                controller.loadMore();
              }
              return false;
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.filteredProducts.length +
                  (controller.currentPage.value < controller.lastPage.value
                      ? 1
                      : 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (_, index) {
                if (index == controller.filteredProducts.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildProductCard(controller.filteredProducts[index]);
              },
            ),
          );
        }),
      ),
    );
  }

  void _openSortFilterDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sort & Filter',
                style: TextStyle(
                    fontSize: AppFontSize.headlineSmall,
                    fontWeight: FontWeight.bold)),
            Divider(height: AppSpacing.marginXS),
            Text('Sort By',
                style: TextStyle(
                    fontSize: AppFontSize.headlineSmall,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: AppSpacing.paddingS),
            _buildSortDropdown(),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Apply & Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: controller.selectedSort.value,
              items: ['Latest', 'LowToHigh', 'HighToLow']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.applySort(value);
                }
              },
            ),
          ),
        ));
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => controller.goToProductDetail(product),
      child: Container(
        height: 260, // ← FIXED HEIGHT to avoid overflow
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 12,
              color: Colors.black12.withOpacity(0.08),
            ),
          ],
        ),
        child: Column(
          children: [
            // ---------- IMAGE ----------
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                product.image,
                height: 140, // ← FIXED
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 50),
                ),
              ),
            ),

            // ---------- INFO ----------
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // ---------- ADD TO CART ----------
                    SizedBox(
                      width: double.infinity,
                      height: 32, // ← FIXED BUTTON HEIGHT
                      child: ElevatedButton(
                        onPressed: () {
                          Get.snackbar(
                            'Cart',
                            'Added ${product.name} to cart',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: AppColors.primary,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
