import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateOrderController extends GetxController {
  final formKey = GlobalKey<FormState>();

  /// Reactive states
  var sameAsShipping = false.obs;
  var isSubmitting = false.obs;

  /// Cart
  final cartId = TextEditingController();

  /// Shipping
  final shipName = TextEditingController();
  final shipLine1 = TextEditingController();
  final shipLine2 = TextEditingController();
  final shipCity = TextEditingController();
  final shipState = TextEditingController();
  final shipPostal = TextEditingController();
  final shipCountry = TextEditingController();

  /// Billing
  final billName = TextEditingController();
  final billLine1 = TextEditingController();
  final billLine2 = TextEditingController();
  final billCity = TextEditingController();
  final billState = TextEditingController();
  final billPostal = TextEditingController();
  final billCountry = TextEditingController();

  /// Pricing
  final discount = TextEditingController();
  final tax = TextEditingController();
  final shippingCost = TextEditingController();

  /// Notes
  final notes = TextEditingController();

  void copyToBilling() {
    billName.text = shipName.text;
    billLine1.text = shipLine1.text;
    billLine2.text = shipLine2.text;
    billCity.text = shipCity.text;
    billState.text = shipState.text;
    billPostal.text = shipPostal.text;
    billCountry.text = shipCountry.text;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    isSubmitting.value = true;

    await Future.delayed(const Duration(seconds: 1));

    isSubmitting.value = false;

    Get.snackbar(
      "Success",
      "Order created successfully!",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
