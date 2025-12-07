import 'package:ecommerce_urban/modules/admin_orders/admin_orders_controller.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/address_snapshot_model.dart';
import 'package:ecommerce_urban/modules/admin_orders/model/create_order_request_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CreateOrderController extends GetxController {
  final AdminOrdersController orderController = Get.find<AdminOrdersController>();

  final formKey = GlobalKey<FormState>();
  final cartIdController = TextEditingController();
  final discountController = TextEditingController(text: '0');
  final taxController = TextEditingController(text: '0');
  final shippingController = TextEditingController(text: '0');
  final notesController = TextEditingController();

  // Shipping Address
  final shipNameController = TextEditingController();
  final shipLine1Controller = TextEditingController();
  final shipLine2Controller = TextEditingController();
  final shipCityController = TextEditingController();
  final shipStateController = TextEditingController();
  final shipPostalController = TextEditingController();
  final shipCountryController = TextEditingController(text: 'KH');

  // Billing Address
  final billNameController = TextEditingController();
  final billLine1Controller = TextEditingController();
  final billLine2Controller = TextEditingController();
  final billCityController = TextEditingController();
  final billStateController = TextEditingController();
  final billPostalController = TextEditingController();
  final billCountryController = TextEditingController(text: 'KH');

  final RxBool sameAsShipping = true.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onClose() {
    cartIdController.dispose();
    discountController.dispose();
    taxController.dispose();
    shippingController.dispose();
    notesController.dispose();
    shipNameController.dispose();
    shipLine1Controller.dispose();
    shipLine2Controller.dispose();
    shipCityController.dispose();
    shipStateController.dispose();
    shipPostalController.dispose();
    shipCountryController.dispose();
    billNameController.dispose();
    billLine1Controller.dispose();
    billLine2Controller.dispose();
    billCityController.dispose();
    billStateController.dispose();
    billPostalController.dispose();
    billCountryController.dispose();
    super.onClose();
  }

  void copyShippingToBilling() {
    billNameController.text = shipNameController.text;
    billLine1Controller.text = shipLine1Controller.text;
    billLine2Controller.text = shipLine2Controller.text;
    billCityController.text = shipCityController.text;
    billStateController.text = shipStateController.text;
    billPostalController.text = shipPostalController.text;
    billCountryController.text = shipCountryController.text;
  }

  Future<void> submitOrder() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (sameAsShipping.value) {
      copyShippingToBilling();
    }

    isSubmitting.value = true;

    final request = CreateOrderRequest(
      cartId: int.parse(cartIdController.text),
      shippingAddress: AddressSnapshot(
        recipientName: shipNameController.text,
        line1: shipLine1Controller.text,
        line2:
            shipLine2Controller.text.isEmpty ? null : shipLine2Controller.text,
        city: shipCityController.text,
        state:
            shipStateController.text.isEmpty ? null : shipStateController.text,
        postalCode: shipPostalController.text.isEmpty
            ? null
            : shipPostalController.text,
        countryCode: shipCountryController.text,
      ),
      billingAddress: AddressSnapshot(
        recipientName: billNameController.text,
        line1: billLine1Controller.text,
        line2:
            billLine2Controller.text.isEmpty ? null : billLine2Controller.text,
        city: billCityController.text,
        state:
            billStateController.text.isEmpty ? null : billStateController.text,
        postalCode: billPostalController.text.isEmpty
            ? null
            : billPostalController.text,
        countryCode: billCountryController.text,
      ),
      notes: notesController.text.isEmpty ? null : notesController.text,
      discountTotal: double.tryParse(discountController.text) ?? 0,
      taxTotal: double.tryParse(taxController.text) ?? 0,
      shippingTotal: double.tryParse(shippingController.text) ?? 0,
    );

    final success = await orderController.createOrder(request);

    isSubmitting.value = false;

    if (success) {
      Get.back();
    }
  }
}