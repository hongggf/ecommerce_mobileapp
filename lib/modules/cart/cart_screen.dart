// lib/modules/cart/views/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/modules/cart/cart_controller.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Obx(() {
            if (controller.cartItems.isEmpty) return const SizedBox();
            return IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showClearDialog(context),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.cartItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.isLoggedIn.value) {
          return _buildLoginPrompt(context);
        }

        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart(context);
        }

        return Column(
          children: [
            _buildSelectAllBar(context),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: controller.cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) => _buildCartItem(context, index),
              ),
            ),
            _buildCheckoutBar(context),
          ],
        );
      }),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text('Please Login', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Sign in to view your cart', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed('/login'),
            icon: const Icon(Icons.login),
            label: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text('Your cart is empty', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Add items to get started', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAllBar(BuildContext context) {
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
          const Text('Select All', style: TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Obx(() => Text(
            'Selected: ${controller.selectedItemsCount.value}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          )),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, int index) {
    final item = controller.cartItems[index];

    return Obx(() => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isSelected.value ? AppColors.primary : Colors.grey.shade300,
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
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                if (item.size != null)
                  Text('Size: ${item.size}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                if (item.color != null)
                  Text('Color: ${item.color}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 6),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                const SizedBox(height: 10),
                _buildQuantityControl(item),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => controller.removeItem(item.id),
            child: const Icon(Icons.close, color: Colors.red, size: 22),
          )
        ],
      ),
    ));
  }

  Widget _buildQuantityControl(CartItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => controller.decreaseQuantity(item.id),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.remove, size: 18),
            ),
          ),
          Obx(() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('${item.quantity.value}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          )),
          GestureDetector(
            onTap: () => controller.increaseQuantity(item.id),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.add, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context) {
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
              const Text('Subtotal:', style: TextStyle(fontWeight: FontWeight.w500)),
              Obx(() => Text(
                '\$${controller.getSelectedItemsTotal().toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shipping:', style: TextStyle(fontWeight: FontWeight.w500)),
              Obx(() => Text(
                '\$${controller.getShippingCost().toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tax:', style: TextStyle(fontWeight: FontWeight.w500)),
              Obx(() => Text(
                '\$${controller.getTax().toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Obx(() => Text(
                '\$${controller.getGrandTotal().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, color: AppColors.primary, fontWeight: FontWeight.bold),
              )),
            ],
          ),
          const SizedBox(height: 14),
          Obx(() => ElevatedButton(
            onPressed: controller.selectedItemsCount.value > 0 && !controller.isLoading.value
                ? () => _showCheckoutDialog(context)
                : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                )
                : Text('Checkout (${controller.selectedItemsCount.value})'),
          )),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from cart?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
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

  void _showCheckoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Order'),
        content: Obx(() => Column(
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
        )),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.placeOrder();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}