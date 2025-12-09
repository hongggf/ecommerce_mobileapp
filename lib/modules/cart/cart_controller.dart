// lib/modules/cart/controllers/cart_controller.dart

import 'package:ecommerce_urban/app/model/cart_item_model.dart';
import 'package:ecommerce_urban/app/model/cart_model.dart';
import 'package:ecommerce_urban/app/repositories/cart_respository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_urban/app/services/storage_services.dart';


class CartController extends GetxController {
  late CartRepository _cartRepository;
  final StorageService _storage = StorageService();

  // Observables
  final cartItems = <CartItem>[].obs;
  final selectedItemsCount = 0.obs;
  final isLoading = false.obs;
  final currentCart = Rx<Cart?>(null);
  final cartId = Rx<int?>(null);
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
    _checkAuthAndLoadCart();
  }

  void _initializeRepository() {
    _cartRepository = CartRepository();
  }

  // --------------------------
  // AUTHENTICATION CHECK
  // --------------------------

  Future<void> _checkAuthAndLoadCart() async {
    try {
      isLoading.value = true;

      // Check if user is logged in
      final token = await _storage.getToken();

      if (token == null || token.isEmpty) {
        isLoggedIn.value = false;
        isLoading.value = false;
        return;
      }

      isLoggedIn.value = true;
      await _loadCart();
    } catch (e) {
      isLoggedIn.value = false;
      Get.snackbar(
        'Error',
        'Failed to initialize cart: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --------------------------
  // CART INITIALIZATION & LOADING
  // --------------------------

  Future<void> _loadCart() async {
    try {
      isLoading.value = true;

      // Check if user is logged in before loading cart
      final token = await _storage.getToken();
      if (token == null || token.isEmpty) {
        isLoggedIn.value = false;
        isLoading.value = false;
        return;
      }

      print('🛒 [CartController] _loadCart: Fetching carts from API...');

      // Try to get existing cart or create new one
      final carts = await _cartRepository.getCarts();
      
      print('🛒 [CartController] _loadCart: Got ${carts.length} carts');

      if (carts.isNotEmpty) {
        final activeCart = carts.firstWhere(
          (c) => c.status == 'active',
          orElse: () => carts.first,
        );
        
        print('🛒 [CartController] _loadCart: Using cart ID: ${activeCart.id}');
        currentCart.value = activeCart;
        cartId.value = activeCart.id;
        await _loadCartItems(activeCart.id);
      } else {
        print('🛒 [CartController] _loadCart: No carts found, creating new...');
        await _createNewCart();
      }
    } catch (e) {
      print('🛒 [CartController] _loadCart ERROR: $e');
      Get.snackbar(
        'Error',
        'Failed to load cart: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createNewCart() async {
    try {
      print('🛒 [CartController] _createNewCart: Creating new cart...');
      final newCart = await _cartRepository.createCart();
      
      print('🛒 [CartController] _createNewCart: New cart created with ID: ${newCart.id}');
      
      if (newCart.id <= 0) {
        throw Exception('Invalid cart ID received: ${newCart.id}');
      }
      
      currentCart.value = newCart;
      cartId.value = newCart.id;
      
      print('🛒 [CartController] _createNewCart: Cart ID set to ${cartId.value}');
    } catch (e) {
      print('🛒 [CartController] _createNewCart ERROR: $e');
      Get.snackbar(
        'Error',
        'Failed to create cart: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadCartItems(int cId) async {
    try {
      final items = await _cartRepository.getCartItems(cId);
      cartItems.assignAll(items);
      updateSelectedCount();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load cart items: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // --------------------------
  // ADD TO CART (From Product Screen)
  // --------------------------

  Future<void> addToCart({
    required int variantId,
    required String productName,
    required String productImage,
    required double price,
    required int quantity,
    String? size,
    String? color,
  }) async {
    try {
      print('🛒 [CartController] addToCart called');
      print('🛒 Variant ID: $variantId');
      print('🛒 Product Name: $productName');
      print('🛒 Price: $price');
      print('🛒 Quantity: $quantity');

      // Check if user is logged in
      final token = await _storage.getToken();
      print('🛒 [CartController] Token check: ${token != null ? 'Has token' : 'No token'}');
      
      if (token == null || token.isEmpty) {
        print('🛒 [CartController] User not logged in');
        Get.snackbar(
          'Login Required',
          'Please login to add items to cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          mainButton: TextButton(
            onPressed: () {
              Get.toNamed('/login');
            },
            child: const Text('Login'),
          ),
        );
        return;
      }

      isLoading.value = true;
      print('🛒 [CartController] Loading started');

      // Ensure we have a cart
      if (cartId.value == null) {
        print('🛒 [CartController] No cart ID, creating new cart...');
        await _createNewCart();
      }

      print('🛒 [CartController] Cart ID: ${cartId.value}');

      // Add item to cart via API
      print('🛒 [CartController] Calling repository.addCartItem()');
      final newItem = await _cartRepository.addCartItem(
        cartId: cartId.value!,
        variantId: variantId,
        quantity: quantity,
        size: size,
        color: color,
      );

      print('🛒 [CartController] Item added successfully: ${newItem.id}');

      // Reload cart items to get updated data
      print('🛒 [CartController] Reloading cart items...');
      await _loadCartItems(cartId.value!);

      print('🛒 [CartController] Cart items reloaded');

      Get.snackbar(
        'Success',
        'Added $quantity x $productName to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      print('🛒 [CartController] Success snackbar shown');
    } catch (e) {
      print('🛒 [CartController] ERROR: $e');
      print('🛒 [CartController] Error type: ${e.runtimeType}');
      print('🛒 [CartController] Stack trace: ${StackTrace.current}');
      
      Get.snackbar(
        'Error',
        'Failed to add item to cart: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      print('🛒 [CartController] Loading finished');
    }
  }

  // --------------------------
  // SELECTION LOGIC
  // --------------------------

  void toggleItemSelection(String id) {
    final item = cartItems.firstWhere(
      (i) => i.id == id,
      orElse: () => CartItem(
        id: '',
        name: '',
        image: '',
        price: 0,
        variantId: 0,
      ),
    );

    if (item.id.isNotEmpty) {
      item.isSelected.toggle();
      updateSelectedCount();
    }
  }

  void selectAllItems(bool select) {
    for (var item in cartItems) {
      item.isSelected.value = select;
    }
    updateSelectedCount();
  }

  void updateSelectedCount() {
    selectedItemsCount.value =
        cartItems.where((item) => item.isSelected.value).length;
  }

  bool isAllSelected() {
    if (cartItems.isEmpty) return false;
    return cartItems.every((item) => item.isSelected.value);
  }

  // --------------------------
  // QUANTITY MANAGEMENT
  // --------------------------

  Future<void> increaseQuantity(String id) async {
    try {
      final item = cartItems.firstWhere((i) => i.id == id);
      final newQuantity = item.quantity.value + 1;

      isLoading.value = true;

      await _cartRepository.updateCartItem(
        cartId: cartId.value!,
        itemId: int.parse(id),
        quantity: newQuantity,
      );

      item.quantity.value = newQuantity;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update quantity: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> decreaseQuantity(String id) async {
    try {
      final item = cartItems.firstWhere((i) => i.id == id);

      if (item.quantity.value <= 1) {
        await removeItem(id);
        return;
      }

      final newQuantity = item.quantity.value - 1;

      isLoading.value = true;

      await _cartRepository.updateCartItem(
        cartId: cartId.value!,
        itemId: int.parse(id),
        quantity: newQuantity,
      );

      item.quantity.value = newQuantity;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update quantity: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --------------------------
  // ITEM REMOVAL
  // --------------------------

  Future<void> removeItem(String id) async {
    try {
      isLoading.value = true;

      await _cartRepository.removeCartItem(int.parse(id));

      cartItems.removeWhere((i) => i.id == id);
      updateSelectedCount();

      Get.snackbar(
        'Success',
        'Item removed from cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove item: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearCart() async {
    try {
      isLoading.value = true;

      await _cartRepository.clearCart(cartId.value!);

      cartItems.clear();
      selectedItemsCount.value = 0;

      Get.snackbar(
        'Success',
        'Cart cleared',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear cart: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --------------------------
  // CALCULATIONS
  // --------------------------

  double getSelectedItemsTotal() {
    return cartItems
        .where((i) => i.isSelected.value)
        .fold(0, (sum, item) => sum + (item.price * item.quantity.value));
  }

  double getShippingCost() {
    final total = getSelectedItemsTotal();
    return total > 100 ? 0 : 10.0;
  }

  double getTax() {
    return getSelectedItemsTotal() * 0.1;
  }

  double getGrandTotal() {
    return getSelectedItemsTotal() + getShippingCost() + getTax();
  }

  List<CartItem> getSelectedItems() {
    return cartItems.where((i) => i.isSelected.value).toList();
  }

  // --------------------------
  // ORDER PLACEMENT
  // --------------------------

  Future<void> placeOrder() async {
    try {
      final selectedItems = getSelectedItems();

      if (selectedItems.isEmpty) {
        Get.snackbar(
          'Error',
          'Please select items to order',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;

      // Update cart status to 'ordered'
      await _cartRepository.updateCart(cartId.value!, 'ordered');

      Get.snackbar(
        'Success',
        'Order placed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Create a new cart for future purchases
      await _createNewCart();
      cartItems.clear();
      selectedItemsCount.value = 0;

      // Navigate to order confirmation
      // Get.toNamed('/order-confirmation');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to place order: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --------------------------
  // REFRESH & SYNC
  // --------------------------

  Future<void> refreshCart() async {
    if (cartId.value != null) {
      await _loadCartItems(cartId.value!);
    }
  }

  /// Call this when user logs in
  Future<void> onUserLogin() async {
    await _checkAuthAndLoadCart();
  }

  /// Call this when user logs out
  Future<void> onUserLogout() async {
    cartItems.clear();
    selectedItemsCount.value = 0;
    currentCart.value = null;
    cartId.value = null;
    isLoggedIn.value = false;
  }
}