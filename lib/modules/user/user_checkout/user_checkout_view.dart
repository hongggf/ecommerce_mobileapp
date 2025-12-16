import 'package:ecommerce_urban/api/model/address_model.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:ecommerce_urban/modules/user/user_cart/user_cart_controller.dart';
import 'package:ecommerce_urban/modules/user/user_cart/widget/cart_item_card_widget.dart';
import 'package:ecommerce_urban/modules/user/user_checkout/user_checkout_controller.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCheckoutView extends StatelessWidget {

  final UserCheckoutController controller = Get.put(UserCheckoutController());
  final UserCartController userCartController = Get.put(UserCartController());

  UserCheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchDefaultAddress,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingSM),
        child: Column(
          children: [
            _buildAddress(context),
            SizedBox(height: AppSpacing.paddingL),
            Flexible(
              flex: 2,
              child: _buildCardItem(),
            ),
            Expanded(
              child: _buildSummary()
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddress(BuildContext context){
    return Column(
      children: [
        TitleWidget(title: "Address"),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final AddressModel? address = controller.defaultAddress.value;
          if (address == null) {
            return const Center(child: Text("No default address found."));
          }

          return Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.paddingSM),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.fullName.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "${address.street.toString()} ${address.district.toString()} ${address.province.toString()}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            "Phone: ${address.phone.toString()}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          Get.toNamed(AppRoutes.userAddress);
                        },
                        child: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );

        }),
      ],
    );
  }

  Widget _buildCardItem(){
    return Column(
      children: [
        TitleWidget(title: "Product Items"),
        Expanded(
          child: Obx(() {
            if (userCartController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (userCartController.cartItems.isEmpty) {
              return const Center(child: Text('Cart is empty'));
            }

            return ListView.builder(
              itemCount: userCartController.cartItems.length,
              itemBuilder: (context, index) {
                final item = userCartController.cartItems[index];

                return CartItemCardWidget(
                  item: item,
                  onIncrement: () {
                    // userCartController.updateCartItem(item.id, item.quantity + 1);
                  },
                  onDecrement: () {
                    if (item.quantity > 1) {
                      // userCartController.updateCartItem(item.id, item.quantity - 1);
                    }
                  },
                  onRemove: () {
                    userCartController.removeCartItem(item.id);
                  }
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSummary(){
    return Column(
      children: [
        TitleWidget(title: "Summary"),
      ],
    );
  }
}