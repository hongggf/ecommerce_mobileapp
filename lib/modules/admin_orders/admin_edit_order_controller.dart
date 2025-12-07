// lib/modules/admin_orders/admin_edit_order_controller.dart
import 'package:ecommerce_urban/modules/admin_orders/admin_orders_controller.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/order_items_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditOrderItemController extends GetxController {
  final int orderId;
  final OrderItem? item;
  final AdminOrdersController orderController = Get.find<AdminOrdersController>();

  final formKey = GlobalKey<FormState>();
  final productIdController = TextEditingController();
  final variantIdController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final unitPriceController = TextEditingController();
  final vatController = TextEditingController(text: '0');
  final promoController = TextEditingController(text: '0');

  final RxBool isSubmitting = false.obs;
  final RxString totalAmount = '\$0.00'.obs;

  bool get isEditMode => item != null;

  EditOrderItemController({required this.orderId, this.item});

  @override
  void onInit() {
    super.onInit();
    if (isEditMode) {
      _loadItemData();
    }
    calculateTotal();
  }

  void _loadItemData() {
    productIdController.text = item!.productId.toString();
    variantIdController.text = item!.variantId?.toString() ?? '';
    quantityController.text = item!.quantity.toString();
    unitPriceController.text = item!.unitPrice;

    if (item!.taxes != null && item!.taxes!.containsKey('vat')) {
      vatController.text = item!.taxes!['vat'].toString();
    }
    if (item!.discounts != null && item!.discounts!.containsKey('promo')) {
      promoController.text = item!.discounts!['promo'].toString();
    }
  }

  void calculateTotal() {
    final quantity = int.tryParse(quantityController.text) ?? 0;
    final unitPrice = double.tryParse(unitPriceController.text) ?? 0;
    final total = quantity * unitPrice;
    totalAmount.value = '\$${total.toStringAsFixed(2)}';
  }

  @override
  void onClose() {
    productIdController.dispose();
    variantIdController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    vatController.dispose();
    promoController.dispose();
    super.onClose();
  }

  Future<void> submitOrderItem() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isSubmitting.value = true;

    final vat = double.tryParse(vatController.text) ?? 0;
    final promo = double.tryParse(promoController.text) ?? 0;

    final orderItem = OrderItem(
      id: isEditMode ? item!.id : null,
      orderId: orderId,
      productId: int.parse(productIdController.text),
      variantId: variantIdController.text.isEmpty
          ? null
          : int.parse(variantIdController.text),
      quantity: int.parse(quantityController.text),
      unitPrice: unitPriceController.text,
      taxes: vat > 0 ? {'vat': vat} : null,
      discounts: promo > 0 ? {'promo': promo} : null,
    );

    bool success;
    if (isEditMode) {
      success = await orderController.updateOrderItem(orderItem);
    } else {
      success = await orderController.createOrderItem(orderItem);
    }

    isSubmitting.value = false;

    if (success) {
      Get.back(result: true);
    }
  }
}
