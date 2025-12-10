// lib/modules/order/order_summary_screen.dart
import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/app/constants/app_fontsizes.dart';
import 'package:ecommerce_urban/modules/cart/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderSummaryScreen extends GetView<CartController> {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Order Items'),
              const SizedBox(height: 12),
              _buildOrderItems(context),
              const SizedBox(height: 24),
              _buildSectionTitle('Shipping Address'),
              const SizedBox(height: 12),
              _buildAddressCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('Order Summary'),
              const SizedBox(height: 12),
              _buildPricingBreakdown(context),
              const SizedBox(height: 24),
              _buildPaymentMethodCard(),
              const SizedBox(height: 24),
              _buildOrderButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // SECTION TITLE
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ORDER ITEM LIST
  Widget _buildOrderItems(BuildContext context) {
    return Obx(
      () {
        final selectedItems = controller.cartItems
            .where((item) => item.isSelected.value)
            .toList();

        if (selectedItems.isEmpty) {
          return Center(
            child: Text(
              'No items in order',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: selectedItems.length,
            separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
            itemBuilder: (context, index) {
              final item = selectedItems[index];
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Obx(() => Text(
                          'Qty: ${item.quantity.value}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        )),
                      ],
                    ),
                  ),
                  Obx(() => Text(
                    '\$${(item.price * item.quantity.value).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.blueAccent,
                    ),
                  )),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // ADDRESS CARD
  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Delivery Address',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '123 Main Street, Apartment 4B\nNew York, NY 10001\nUSA',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Get.snackbar('Address', 'Change address feature coming soon');
            },
            child: Text(
              'Change Address',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PRICING BREAKDOWN
  Widget _buildPricingBreakdown(BuildContext context) {
    return Obx(
      () {
        final subtotal = controller.getSelectedItemsTotal();
        final shipping = controller.getShippingCost();
        final tax = controller.getTax();
        final total = controller.getGrandTotal();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              _buildPricingRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 12),
              _buildPricingRow(
                'Shipping',
                shipping == 0 ? 'FREE' : '\$${shipping.toStringAsFixed(2)}',
                color: shipping == 0 ? Colors.green : Colors.grey.shade700,
              ),
              const SizedBox(height: 12),
              _buildPricingRow('Tax (10%)', '\$${tax.toStringAsFixed(2)}'),
              Divider(
                color: Colors.grey.shade300,
                height: 20,
              ),
              _buildPricingRow(
                'Total',
                '\$${total.toStringAsFixed(2)}',
                isTotal: true,
              ),
            ],
          ),
        );
      },
    );
  }

  // PRICING ROW
  Widget _buildPricingRow(String label, String value,
      {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            fontSize: isTotal ? 15 : 13,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            fontSize: isTotal ? 18 : 13,
            color: isTotal ? AppColors.primary : color,
          ),
        ),
      ],
    );
  }

  // PAYMENT METHOD CARD
  Widget _buildPaymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.credit_card, color: Colors.grey.shade700),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visa Card',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '**** **** **** 4242',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Get.snackbar('Payment', 'Change payment method coming soon');
            },
            child: Text(
              'Change Payment Method',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ORDER BUTTONS
  Widget _buildOrderButton(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                      _showOrderConfirmationDialog(context);
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Get.back();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Back to Cart'),
          ),
        ),
      ],
    );
  }

  // ORDER CONFIRMATION DIALOG
  void _showOrderConfirmationDialog(BuildContext context) {
    controller.placeOrder();
    Future.delayed(const Duration(seconds: 1), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Order Confirmed!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green.shade700,
                  size: 60,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your order has been placed successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Order ID: #ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                Get.back(); // Close OrderSummaryScreen
                Get.back(); // Go back from Cart
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      );
    });
  }
}