
import 'package:ecommerce_urban/modules/admin_orders/admin_edit_order_screen.dart';
import 'package:ecommerce_urban/modules/admin_orders/admin_order_detail_controller.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_items_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/shipmentMangement_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class OrderDetailScreen extends StatelessWidget {
  final int orderId;

  OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    // Create a unique controller for this order
    final controller = Get.put(
      OrderDetailController(orderId),
      tag: 'order_$orderId',
    );

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.order.value?.orderNumber ?? 'Order Details')),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadOrderDetails,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.order.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.order.value == null) {
          return const Center(child: Text('Order not found'));
        }

        return RefreshIndicator(
          onRefresh: controller.loadOrderDetails,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(controller),
                const SizedBox(height: 16),
                _buildShipmentQuickAccessCard(controller),
                const SizedBox(height: 16),
                _buildCustomerCard(controller),
                const SizedBox(height: 16),
                _buildItemsCard(controller),
                const SizedBox(height: 16),
                _buildPaymentCard(controller),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(OrderDetailController controller) {
    return Obx(() {
      final order = controller.order.value!;
      final config = _getStatusConfig(order.status);
      
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(config['icon'], size: 60, color: config['color']),
              const SizedBox(height: 12),
              Text(
                config['label'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: config['color'],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMM dd, yyyy • hh:mm a').format(order.createdAt),
                style: TextStyle(color: Colors.grey[600]),
              ),
              if (order.status != 'delivered' && order.status != 'cancelled') ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showStatusUpdateDialog(controller),
                  icon: const Icon(Icons.edit),
                  label: const Text('Update Status'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildShipmentQuickAccessCard(OrderDetailController controller) {
    return Obx(() {
      final order = controller.order.value!;
      
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () async {
            await Get.to(() => ShipmentManagementScreen(
                  orderId: order.id!,
                  orderNumber: order.orderNumber,
                ));
            // Refresh order details when coming back
            controller.loadOrderDetails();
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_shipping,
                    color: Colors.blue[700],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Manage Shipments',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Track and update delivery status',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCustomerCard(OrderDetailController controller) {
    return Obx(() {
      final order = controller.order.value!;
      
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shipping Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24),
              _buildInfoRow(
                Icons.person,
                'Recipient',
                order.shippingAddressSnapshot.recipientName,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.location_on,
                'Address',
                order.shippingAddressSnapshot.fullAddress,
              ),
              if (order.notes != null && order.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildInfoRow(Icons.note, 'Notes', order.notes!),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildItemsCard(OrderDetailController controller) {
    return Obx(() {
      final order = controller.order.value!;
      
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order Items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddItemDialog(controller),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
              const Divider(height: 24),
              if (order.items == null || order.items!.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No items in this order',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              else
                ...order.items!.map((item) => _buildItemRow(item, controller)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildItemRow(OrderItem item, OrderDetailController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: item.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                    ),
                  )
                : const Icon(Icons.image),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? 'Product #${item.productId}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Qty: ${item.quantity} × \$${item.unitPriceDouble.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${item.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => _editOrderItem(item, controller),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () => _confirmDeleteItem(item, controller),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(OrderDetailController controller) {
    return Obx(() {
      final order = controller.order.value!;
      
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24),
              _buildPaymentRow('Subtotal', order.subtotalDouble),
              const SizedBox(height: 8),
              _buildPaymentRow('Discount', -order.discountDouble),
              const SizedBox(height: 8),
              _buildPaymentRow('Tax', order.taxDouble),
              const SizedBox(height: 8),
              _buildPaymentRow('Shipping', order.shippingDouble),
              const Divider(height: 24),
              _buildPaymentRow('Total', order.grandTotalDouble, isBold: true),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getFinancialStatusColor(order.financialStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getFinancialStatusColor(order.financialStatus).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.payment, color: _getFinancialStatusColor(order.financialStatus)),
                    const SizedBox(width: 8),
                    Text(
                      'Payment: ${order.financialStatus.toUpperCase()}',
                      style: TextStyle(
                        color: _getFinancialStatusColor(order.financialStatus),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          '\$${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isBold ? 20 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold
                ? Colors.green
                : amount < 0
                    ? Colors.red
                    : Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showStatusUpdateDialog(OrderDetailController controller) {
    final statuses = ['pending', 'confirmed', 'processing', 'shipped', 'delivered'];
    
    Get.dialog(
      AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            final config = _getStatusConfig(status);
            return Obx(() {
              final currentStatus = controller.order.value!.status;
              return ListTile(
                leading: Icon(config['icon'], color: config['color']),
                title: Text(config['label']),
                trailing: currentStatus == status
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  Get.back();
                  controller.updateOrderStatus(status);
                },
              );
            });
          }).toList(),
        ),
      ),
    );
  }

  void _showAddItemDialog(OrderDetailController controller) {
    Get.to(() => EditOrderItemScreen(orderId: controller.orderId))?.then((_) {
      controller.loadOrderDetails();
    });
  }

  void _editOrderItem(OrderItem item, OrderDetailController controller) {
    Get.to(() => EditOrderItemScreen(orderId: controller.orderId, item: item))
        ?.then((_) {
      controller.loadOrderDetails();
    });
  }

  void _confirmDeleteItem(OrderItem item, OrderDetailController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove Item'),
        content: Text(
            'Are you sure you want to remove "${item.productName ?? 'this item'}" from the order?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteOrderItem(item.id!);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Color _getFinancialStatusColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'pending':
        return {'label': 'Pending', 'color': Colors.orange, 'icon': Icons.hourglass_empty};
      case 'confirmed':
        return {'label': 'Confirmed', 'color': Colors.blue, 'icon': Icons.check_circle_outline};
      case 'processing':
        return {'label': 'Processing', 'color': Colors.purple, 'icon': Icons.sync};
      case 'shipped':
        return {'label': 'Shipped', 'color': Colors.teal, 'icon': Icons.local_shipping};
      case 'delivered':
        return {'label': 'Delivered', 'color': Colors.green, 'icon': Icons.check_circle};
      case 'cancelled':
        return {'label': 'Cancelled', 'color': Colors.red, 'icon': Icons.cancel};
      default:
        return {'label': 'Unknown', 'color': Colors.grey, 'icon': Icons.help_outline};
    }
  }
}