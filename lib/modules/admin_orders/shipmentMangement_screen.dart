import 'package:ecommerce_urban/modules/admin_orders/model/shipmment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'shipment_controller.dart';

class ShipmentManagementScreen extends StatelessWidget {
  final int orderId;
  final String orderNumber;

  ShipmentManagementScreen({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ShipmentController(orderId),
      tag: 'shipment_$orderId',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Shipments - $orderNumber'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadShipments,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.showCreateShipmentDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Create Shipment'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.shipments.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.shipments.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.loadShipments,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.shipments.length,
            itemBuilder: (context, index) {
              final shipment = controller.shipments[index];
              return _buildShipmentCard(shipment, controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping_outlined,
              size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No shipments yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a shipment to start tracking',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentCard(ShipmentModel shipment, ShipmentController controller) {
    final statusConfig = _getShipmentStatusConfig(shipment.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                        shipment.trackingNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.local_shipping,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            shipment.carrier,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusConfig['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: statusConfig['color'].withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusConfig['icon'],
                          size: 14, color: statusConfig['color']),
                      const SizedBox(width: 4),
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
            const Divider(height: 24),
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Created: ${DateFormat('MMM dd, yyyy').format(shipment.createdAt)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            if (shipment.shippedAt != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.send, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Shipped: ${DateFormat('MMM dd, yyyy').format(shipment.shippedAt!)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ],
            if (shipment.deliveredAt != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.check_circle,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Delivered: ${DateFormat('MMM dd, yyyy').format(shipment.deliveredAt!)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ],
            if (shipment.status != 'delivered') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (shipment.status == 'packed') ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            controller.showMarkShippedDialog(shipment),
                        icon: const Icon(Icons.local_shipping, size: 18),
                        label: const Text('Mark as Shipped'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ] else if (shipment.status == 'shipped') ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            controller.showMarkDeliveredDialog(shipment),
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text('Mark as Delivered'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () =>
                        controller.showEditShipmentDialog(shipment),
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.blue[200]!),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getShipmentStatusConfig(String status) {
    switch (status) {
      case 'packed':
        return {
          'label': 'Packed',
          'color': Colors.orange,
          'icon': Icons.inventory_2
        };
      case 'shipped':
        return {
          'label': 'Shipped',
          'color': Colors.blue,
          'icon': Icons.local_shipping
        };
      case 'delivered':
        return {
          'label': 'Delivered',
          'color': Colors.green,
          'icon': Icons.check_circle
        };
      default:
        return {
          'label': 'Unknown',
          'color': Colors.grey,
          'icon': Icons.help_outline
        };
    }
  }
}