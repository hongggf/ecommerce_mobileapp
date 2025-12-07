import 'package:ecommerce_urban/modules/admin_orders/admin_create_order_screen.dart';
import 'package:ecommerce_urban/modules/admin_orders/admin_order_detail_screen.dart';
import 'package:ecommerce_urban/modules/admin_orders/admin_orders_controller.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class AdminOrderListScreen extends StatelessWidget {
  AdminOrderListScreen({super.key});

  // Get the controller instance
  final controller = Get.find<AdminOrdersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Management'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => CreateOrderScreen()),
        icon: const Icon(Icons.add),
        label: const Text('New Order'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatusChips(),
          Expanded(child: _buildOrdersList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: controller.searchOrders,
        decoration: InputDecoration(
          hintText: 'Search by order number or customer...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildStatusChips() {
    final statuses = ['all', 'pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'];
    
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          return _buildStatusChip(_getStatusLabel(status), status);
        },
      ),
    );
  }

  Widget _buildStatusChip(String label, String status) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == status;
      final count = status == 'all'
          ? controller.orders.length
          : controller.getOrderCountByStatus(status);

      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blue[700] : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            controller.filterByStatus(selected ? status : 'all');
          },
          backgroundColor: Colors.grey[200],
          selectedColor: Colors.blue[100],
          checkmarkColor: Colors.blue[700],
          labelStyle: TextStyle(
            color: isSelected ? Colors.blue[700] : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    });
  }

  Widget _buildOrdersList() {
    return Obx(() {
      if (controller.isLoading.value && controller.orders.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredOrders.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: controller.loadOrders,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.filteredOrders.length,
          itemBuilder: (context, index) {
            final order = controller.filteredOrders[index];
            return _buildOrderCard(order);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or create a new order',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final statusConfig = _getStatusConfig(order.status);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () async {
          // Navigate and refresh on return
          await Get.to(() => OrderDetailScreen(orderId: order.id!));
          // Refresh the list when coming back
          controller.loadOrders();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.shippingAddressSnapshot.recipientName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(order.status, statusConfig),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMM dd, yyyy • hh:mm a').format(order.createdAt),
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${order.shippingAddressSnapshot.city}, ${order.shippingAddressSnapshot.countryCode}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '\$${order.grandTotalDouble.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              if (order.status != 'delivered' && order.status != 'cancelled') ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showStatusUpdateDialog(order),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Update Status'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _confirmDeleteOrder(order),
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.red[200]!),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Map<String, dynamic> config) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: config['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config['color'].withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config['icon'], size: 14, color: config['color']),
          const SizedBox(width: 4),
          Text(
            config['label'],
            style: TextStyle(
              color: config['color'],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final statuses = ['all', 'pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'];
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: statuses.map((status) {
                return Obx(() {
                  final isSelected = controller.selectedStatus.value == status;
                  return ChoiceChip(
                    label: Text(_getStatusLabel(status)),
                    selected: isSelected,
                    selectedColor: Colors.blue[100],
                    onSelected: (selected) {
                      controller.filterByStatus(selected ? status : 'all');
                    },
                  );
                });
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Apply Filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(OrderModel order) {
    final statuses = ['pending', 'confirmed', 'processing', 'shipped', 'delivered'];
    
    Get.dialog(
      AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            final config = _getStatusConfig(status);
            return ListTile(
              leading: Icon(config['icon'], color: config['color']),
              title: Text(config['label']),
              trailing: order.status == status
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                Get.back();
                controller.updateOrderStatus(order.id!, status);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _confirmDeleteOrder(OrderModel order) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Order'),
        content: Text('Are you sure you want to delete order ${order.orderNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteOrder(order.id!);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    return status[0].toUpperCase() + status.substring(1);
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