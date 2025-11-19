import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/category_list_widget.dart';
import 'package:ecommerce_urban/app/widgets/product_card_widget.dart';
import 'package:ecommerce_urban/app/widgets/search_widget.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:ecommerce_urban/modules/bottom_nav/bottom_controller.dart';
import 'package:ecommerce_urban/modules/auth/auth_controller.dart';
import 'package:ecommerce_urban/modules/dashboard/customer/customer_controller.dart';
import 'package:ecommerce_urban/modules/dashboard/customer/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {

  final CustomerController customerController = Get.find<CustomerController>();
  final BottomNavController bottomController = Get.find<BottomNavController>();
  final AuthController auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Mart'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.paddingS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchCardNavigation(),
            SizedBox(height: AppSpacing.paddingS),
            SliderWidget(),
            SizedBox(height: AppSpacing.paddingL),
            _categorySection(),
            SizedBox(height: AppSpacing.paddingL),
            _popularProductSection(),
          ],
        ),
      ),
    );
  }

  Widget _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          title: "Category",
          icon: Icons.arrow_forward_rounded,
          onIconTap: () {},
        ),
        CategoryListWidget(
          categories: [
            Category(name: "Shoes"),
            Category(name: "Bags"),
            Category(name: "Watches"),
          ],
          selectedIndex: 0,
          onCategoryTap: (index) {
            print("Selected category index: $index");
          },
        ),
      ],
    );
  }

  Widget _popularProductSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(
          title: "Popular Product",
        ),
        SizedBox(
          height: 260, // Height of each product card
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            separatorBuilder: (_, __) => const SizedBox(width: 12),

            itemBuilder: (context, index) {
              return SizedBox(
                width: 180,
                child: ProductCardWidget(
                  imageUrl: "https://picsum.photos/300",
                  title: "Nike Shoes",
                  description: "Comfortable running shoes for everyday use.",
                  showWishlist: true,
                  isWishlisted: index.isEven,
                  onTap: () => print("Product tapped $index"),
                  onWishlistTap: () => print("Wishlist clicked $index"),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

}