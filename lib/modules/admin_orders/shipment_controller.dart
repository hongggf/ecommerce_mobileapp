import 'package:ecommerce_urban/modules/admin_orders/admin_orders_controller.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/shipmment_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/service/shipment_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShipmentController extends GetxController {
  final int orderId;
  final ShipmentService _shipmentService = ShipmentService();

  final RxList<ShipmentModel> shipments = <ShipmentModel>[].obs;
  final RxBool isLoading = false.obs;

  ShipmentController(this.orderId);

  @override
  void onInit() {
    super.onInit();
    loadShipments();
  }

  Future<void> loadShipments() async {
    try {
      isLoading.value = true;
      final fetchedShipments = await _shipmentService.getOrderShipments(orderId);
      shipments.assignAll(fetchedShipments);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load shipments: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      print('Error loading shipments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showCreateShipmentDialog() {
    final trackingController = TextEditingController();
    final carrierController = TextEditingController(text: 'DHL');
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: const Text('Create Shipment'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: trackingController,
                  decoration: const InputDecoration(
                    labelText: 'Tracking Number *',
                    prefixIcon: Icon(Icons.confirmation_number),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tracking number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: carrierController,
                  decoration: const InputDecoration(
                    labelText: 'Carrier *',
                    prefixIcon: Icon(Icons.local_shipping),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Carrier is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Future.delayed(const Duration(milliseconds: 300), () {
                trackingController.dispose();
                carrierController.dispose();
              });
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final request = CreateShipmentRequest(
                  orderId: orderId,
                  trackingNumber: trackingController.text,
                  carrier: carrierController.text,
                  status: 'packed',
                );

                Get.back();
                Future.delayed(const Duration(milliseconds: 300), () {
                  trackingController.dispose();
                  carrierController.dispose();
                });

                createShipment(request);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void showEditShipmentDialog(ShipmentModel shipment) {
    final trackingController =
        TextEditingController(text: shipment.trackingNumber);
    final carrierController =
        TextEditingController(text: shipment.carrier);
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Shipment'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: trackingController,
                  decoration: const InputDecoration(
                    labelText: 'Tracking Number *',
                    prefixIcon: Icon(Icons.confirmation_number),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tracking number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: carrierController,
                  decoration: const InputDecoration(
                    labelText: 'Carrier *',
                    prefixIcon: Icon(Icons.local_shipping),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Carrier is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Future.delayed(const Duration(milliseconds: 300), () {
                trackingController.dispose();
                carrierController.dispose();
              });
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final request = UpdateShipmentRequest(
                  trackingNumber: trackingController.text,
                  carrier: carrierController.text,
                );

                Get.back();
                Future.delayed(const Duration(milliseconds: 300), () {
                  trackingController.dispose();
                  carrierController.dispose();
                });

                updateShipment(shipment.id!, request);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void showMarkShippedDialog(ShipmentModel shipment) {
    Get.dialog(
      AlertDialog(
        title: const Text('Mark as Shipped'),
        content: const Text('Are you sure you want to mark this shipment as shipped?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final request = MarkShippedRequest(
                trackingNumber: shipment.trackingNumber,
                carrier: shipment.carrier,
              );

              Get.back();
              markAsShipped(shipment.id!, request);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Confirm'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void showMarkDeliveredDialog(ShipmentModel shipment) {
    Get.dialog(
      AlertDialog(
        title: const Text('Mark as Delivered'),
        content: const Text('Are you sure you want to mark this shipment as delivered?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final request = MarkShippedRequest(
                trackingNumber: shipment.trackingNumber,
                carrier: shipment.carrier,
              );

              Get.back();
              markAsDelivered(shipment.id!, request);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirm'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> createShipment(CreateShipmentRequest request) async {
    try {
      isLoading.value = true;
      final shipment = await _shipmentService.createShipment(request);

      if (shipment != null) {
        shipments.insert(0, shipment);
        Get.snackbar(
          'Success',
          'Shipment created successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to create shipment',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create shipment: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      print('Error creating shipment: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateShipment(int shipmentId, UpdateShipmentRequest request) async {
    try {
      isLoading.value = true;
      final success = await _shipmentService.updateShipment(shipmentId, request);

      if (success) {
        await loadShipments();
        Get.snackbar(
          'Success',
          'Shipment updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update shipment',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update shipment: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      print('Error updating shipment: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsShipped(int shipmentId, MarkShippedRequest request) async {
    try {
      isLoading.value = true;
      final success = await _shipmentService.markAsShipped(shipmentId, request);

      if (success) {
        await loadShipments();
        _updateOrderStatus('shipped');

        Get.snackbar(
          'Success',
          'Marked as shipped',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to mark as shipped',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark as shipped: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      print('Error marking as shipped: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsDelivered(int shipmentId, MarkShippedRequest request) async {
    try {
      isLoading.value = true;
      final success = await _shipmentService.markAsDelivered(shipmentId, request);

      if (success) {
        await loadShipments();
        _updateOrderStatus('delivered');

        Get.snackbar(
          'Success',
          'Marked as delivered',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to mark as delivered',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark as delivered: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      print('Error marking as delivered: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateOrderStatus(String newStatus) {
    try {
      final orderController = Get.find<AdminOrdersController>();
      orderController.updateOrderStatusFromDetail(orderId, newStatus);
    } catch (e) {
      print('Warning: AdminOrdersController not found - skipping order status update');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}