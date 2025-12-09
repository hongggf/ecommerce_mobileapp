// lib/modules/dashboard/customer/customer_screen.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_urban/app/constants/app_fontsizes.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/product_card_widget.dart';
import 'package:ecommerce_urban/app/widgets/search_widget.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:ecommerce_urban/modules/dashboard/customer/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final List<Widget> sliderIMG = [
    Image.asset("assets/images/slider1.jpg", fit: BoxFit.cover),
    Image.asset("assets/images/slider2.jpg", fit: BoxFit.cover),
  ];

  final CustomerController controller = Get.find<CustomerController>();
  final currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Mart'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Get.toNamed('/cart'),
              child: Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSpacing.paddingS,
            right: AppSpacing.paddingS,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchCardNavigation(
                onTap: () => Get.toNamed('/search'),
              ),
              SizedBox(height: AppSpacing.paddingS),
              _SliderWidget(),
              SizedBox(height: AppSpacing.paddingL),
              _categorySection(),
              SizedBox(height: AppSpacing.paddingL),
              _popularProductSection(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categorySection() {
    return Obx(() {
      if (controller.isCategoriesLoading.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.categories.isEmpty) {
        return Center(
          child: Text('No categories available'),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(
            title: "Category",
            icon: Icons.arrow_forward_rounded,
            onIconTap: () {
              Get.toNamed('/product', arguments: {
                'categoryName': 'All Categories',
              });
            },
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return GestureDetector(
                  onTap: () => controller.onCategoryTap(index),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.paddingS),
                        child: Center(
                          child: Text(
                            category.name.toUpperCase(),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _popularProductSection() {
    return Obx(() {
      if (controller.isProductsLoading.value) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.popularProducts.isEmpty) {
        return Center(
          child: Text('No products available'),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Popular Products",
                style: TextStyle(
                  fontSize: AppFontSize.titleLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => Get.toNamed('/product', arguments: {
                  'categoryName': 'Popular Products',
                }),
                child: Text(
                  "see all",
                  style: TextStyle(
                    fontSize: AppFontSize.bodyLarge,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.popularProducts.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = controller.popularProducts[index];
                return SizedBox(
                  width: 180,
                  child: ProductCardWidget(
                    imageUrl: product.primaryImageUrl,
                    title: product.name,
                    description: '\$${product.lowestPrice.toStringAsFixed(2)}',
                    showWishlist: true,
                    isWishlisted: false,
                    onTap: () => controller.goToProductDetail(product),
                    onWishlistTap: () => print("Wishlist clicked $index"),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _SliderWidget() {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              currentIndex.value = index;
            },
          ),
          items: sliderIMG.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.amber,
                    child: i,
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 10,
          left: MediaQuery.of(context).size.width * 0.4,
          child: Obx(() => AnimatedSmoothIndicator(
                activeIndex: currentIndex.value,
                count: sliderIMG.length,
                effect: const ExpandingDotsEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                  activeDotColor: Colors.white,
                  dotColor: Colors.black54,
                ),
              )),
        ),
      ],
    );
  }
}