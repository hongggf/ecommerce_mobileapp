import 'package:ecommerce_urban/app/modules/bottom_nav/bottom_controller.dart';
import 'package:ecommerce_urban/app/modules/auth/controller/auth_controller.dart';
import 'package:ecommerce_urban/app/modules/home/controller/category_controller.dart';
import 'package:ecommerce_urban/app/modules/home/controller/product_controller.dart';
import 'package:ecommerce_urban/app/modules/home/widgets/slider_widget.dart';
import 'package:ecommerce_urban/app/modules/home/home_controller.dart';
import 'package:ecommerce_urban/app/modules/productDetail/productDetailScreen.dart';
import 'package:ecommerce_urban/core/constants/app_colors.dart';
import 'package:ecommerce_urban/core/constants/app_fontsizes.dart';
import 'package:ecommerce_urban/core/constants/app_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final HomeController homeController = Get.find<HomeController>();
  final BottomNavController bottomController = Get.find<BottomNavController>();
  final AuthController auth = Get.find<AuthController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecommerce Urbans'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              // TODO: Navigate to Cart Screen
            },
          ),
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: const DrawerHeader(
          decoration: BoxDecoration(),
          child: Text(
            'Menu',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SliderWidget(),
            const SizedBox(height: 20),

            /// CATEGORY LIST
            Obx(() {
              if (categoryController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryController.categories[index];
                    final isSelected = homeController.selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        homeController.selectedIndex1 = index;
                        // Optional: Filter products here
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(),
                        ),
                        child: Text(
                          category.name.toUpperCase(),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBackground),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "🛍️ Water Festival Steals",
                  style: TextStyle(
                      // color: AppColors.secondary,
                      fontSize: AppFontSize.headlineSmall,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text("shop more", ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              ],
            ),

            /// PRODUCT GRID
            Obx(() {
              if (productController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productController.productList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.67,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                ),
                itemBuilder: (context, index) {
                  final product = productController.productList[index];
                  final discountedPrice = product.price -
                      (product.price * product.discountPercentage / 100);

                  return GestureDetector(
                    onTap: () =>
                        Get.to(() => ProductDetailScreen(product: product)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// PRODUCT IMAGE
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(product.images.first),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// PRICE
                        Row(
                          children: [
                            Text(
                              "\$${discountedPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                // color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "\$${product.price}",
                              style: const TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                //color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 3),

                        /// TITLE
                        Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              // fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
