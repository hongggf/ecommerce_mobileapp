// lib/modules/product/product_list/product_list_screen.dart

import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/app/constants/app_fontsizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_controller.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({super.key});

  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.categoryName ?? 'Products'),
        actions: [
          IconButton(
            onPressed: _openSortFilterDialog,
            icon: Icon(Icons.filter_alt_outlined),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.loadProducts(refresh: true),
        child: Obx(() {
          if (controller.isLoading.value && controller.products.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.filteredProducts.isEmpty) {
            return Center(
              child: Text(
                "No products found",
                style: TextStyle(fontSize: 16),
              ),
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
              padding: EdgeInsets.all(12),
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
                  return Center(child: CircularProgressIndicator());
                }
                return _buildCard(controller.filteredProducts[index]);
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
          color: Get.isDarkMode
              ? AppColors.darkSurface
              : AppColors.lightBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sort & Filter",
              style: TextStyle(
                fontSize: AppFontSize.headlineSmall,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 25, thickness: 1),
            Text(
              "Sort By",
              style: TextStyle(fontSize: AppFontSize.headlineSmall),
            ),
            const SizedBox(height: 10),
            _buildSortDropdown(),
            const SizedBox(height: 30),
            // Text(
            //   "Filter By",
            //   style: TextStyle(fontSize: AppFontSize.headlineSmall),
            // ),
            const SizedBox(height: 10),
            // _buildFilterDropdown(),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Apply & Close",
                  style: TextStyle(fontSize: AppFontSize.headlineSmall),
                ),
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
              items: [
                "Latest",
                "LowToHigh",
                "HighToLow",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {
                controller.applySort(value!);
              },
            ),
          ),
        ));
  }

  // Widget _buildFilterDropdown() {
  //   return Obx(() => Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.grey.shade300),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<String>(
  //         isExpanded: true,
  //         value: controller.selectedFilter.value,
  //         items: [
  //           "None",
  //           "<50",
  //           "Nike",
  //         ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
  //         onChanged: (value) {
  //           controller.applyFilter(value!);
  //         },
  //       ),
  //     ),
  //   ));
  // }

  Widget _buildCard(product) {
    return GestureDetector(
      onTap: () => controller.goToProductDetail(product),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 12,
              color: Colors.black12.withOpacity(0.08),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    product.primaryImageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 150,
                      color: Colors.grey.shade200,
                      child: Icon(Icons.image, size: 50),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      Get.snackbar(
                        "Wishlist",
                        "${product.name} added to wishlist",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.primary,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "\$${product.lowestPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.snackbar("Cart", "Added ${product.name} to cart");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Add to Cart",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
