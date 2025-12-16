import 'package:ecommerce_urban/api/model/cart_item_model.dart';
import 'package:ecommerce_urban/api/service/cart_service.dart';
import 'package:ecommerce_urban/app/widgets/confirm_dialog_widget.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCartController extends GetxController {

  final CartService _service = CartService();

  var cartItems = <CartItemModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      isLoading.value = true;
      cartItems.value = await _service.getCartItems();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(int productId, int quantity) async {
    try {
      final newItem = await _service.addToCart(productId: productId, quantity: quantity);
      cartItems.add(newItem);
      ToastWidget.show(message: 'Product added to cart');
    } catch (e) {
      ToastWidget.show(type: 'error', message: e.toString());
    }
  }

  Future<void> updateCartItem(int cartId, int quantity) async {
    try {
      final updatedItem = await _service.updateCartItem(cartId: cartId, quantity: quantity);
      final index = cartItems.indexWhere((item) => item.id == cartId);
      if (index != -1) cartItems[index] = updatedItem;
      // ToastWidget.show(message: 'Cart updated');
    } catch (e) {
      ToastWidget.show(type: 'error', message: e.toString());
    }
  }

  Future<void> removeCartItem(int cartId) async {
    Get.dialog(
      ConfirmDialogWidget(
        title: "Remove",
        subtitle: "Are you sure you want to remove cart Item?",
        icon: Icons.remove_circle_outline,
        iconColor: Colors.red,
        confirmText: "Remove",
        cancelText: "Cancel",
        onConfirm: () async {
          try {
            await _service.removeCartItem(cartId: cartId);
            cartItems.removeWhere((item) => item.id == cartId);
            ToastWidget.show(message: 'Item removed from cart');
          } catch (e) {
            ToastWidget.show(type: 'error', message: e.toString());
          }
          Get.back();
        },
        onCancel: () => Get.back(),
      ),
    );
  }
}