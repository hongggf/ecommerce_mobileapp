import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/modules/user/user_cart/user_cart_controller.dart';
import 'package:ecommerce_urban/modules/user/user_cart/widget/cart_item_card_widget.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCartView extends StatelessWidget {
  UserCartView({super.key});

  final UserCartController controller = Get.put(UserCartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchCartItems,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingSM),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.cartItems.isEmpty) {
                    return const Center(child: Text('Cart is empty'));
                  }

                  return ListView.builder(
                    itemCount: controller.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = controller.cartItems[index];

                      return CartItemCardWidget(
                        item: item,
                        onIncrement: () => controller.updateCartItem(item.id, item.quantity + 1),
                        onDecrement: () {
                          if (item.quantity > 1) {
                            controller.updateCartItem(item.id, item.quantity - 1);
                          }
                        },
                        onRemove: () => controller.removeCartItem(item.id),
                      );
                    },
                  );
                }),
            ),
            ElevatedButton(
                onPressed: (){
                  Get.toNamed(AppRoutes.userCheckout);
                },
                child: Text("Checkout")
            )
          ],
        ),
      )
    );
  }
}