import 'package:ecommerce_urban/modules/order_history/order_history_controller.dart';
import 'package:ecommerce_urban/modules/order_history/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OrderHistoryView extends GetView<OrderHistoryController> {
  const OrderHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Order History',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A1A)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF6C63FF),
                  ),
                );
              }

              final orders = controller.filteredOrders;

              if (orders.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(orders[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Obx(() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip('All', 'all'),
            const SizedBox(width: 8),
            _buildChip('Delivered', 'delivered'),
            const SizedBox(width: 8),
            _buildChip('Processing', 'processing'),
            const SizedBox(width: 8),
            _buildChip('Cancelled', 'cancelled'),
          ],
        ),
      )),
    );
  }

  Widget _buildChip(String label, String value) {
    final isSelected = controller.selectedFilter.value == value;
    return GestureDetector(
      onTap: () => controller.setFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF666666),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    Color statusColor;
    IconData statusIcon;

    switch (order.status) {
      case 'delivered':
        statusColor = const Color(0xFF4CAF50);
        statusIcon = Icons.check_circle;
        break;
      case 'processing':
        statusColor = const Color(0xFFFF9800);
        statusIcon = Icons.access_time;
        break;
      case 'cancelled':
        statusColor = const Color(0xFFF44336);
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = const Color(0xFF9E9E9E);
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF5F5F5),
                    image: DecorationImage(
                      image: NetworkImage(order.productImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order.id,
                            style: const TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  statusIcon,
                                  size: 12,
                                  color: statusColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  order.statusText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        order.productName,
                        style: const TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Qty: ${order.quantity}',
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${order.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFF6C63FF),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            order.formattedDate,
                            style: const TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFF0F0F0), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => controller.trackOrder(order),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Track Order',
                      style: TextStyle(
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: const Color(0xFFF0F0F0),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => controller.reorderProduct(order),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Reorder',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No orders found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your order history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }
}