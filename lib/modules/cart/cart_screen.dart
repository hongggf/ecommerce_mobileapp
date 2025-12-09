// lib/modules/cart/views/cart_screen.dart

import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/app/constants/app_fontsizes.dart';
import 'package:ecommerce_urban/modules/cart/cart_controller.dart';
import 'package:ecommerce_urban/modules/order/order_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        centerTitle: true,
        elevation: 1,
        actions: [
          Obx(() {
            if (controller.cartItems.isEmpty) return const SizedBox();
            return IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showClearCartDialog(context),
            );
          }),
        ],
      ),
      body: Obx(() {
        // Show loading state
        if (controller.isLoading.value && controller.cartItems.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Show login prompt if not authenticated
        if (!controller.isLoggedIn.value) {
          return _buildLoginPrompt(context);
        }

        // Show empty cart
        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart(context);
        }

        // Show cart with items
        return Column(
          children: [
            _buildSelectAllBar(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: controller.cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) => _buildCartItem(index),
              ),
            ),
            _buildCheckoutBar(),
          ],
        );
      }),
    );
  }

  /// LOGIN PROMPT
  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 90,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            'Please Login',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to view and manage your cart',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed('/login'),
            icon: const Icon(Icons.login),
            label: const Text('Go to Login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// EMPTY CART UI
  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 90,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to get started',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Continue Shopping'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// SELECT ALL BAR
  Widget _buildSelectAllBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Obx(() => Checkbox(
                value: controller.isAllSelected(),
                onChanged: (v) => controller.selectAllItems(v ?? false),
              )),
          const Text(
            "Select All",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Obx(() => Text(
                "Selected: ${controller.selectedItemsCount.value}",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              )),
        ],
      ),
    );
  }

  /// CART ITEM CARD
  Widget _buildCartItem(int index) {
    final item = controller.cartItems[index];

    return Obx(() => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.isSelected.value
                  ? AppColors.primary
                  : Colors.grey.shade300,
              width: item.isSelected.value ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Checkbox(
                    value: item.isSelected.value,
                    onChanged: (_) => controller.toggleItemSelection(item.id),
                  )),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppFontSize.bodyLarge,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (item.size != null && item.size!.isNotEmpty)
                      Text(
                        'Size: ${item.size}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    if (item.color != null && item.color!.isNotEmpty)
                      Text(
                        'Color: ${item.color}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      "\$${item.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildQuantityControl(item),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showRemoveDialog(item),
                child: const Icon(Icons.close, color: Colors.red, size: 22),
              )
            ],
          ),
        ));
  }

  /// QUANTITY COUNTER
  Widget _buildQuantityControl(dynamic item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => GestureDetector(
              onTap: controller.isLoading.value
                  ? null
                  : () => controller.decreaseQuantity(item.id),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.remove,
                  size: 18,
                  color: controller.isLoading.value ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),
          Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "${item.quantity.value}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
          Obx(
            () => GestureDetector(
              onTap: controller.isLoading.value
                  ? null
                  : () => controller.increaseQuantity(item.id),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.add,
                  size: 18,
                  color: controller.isLoading.value ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// CHECKOUT BAR
  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal:",
                style: TextStyle(
                  fontSize: AppFontSize.bodyLarge,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Obx(() => Text(
                    "\$${controller.getSelectedItemsTotal().toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shipping:",
                style: TextStyle(
                  fontSize: AppFontSize.bodyLarge,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Obx(() => Text(
                    "\$${controller.getShippingCost().toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tax:",
                style: TextStyle(
                  fontSize: AppFontSize.bodyLarge,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Obx(() => Text(
                    "\$${controller.getTax().toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:",
                style: TextStyle(
                  fontSize: AppFontSize.titleLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(() => Text(
                    "\$${controller.getGrandTotal().toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 14),
          Obx(() => ElevatedButton(
                onPressed: controller.selectedItemsCount.value > 0 &&
                        !controller.isLoading.value
                    ? () => _showCheckoutConfirmation()
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        "Checkout (${controller.selectedItemsCount.value})",
                        style: const TextStyle(fontSize: 16),
                      ),
              )),
        ],
      ),
    );
  }

  void _showRemoveDialog(dynamic item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Remove ${item.name} from cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.removeItem(item.id);
              Get.back();
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.clearCart();
              Get.back();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCheckoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Order'),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Items: ${controller.selectedItemsCount.value}'),
              const SizedBox(height: 8),
              Text(
                'Total: \$${controller.getGrandTotal().toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.placeOrder();
              Get.to(() => const OrderSummaryScreen());
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}