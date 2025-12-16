// import 'package:ecommerce_urban/api/model/address_model.dart';
// import 'package:ecommerce_urban/app/constants/app_spacing.dart';
// import 'package:ecommerce_urban/app/widgets/title_widget.dart';
// import 'package:ecommerce_urban/modules/user/user_cart/user_cart_controller.dart';
// import 'package:ecommerce_urban/modules/user/user_cart/widget/cart_item_card_widget.dart';
// import 'package:ecommerce_urban/modules/user/user_checkout/user_checkout_controller.dart';
// import 'package:ecommerce_urban/route/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class UserCheckoutView extends StatelessWidget {

//   final UserCheckoutController controller = Get.put(UserCheckoutController());
//   final UserCartController userCartController = Get.put(UserCartController());

//   UserCheckoutView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: controller.fetchDefaultAddress,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(AppSpacing.paddingSM),
//         child: Column(
//           children: [
//             _buildAddress(context),
//             SizedBox(height: AppSpacing.paddingL),
//             Flexible(
//               flex: 2,
//               child: _buildCardItem(),
//             ),
//             Expanded(
//               child: _buildSummary()
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddress(BuildContext context){
//     return Column(
//       children: [
//         TitleWidget(title: "Address"),
//         Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final AddressModel? address = controller.defaultAddress.value;
//           if (address == null) {
//             return const Center(child: Text("No default address found."));
//           }

//           return Card(
//             child: Padding(
//               padding: EdgeInsets.all(AppSpacing.paddingSM),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             address.fullName.toString(),
//                             style: Theme.of(context).textTheme.titleMedium,
//                           ),
//                           Text(
//                             "${address.street.toString()} ${address.district.toString()} ${address.province.toString()}",
//                             style: Theme.of(context).textTheme.bodyMedium,
//                           ),
//                           Text(
//                             "Phone: ${address.phone.toString()}",
//                             style: Theme.of(context).textTheme.bodyMedium,
//                           ),
//                         ],
//                       ),
//                       GestureDetector(
//                         onTap: (){
//                           Get.toNamed(AppRoutes.userAddress);
//                         },
//                         child: Icon(Icons.edit),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );

//         }),
//       ],
//     );
//   }

//   Widget _buildCardItem(){
//     return Column(
//       children: [
//         TitleWidget(title: "Product Items"),
//         Expanded(
//           child: Obx(() {
//             if (userCartController.isLoading.value) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (userCartController.cartItems.isEmpty) {
//               return const Center(child: Text('Cart is empty'));
//             }

//             return ListView.builder(
//               itemCount: userCartController.cartItems.length,
//               itemBuilder: (context, index) {
//                 final item = userCartController.cartItems[index];

//                 return CartItemCardWidget(
//                   item: item,
//                   onIncrement: () {
//                     // userCartController.updateCartItem(item.id, item.quantity + 1);
//                   },
//                   onDecrement: () {
//                     if (item.quantity > 1) {
//                       // userCartController.updateCartItem(item.id, item.quantity - 1);
//                     }
//                   },
//                   onRemove: () {
//                     userCartController.removeCartItem(item.id);
//                   }
//                 );
//               },
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildSummary(){
//     return Column(
//       children: [
//         TitleWidget(title: "Summary"),
//       ],
//     );
//   }
// }

import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:ecommerce_urban/modules/user/user_cart/user_cart_controller.dart';
import 'package:ecommerce_urban/modules/user/user_cart/widget/cart_item_card_widget.dart';

import 'package:ecommerce_urban/modules/user/user_checkout/user_checkout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCheckoutView extends StatelessWidget {
  final UserCheckoutController controller = Get.put(UserCheckoutController());
  final UserCartController userCartController = Get.find<UserCartController>();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.paddingSM),
          child: Column(
            children: [
              _buildAddress(context),
              SizedBox(height: AppSpacing.paddingL),
              _buildCartItems(context),
              SizedBox(height: AppSpacing.paddingL),
              _buildSummary(context),
              SizedBox(height: AppSpacing.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: 'Delivery Address'),
        SizedBox(height: AppSpacing.paddingS),
        Obx(() {
          if (controller.isLoadingAddress.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final address = controller.defaultAddress.value;
          if (address == null) {
            return const Center(child: Text('No address found'));
          }

          return Container(
            padding: EdgeInsets.all(AppSpacing.paddingSM),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue[700]),
                SizedBox(width: AppSpacing.paddingS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.fullName ?? 'Name',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${address.street}, ${address.district}, ${address.province}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Phone: ${address.phone}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: controller.changeAddress,
                  child: Icon(Icons.edit, color: Colors.blue[700]),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCartItems(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: 'Product Items'),
        SizedBox(height: AppSpacing.paddingS),
        Obx(() {
          if (userCartController.isLoading.value) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (userCartController.cartItems.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: Text('Cart is empty')),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userCartController.cartItems.length,
            itemBuilder: (context, index) {
              final item = userCartController.cartItems[index];
              return CartItemCardWidget(
                item: item,
                onIncrement: () {
                  userCartController.incrementQuantity(item.id ?? 0);
                },
                onDecrement: () {
                  if ((item.quantity ?? 0) > 1) {
                    userCartController.decrementQuantity(item.id ?? 0);
                  }
                },
                onRemove: () {
                  userCartController.removeCartItem(item.id ?? 0);
                },
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: 'Summary'),
        SizedBox(height: AppSpacing.paddingS),
        Obx(() {
          return Container(
            padding: EdgeInsets.all(AppSpacing.paddingSM),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  'Subtotal',
                  '\$${controller.subtotal.value.toStringAsFixed(2)}',
                ),
                SizedBox(height: AppSpacing.paddingS),
                _buildSummaryRow(
                  'Shipping',
                  controller.shippingFee.value == 0
                      ? 'FREE'
                      : '\$${controller.shippingFee.value.toStringAsFixed(2)}',
                  color:
                      controller.shippingFee.value == 0 ? Colors.green : null,
                ),
                SizedBox(height: AppSpacing.paddingS),
                _buildSummaryRow(
                  'Tax',
                  '\$${controller.getTaxAmount().toStringAsFixed(2)}',
                ),
                Divider(height: 16),
                _buildSummaryRow(
                  'Total',
                  '\$${controller.totalAmount.value.toStringAsFixed(2)}',
                  isTotal: true,
                ),
                SizedBox(height: AppSpacing.paddingM),
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isPlacingOrder.value
                          ? null
                          : () async {
                              final success = await controller.placeOrder();
                              if (success) {
                                Get.toNamed('/order-confirmation');
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        disabledBackgroundColor: Colors.grey[400],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: controller.isPlacingOrder.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Place Order',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isTotal ? 15 : 13,
            color: isTotal ? Colors.blue : color,
          ),
        ),
      ],
    );
  }
}
