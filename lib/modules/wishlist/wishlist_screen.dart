import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/product_card_widget.dart';
import 'package:ecommerce_urban/app/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Wishlist"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(AppSpacing.paddingS),
          child: Column(
            children: [
              SearchCardNavigation(),
              SizedBox(height: AppSpacing.paddingL),
              _wishlistProduct(),
            ],
          ),
        ));
  }

  Widget _wishlistProduct() {
    return Expanded(
      child: GridView.builder(
        itemCount: 10,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          return ProductCardWidget(
            imageUrl: "https://picsum.photos/300",
            title: "Nike Shoes",
            description: "Comfortable running shoes for everyday use.",
            showWishlist: true,
            isWishlisted: index.isEven,
            onTap: () => Get.toNamed('/product_detail'),
            onWishlistTap: () => Get.toNamed('/product_detail'),
          );
        },
      ),
    );
  }
}
