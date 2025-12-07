// lib/modules/admin_orders/admin_edit_order_screen.dart
import 'package:ecommerce_urban/modules/admin_orders/admin_edit_order_controller.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_items_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EditOrderItemScreen extends StatelessWidget {
  final int orderId;
  final OrderItem? item;

  EditOrderItemScreen({
    super.key,
    required this.orderId,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    final tag = 'edit_item_${item?.id ?? 'new'}';

    final controller = Get.isRegistered<EditOrderItemController>(tag: tag)
        ? Get.find<EditOrderItemController>(tag: tag)
        : Get.put(EditOrderItemController(orderId: orderId, item: item),
            tag: tag);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(controller.isEditMode ? 'Edit Order Item' : 'Add Order Item'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildProductSection(controller),
            const SizedBox(height: 20),
            _buildPricingSection(controller),
            const SizedBox(height: 20),
            _buildTaxesAndDiscountsSection(controller),
            const SizedBox(height: 30),
            _buildSubmitButton(controller),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSection(EditOrderItemController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.productIdController,
              decoration: const InputDecoration(
                labelText: 'Product ID *',
                hintText: 'Enter product ID',
                prefixIcon: Icon(Icons.inventory_2),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Product ID is required';
                }
                return null;
              },
              enabled: !controller.isEditMode,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.variantIdController,
              decoration: const InputDecoration(
                labelText: 'Variant ID (Optional)',
                hintText: 'Enter variant ID',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection(EditOrderItemController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quantity & Price',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity *',
                      prefixIcon: Icon(Icons.numbers),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final qty = int.tryParse(value);
                      if (qty == null || qty < 1) {
                        return 'Must be ≥ 1';
                      }
                      return null;
                    },
                    onChanged: (_) => controller.calculateTotal(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: controller.unitPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Unit Price *',
                      prefixText: '\$ ',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price is required';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price < 0) {
                        return 'Invalid price';
                      }
                      return null;
                    },
                    onChanged: (_) => controller.calculateTotal(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        controller.totalAmount.value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxesAndDiscountsSection(EditOrderItemController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Taxes & Discounts (Optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.vatController,
              decoration: const InputDecoration(
                labelText: 'VAT Amount',
                prefixText: '\$ ',
                prefixIcon: Icon(Icons.receipt_long),
                border: OutlineInputBorder(),
                helperText: 'Value Added Tax',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.promoController,
              decoration: const InputDecoration(
                labelText: 'Promo Discount',
                prefixText: '\$ ',
                prefixIcon: Icon(Icons.discount),
                border: OutlineInputBorder(),
                helperText: 'Promotional discount amount',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(EditOrderItemController controller) {
    return Obx(() => ElevatedButton(
          onPressed:
              controller.isSubmitting.value ? null : controller.submitOrderItem,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: controller.isSubmitting.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  controller.isEditMode ? 'Update Item' : 'Add Item',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ));
  }
}
