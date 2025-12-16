import 'package:ecommerce_urban/api/controller/cart_controler.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/product_card_widget.dart';
import 'package:ecommerce_urban/modules/user/user_home/widget/banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/modules/user/user_home/user_home_controller.dart';

class UserHomeView extends StatelessWidget {

  final UserHomeController controller = Get.put(UserHomeController());

  @override
  Widget build(BuildContext context) {
    controller.fetchProductsByCategory(null);
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Column(
        children: [
          _buildBanner(),
          SizedBox(height: AppSpacing.paddingM),
          _buildCategoryList(),
          _buildProductList(),
        ],
      ),
    );
  }

  Widget _buildBanner(){
    return BannerWidget(
      imageUrl: "https://picsum.photos/800/300",
    );
  }

  Widget _buildCategoryList(){
    return SizedBox(
      height: 60,
      child: Obx(() {
        if (controller.isCategoryLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Add "All" as first item
        final totalItems = controller.categories.length + 1;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(8),
          itemCount: totalItems,
          itemBuilder: (context, index) {
            bool isAll = index == 0;
            final category = isAll ? null : controller.categories[index - 1];
            final categoryId = isAll ? null : category!.id;
            final categoryName = isAll ? "All" : category!.name.toString() ?? "Unknown";

            // Check selected
            final isSelected = controller.selectedCategoryId.value == categoryId;

            return GestureDetector(
              onTap: () {
                controller.selectedCategoryId.value = categoryId;
                controller.fetchProductsByCategory(categoryId);
              },
              child: Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueAccent : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    categoryName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildProductList(){
    return Expanded(
      child: Obx(() {
        if (controller.isProductLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return Center(child: Text("No products found"));
        }

        return GridView.builder(
          padding: EdgeInsets.all(AppSpacing.paddingSM),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ProductCardWidget(
              name: product.name.toString(),
              description: product.description.toString(),
              price: product.price.toString(),
              imageUrl: product.image.toString(),
              onAddToCartTap: (){
                final controller = Get.put(CartController());
                controller.addProductToCart(productId: product.id, quantity: 1);
              },
              onTap: (){

              },
            );
          },
        );
      }),
    );
  }
}