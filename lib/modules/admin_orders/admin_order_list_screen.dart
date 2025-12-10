
import 'package:ecommerce_urban/modules/admin_orders/admin_create_order_screen.dart';
import 'package:ecommerce_urban/modules/admin_orders/admin_orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminOrderListScreen extends StatelessWidget {
  AdminOrderListScreen({super.key});

  final controller = Get.put(AdminOrdersController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Orders Management',
          style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context, theme, isDark),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() =>CreateOrderScreen()),
        icon: Icon(Icons.add),
        label: Text('New Order'),
        elevation: 4,
      ),
      body: Column(
        children: [
          _buildSearchBar(theme, isDark),
          _buildStatusChips(theme, isDark),
          Expanded(child: _buildOrdersList(theme, isDark)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        onChanged: controller.searchOrders,
        decoration: InputDecoration(
          hintText: 'Search by order number or customer...',
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildStatusChips(ThemeData theme, bool isDark) {
    final statuses = ['all', 'pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'];
    
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          return _buildStatusChip(_getStatusLabel(status), status, theme, isDark);
        },
      ),
    );
  }

  Widget _buildStatusChip(String label, String status, ThemeData theme, bool isDark) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == status;
      final count = status == 'all'
          ? controller.orders.length
          : controller.getOrderCountByStatus(status);

      return Padding(
        padding: EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              SizedBox(width: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : (isDark ? Colors.grey[700] : Colors.grey[300]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? theme.primaryColor : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            controller.filterByStatus(selected ? status : 'all');
          },
          backgroundColor: isDark ? Colors.grey[850] : Colors.grey[200],
          selectedColor: theme.primaryColor.withOpacity(0.15),
          checkmarkColor: theme.primaryColor,
          labelStyle: TextStyle(
            color: isSelected ? theme.primaryColor : (isDark ? Colors.white : Colors.black87),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    });
  }

  Widget _buildOrdersList(ThemeData theme, bool isDark) {
    return Obx(() {
      if (controller.isLoading.value && controller.orders.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.filteredOrders.isEmpty) {
        return _buildEmptyState(theme);
      }

      return RefreshIndicator(
        onRefresh: controller.loadOrders,
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.filteredOrders.length,
          itemBuilder: (context, index) {
            final order = controller.filteredOrders[index];
            return _buildOrderCard(order, theme, isDark);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No orders found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters or create a new order',
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, ThemeData theme, bool isDark) {
    final statusConfig = _getStatusConfig(order.status);
    
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: isDark ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () async {
          // Navigate to detail screen
          Get.snackbar('Info', 'Order detail screen would open here');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusConfig['color'].withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusConfig['color'].withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusConfig['icon'],
                          size: 14,
                          color: statusConfig['color']),
                        SizedBox(width: 4),
                        Text(
                          statusConfig['label'],
                          style: TextStyle(
                            color: statusConfig['color'],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    DateFormat('MMM dd, yyyy • hh:mm a').format(order.createdAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on,
                    size: 16,
                    color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${order.shippingAddressSnapshot.city}, ${order.shippingAddressSnapshot.countryCode}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '\$${order.grandTotalDouble.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              if (order.status != 'delivered' && order.status != 'cancelled') ...[
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showStatusUpdateDialog(order, theme),
                        icon: Icon(Icons.edit, size: 18),
                        label: Text('Update Status'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _confirmDeleteOrder(order, theme),
                      icon: Icon(Icons.delete_outline, color: Colors.red),
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

  void _showFilterBottomSheet(BuildContext context, ThemeData theme, bool isDark) {
    final statuses = ['all', 'pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'];
    
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: statuses.map((status) {
                return Obx(() {
                  final isSelected = controller.selectedStatus.value == status;
                  return ChoiceChip(
                    label: Text(_getStatusLabel(status)),
                    selected: isSelected,
                    selectedColor: theme.primaryColor.withOpacity(0.15),
                    onSelected: (selected) {
                      controller.filterByStatus(selected ? status : 'all');
                    },
                  );
                });
              }).toList(),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Apply Filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(OrderModel order, ThemeData theme) {
    final statuses = ['pending', 'confirmed', 'processing', 'shipped', 'delivered'];
    
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            final config = _getStatusConfig(status);
            return ListTile(
              leading: Icon(config['icon'], color: config['color']),
              title: Text(config['label']),
              trailing: order.status == status
                  ? Icon(Icons.check, color: Colors.green)
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

  void _confirmDeleteOrder(OrderModel order, ThemeData theme) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Delete Order'),
        content: Text('Are you sure you want to delete order ${order.orderNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteOrder(order.id!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete'),
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
