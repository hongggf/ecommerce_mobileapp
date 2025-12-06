import 'package:ecommerce_urban/modules/admin_products/admin_products_controller.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminProductsListView extends StatelessWidget {
  final controller = Get.find<AdminProductsController>();

  AdminProductsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Management'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerLoadingList();
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${controller.errorMessage.value}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.fetchCategories();
                    controller.fetchProducts();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Category Filter Tabs
            Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // All Products button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: const Text('All Products'),
                        selected: controller.selectedCategoryId.value == null,
                        onSelected: (selected) {
                          if (selected) {
                            controller.selectCategory(null);
                          }
                        },
                        backgroundColor: Colors.grey.shade200,
                        selectedColor: Colors.blue.shade700,
                        labelStyle: TextStyle(
                          color: controller.selectedCategoryId.value == null
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    // Category chips
                    ...controller.categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(category.name),
                          selected: controller.selectedCategoryId.value ==
                              category.id,
                          onSelected: (selected) {
                            if (selected) {
                              controller.selectCategory(category.id);
                            }
                          },
                          backgroundColor: Colors.grey.shade200,
                          selectedColor: Colors.blue.shade700,
                          labelStyle: TextStyle(
                            color: controller.selectedCategoryId.value ==
                                    category.id
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            )),
            // Products List
            Expanded(
              child: Obx(() {
                final filteredProducts = controller.getFilteredProducts();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _buildProductCard(product);
                  },
                );
              }),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/product_management');
        },
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Shimmer loading skeleton for products list
  Widget _buildShimmerLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header shimmer
              Container(
                color: Colors.blue.shade50,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(width: 200, height: 16),
                    const SizedBox(height: 8),
                    _buildShimmerBox(width: 100, height: 24),
                  ],
                ),
              ),
              // Description shimmer
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    _buildShimmerBox(width: 250, height: 14),
                  ],
                ),
              ),
              // Variants count shimmer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildShimmerBox(width: 80, height: 14),
              ),
              // Action buttons shimmer
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _buildShimmerBox(width: 80, height: 36),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildShimmerBox(width: 80, height: 36),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: product.status == 'active'
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.status,
                          style: TextStyle(
                            fontSize: 12,
                            color: product.status == 'active'
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              product.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Variants count
          if (product.variants != null && product.variants!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '${product.variants?.length ?? 0} Variants',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.toNamed('/product_management', arguments: product);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDeleteDialog(product.id!),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Individual shimmer box
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

  void _showDeleteDialog(int productId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: const Text(
            'Are you sure you want to delete this product? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteProduct(productId);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}