import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/modules/order_management.dart/manage_order_controller.dart';
import 'package:ecommerce_urban/modules/order_management.dart/order_detail_screen.dart';
import 'package:ecommerce_urban/modules/order_management.dart/order_management_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ManageOrdersScreen extends StatelessWidget {
  ManageOrdersScreen({super.key});

  final ManageOrdersController controller = Get.find<ManageOrdersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Manage Orders'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
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
      // color: Colors.white,
      child: TextField(
        onChanged: controller.searchOrders,
        decoration: InputDecoration(
          hintText: 'Search by order number or customer name...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          // fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildStatusChips() {
    return Container(
      height: 60,
      // color: Colors.white,
      child: Obx(() => ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              _buildStatusChip('All', null),
              ...OrderStatus.values.map((status) => _buildStatusChip(
                    _getStatusLabel(status),
                    status,
                  )),
            ],
          )),
    );
  }

  Widget _buildStatusChip(String label, OrderStatus? status) {
    final isSelected = controller.selectedStatus.value == status;
    final count = status == null
        ? controller.orders.length
        : controller.getOrderCountByStatus(status);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 4),
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
                  color: isSelected
                      ? Get.theme.colorScheme.primary
                      : Colors.black87,
                ),
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          controller.filterByStatus(selected ? status : null);
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Get.theme.colorScheme.primary.withOpacity(0.2),
        checkmarkColor: Get.theme.colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected ? Get.theme.colorScheme.primary : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return Obx(() {
      if (controller.isLoading.value) {
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
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
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
            'Try adjusting your filters',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () => Get.to(() => OrderDetailsScreen(order: order)),
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
                          order.customerName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(order.status),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMM dd, yyyy • hh:mm a')
                        .format(order.orderDate),
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.shopping_bag, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const Spacer(),
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
              if (order.status != OrderStatus.delivered &&
                  order.status != OrderStatus.cancelled) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showStatusUpdateDialog(order),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Update Status'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    final config = _getStatusConfig(status);
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
    Get.bottomSheet(
      enableDrag: true,
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
              'Filter Orders',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightTextPrimary),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip('All', null),
                ...OrderStatus.values.map((status) =>
                    _buildFilterChip(_getStatusLabel(status), status)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, OrderStatus? status) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == status;
      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Get.theme.colorScheme.primary.withOpacity(0.9),
        onSelected: (selected) {
          controller.filterByStatus(selected ? status : null);
        },
      );
    });
  }

  void _showStatusUpdateDialog(OrderModel order) {
    Get.dialog(
      AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: OrderStatus.values
              .where((s) => s != OrderStatus.cancelled)
              .map((status) => ListTile(
                    leading: Icon(_getStatusConfig(status)['icon']),
                    title: Text(_getStatusLabel(status)),
                    trailing: order.status == status
                        ? const Icon(
                            Icons.check,
                          )
                        : null,
                    onTap: () {
                      Get.back();
                      controller.updateOrderStatus(order.id, status);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Map<String, dynamic> _getStatusConfig(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return {
          'label': 'Pending',
          'color': Colors.orange,
          'icon': Icons.hourglass_empty,
        };
      case OrderStatus.confirmed:
        return {
          'label': 'Confirmed',
          'color': Colors.blue,
          'icon': Icons.check_circle_outline,
        };
      case OrderStatus.processing:
        return {
          'label': 'Processing',
          'color': Colors.purple,
          'icon': Icons.sync,
        };
      case OrderStatus.shipped:
        return {
          'label': 'Shipped',
          'color': Colors.teal,
          'icon': Icons.local_shipping,
        };
      case OrderStatus.delivered:
        return {
          'label': 'Delivered',
          'color': Colors.green,
          'icon': Icons.check_circle,
        };
      case OrderStatus.cancelled:
        return {
          'label': 'Cancelled',
          'color': Colors.red,
          'icon': Icons.cancel,
        };
    }
  }
}
