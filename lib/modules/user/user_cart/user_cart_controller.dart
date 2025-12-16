// import 'package:ecommerce_urban/api/model/cart_item_model.dart';
// import 'package:ecommerce_urban/api/service/cart_service.dart';
// import 'package:ecommerce_urban/app/widgets/confirm_dialog_widget.dart';
// import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class UserCartController extends GetxController {

//   final CartService _service = CartService();

//   var cartItems = <CartItemModel>[].obs;
//   var isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchCartItems();
//   }

//   Future<void> fetchCartItems() async {
//     try {
//       isLoading.value = true;
//       cartItems.value = await _service.getCartItems();
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> addToCart(int productId, int quantity) async {
//     try {
//       final newItem = await _service.addToCart(productId: productId, quantity: quantity);
//       cartItems.add(newItem);
//       ToastWidget.show(message: 'Product added to cart');
//     } catch (e) {
//       ToastWidget.show(type: 'error', message: e.toString());
//     }
//   }

//   Future<void> updateCartItem(int cartId, int quantity) async {
//     try {
//       final updatedItem = await _service.updateCartItem(cartId: cartId, quantity: quantity);
//       final index = cartItems.indexWhere((item) => item.id == cartId);
//       if (index != -1) cartItems[index] = updatedItem;
//       // ToastWidget.show(message: 'Cart updated');
//     } catch (e) {
//       ToastWidget.show(type: 'error', message: e.toString());
//     }
//   }

//   Future<void> removeCartItem(int cartId) async {
//     Get.dialog(
//       ConfirmDialogWidget(
//         title: "Remove",
//         subtitle: "Are you sure you want to remove cart Item?",
//         icon: Icons.remove_circle_outline,
//         iconColor: Colors.red,
//         confirmText: "Remove",
//         cancelText: "Cancel",
//         onConfirm: () async {
//           try {
//             await _service.removeCartItem(cartId: cartId);
//             cartItems.removeWhere((item) => item.id == cartId);
//             ToastWidget.show(message: 'Item removed from cart');
//           } catch (e) {
//             ToastWidget.show(type: 'error', message: e.toString());
//           }
//           Get.back();
//         },
//         onCancel: () => Get.back(),
//       ),
//     );
//   }
// }import 'package:ecommerce_urban/api/model/cart_item_model.dart';
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

  // Reactive variables for pricing
  var cartTotal = 0.0.obs;
  var cartItemCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  // ==================== FETCH ====================

  Future<void> fetchCartItems() async {
    try {
      isLoading.value = true;
      cartItems.value = await _service.getCartItems();
      calculateTotals();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== ADD TO CART ====================

  Future<void> addToCart(int productId, int quantity) async {
    try {
      final newItem = await _service.addToCart(productId: productId, quantity: quantity);
      cartItems.add(newItem);
      calculateTotals();
      ToastWidget.show(message: 'Product added to cart');
    } catch (e) {
      ToastWidget.show(type: 'error', message: e.toString());
    }
  }

  // ==================== UPDATE CART ====================

  Future<void> updateCartItem(int cartId, int quantity) async {
    try {
      final updatedItem = await _service.updateCartItem(cartId: cartId, quantity: quantity);
      final index = cartItems.indexWhere((item) => item.id == cartId);
      if (index != -1) {
        cartItems[index] = updatedItem;
        cartItems.refresh();
      }
      calculateTotals();
    } catch (e) {
      ToastWidget.show(type: 'error', message: e.toString());
    }
  }

  // ==================== REMOVE FROM CART ====================

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
            calculateTotals();
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

  // ==================== CALCULATION METHODS ====================

  /// Calculate and update total cart price and item count
  void calculateTotals() {
    cartTotal.value = getCartTotal();
    cartItemCount.value = getTotalQuantity();
  }

  /// Get the total price of all items in cart
  double getCartTotal() {
    return cartItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item.product?.price ?? '0') ?? 0.0;
      return sum + (price * (item.quantity ?? 1));
    });
  }

  /// Get total number of items (quantity)
  int getTotalQuantity() {
    return cartItems.fold(0, (sum, item) {
      return sum + (item.quantity ?? 0);
    });
  }

  /// Get total number of unique products
  int getTotalUniqueProducts() {
    return cartItems.length;
  }

  /// Get formatted total price as string
  String getFormattedTotal() {
    return '\$${getCartTotal().toStringAsFixed(2)}';
  }

  /// Get average price per item
  double getAveragePrice() {
    if (cartItems.isEmpty) return 0.0;
    final total = getTotalQuantity();
    if (total == 0) return 0.0;
    return getCartTotal() / total;
  }

  /// Check if cart is empty
  bool isCartEmpty() {
    return cartItems.isEmpty;
  }

  // ==================== PRICING FOR CHECKOUT ====================

  /// Calculate subtotal for checkout
  double getSubtotal() {
    return getCartTotal();
  }

  /// Calculate shipping fee (Free for orders > 100)
  double getShippingFee() {
    final total = getCartTotal();
    return total > 100 ? 0.0 : 10.0;
  }

  /// Calculate tax (10% of subtotal)
  double getTaxAmount({double taxRate = 0.1}) {
    return getSubtotal() * taxRate;
  }

  /// Get discount (if any)
  double getDiscount() {
    return 0.0; // Implement coupon logic here
  }

  /// Calculate final total with all fees and taxes
  double getFinalTotal() {
    final subtotal = getSubtotal();
    final shipping = getShippingFee();
    final tax = getTaxAmount();
    final discount = getDiscount();
    return subtotal + shipping + tax - discount;
  }

  /// Get order summary data
  Map<String, double> getOrderSummary() {
    return {
      'subtotal': getSubtotal(),
      'shipping': getShippingFee(),
      'tax': getTaxAmount(),
      'discount': getDiscount(),
      'total': getFinalTotal(),
    };
  }

  // ==================== ITEM UTILITIES ====================

  /// Get cart item by ID
  CartItemModel? getCartItemById(int cartId) {
    try {
      return cartItems.firstWhere((item) => item.id == cartId);
    } catch (e) {
      return null;
    }
  }

  /// Get cart item by product ID
  CartItemModel? getCartItemByProductId(int productId) {
    try {
      return cartItems.firstWhere((item) => item.product?.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Check if product is already in cart
  bool isProductInCart(int productId) {
    return cartItems.any((item) => item.product?.id == productId);
  }

  /// Get quantity of specific product in cart
  int getProductQuantity(int productId) {
    final item = getCartItemByProductId(productId);
    return item?.quantity ?? 0;
  }

  // ==================== CART MANAGEMENT ====================

  /// Increment quantity of item
  Future<void> incrementQuantity(int cartId) async {
    final item = getCartItemById(cartId);
    if (item != null) {
      await updateCartItem(cartId, (item.quantity ?? 0) + 1);
    }
  }

  /// Decrement quantity of item
  Future<void> decrementQuantity(int cartId) async {
    final item = getCartItemById(cartId);
    if (item != null && (item.quantity ?? 0) > 1) {
      await updateCartItem(cartId, (item.quantity ?? 0) - 1);
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    Get.dialog(
      ConfirmDialogWidget(
        title: "Clear Cart",
        subtitle: "Are you sure you want to clear all items from cart?",
        icon: Icons.delete_outline,
        iconColor: Colors.red,
        confirmText: "Clear",
        cancelText: "Cancel",
        onConfirm: () async {
          try {
            for (var item in cartItems) {
              await _service.removeCartItem(cartId: item.id ?? 0);
            }
            cartItems.clear();
            calculateTotals();
            ToastWidget.show(message: 'Cart cleared');
          } catch (e) {
            ToastWidget.show(type: 'error', message: e.toString());
          }
          Get.back();
        },
        onCancel: () => Get.back(),
      ),
    );
  }

  /// Get list of items with specific product name
  List<CartItemModel> getItemsByProductName(String searchTerm) {
    return cartItems
        .where((item) => (item.product?.name ?? '').toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }

  // ==================== DATA FOR ORDER ====================

  /// Get formatted cart data for order
  List<Map<String, dynamic>> getCartDataForOrder() {
    return cartItems.map((item) {
      return {
        'product_id': item.product?.id,
        'quantity': item.quantity,
        'price': item.product?.price,
        'name': item.product?.name,
      };
    }).toList();
  }

  /// Get cart summary as string for display
  String getCartSummaryString() {
    return '${getTotalUniqueProducts()} items • ${getFormattedTotal()}';
  }
}