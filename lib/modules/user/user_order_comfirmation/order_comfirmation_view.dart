// lib/modules/user/user_checkout/views/order_confirmation_view.dart
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';

import 'package:ecommerce_urban/modules/user/user_checkout/user_checkout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderConfirmationView extends GetView<UserCheckoutController> {
  const OrderConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.currentOrder.value == null) {
          return Center(
            child: Text('No order found'),
          );
        }

        final order = controller.currentOrder.value!;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.paddingSM),
            child: Column(
              children: [
                _buildSuccessHeader(),
                SizedBox(height: AppSpacing.paddingL),
                _buildOrderInfo(order),
                SizedBox(height: AppSpacing.paddingL),
                _buildOrderItems(context),
                SizedBox(height: AppSpacing.paddingL),
                _buildOrderTotal(order),
                SizedBox(height: AppSpacing.paddingXL),
                _buildButtons(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green[50],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, color: Colors.green, size: 50),
        ),
        const SizedBox(height: 16),
        const Text(
          'Order Confirmed!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildOrderInfo(dynamic order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order ID', style: TextStyle(fontSize: 12)),
                  Text(
                    '#${order.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      controller.getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: controller.getStatusColor(order.status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: 'Items'),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.orderItems.isEmpty) {
            return const Center(child: Text('No items'));
          }

          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: controller.orderItems.length,
              separatorBuilder: (_, __) => Divider(color: Colors.grey[200]),
              itemBuilder: (context, index) {
                final item = controller.orderItems[index];
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName ?? 'Product',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Qty: ${item.quantity}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${item.subtotal?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildOrderTotal(dynamic order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildTotalRow(
              'Subtotal', '\$${order.subtotal?.toStringAsFixed(2) ?? '0.00'}'),
          const SizedBox(height: 12),
          _buildTotalRow(
            'Shipping',
            order.shippingFee == 0
                ? 'FREE'
                : '\$${order.shippingFee?.toStringAsFixed(2) ?? '0.00'}',
            color: order.shippingFee == 0 ? Colors.green : null,
          ),
          const SizedBox(height: 12),
          Divider(height: 16),
          _buildTotalRow(
              'Total', '\$${order.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value,
      {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isTotal ? 16 : 13,
            color: isTotal ? Colors.blue : color,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              controller.clearOrder();
              Get.offAllNamed('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Back to Home',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
