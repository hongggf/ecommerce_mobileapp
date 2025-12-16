import 'package:ecommerce_urban/api/model/cart_item_model.dart';
import 'package:ecommerce_urban/api/service/cart_service.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final CartService _service = CartService();

  // Observable cart items list
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  // Loading state
  RxBool isLoading = false.obs;

  /// Add product to cart
  Future<void> addProductToCart({required int productId, required int quantity}) async {
    try {
      isLoading.value = true;

      final CartItemModel newItem = await _service.addToCart(
        productId: productId,
        quantity: quantity,
      );

      // Check if item already exists in cart
      final index = cartItems.indexWhere((item) => item.product.id == productId);
      if (index >= 0) {
        // Update quantity
        cartItems[index].quantity = newItem.quantity;
        cartItems.refresh();
      } else {
        // Add new item
        cartItems.add(newItem);
      }

      ToastWidget.show(message: 'Product added to cart');
    } catch (e) {
      ToastWidget.show(type: 'error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}