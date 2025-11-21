import 'package:ecommerce_urban/modules/cart/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../order/order_summary_screen.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart(context);
        }

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

  /// EMPTY CART UI
  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 90, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text('Your cart is empty',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Add items to get started',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  /// SELECT ALL BAR
  Widget _buildSelectAllBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F7),
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: Row(
        children: [
          Obx(() => Checkbox(
                value: controller.isAllSelected(),
                onChanged: (v) => controller.selectAllItems(v ?? false),
              )),
          const Text(
            "Select All",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Obx(() => Text(
                "Selected: ${controller.selectedItemsCount.value}",
                style: const TextStyle(color: Colors.grey),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.isSelected.value
                  ? Colors.blueAccent
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
                    onChanged: (_) =>
                        controller.toggleItemSelection(item.id),
                  )),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
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
                onTap: () => controller.removeItem(item.id),
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
          GestureDetector(
            onTap: () => controller.decreaseQuantity(item.id),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.remove, size: 18),
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

  /// CHECKOUT BAR
  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Obx(() => Text(
                    "\$${controller.getSelectedItemsTotal().toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 14),
          Obx(() => ElevatedButton(
                onPressed: controller.selectedItemsCount.value > 0
                    ? () => Get.to(() => const OrderSummaryScreen())
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "Checkout (${controller.selectedItemsCount.value})",
                  style: const TextStyle(fontSize: 16),
                ),
              )),
        ],
      ),
    );
  }
}
