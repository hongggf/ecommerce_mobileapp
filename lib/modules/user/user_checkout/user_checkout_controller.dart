import 'package:ecommerce_urban/api/model/address_model.dart';
import 'package:ecommerce_urban/api/model/order_item_model.dart';
import 'package:ecommerce_urban/api/model/order_model.dart';
import 'package:ecommerce_urban/api/service/address_service.dart';
import 'package:ecommerce_urban/api/service/order_service.dart';
import 'package:ecommerce_urban/app/constants/app_constant.dart';
import 'package:ecommerce_urban/app/services/dio_service.dart';
import 'package:ecommerce_urban/modules/user/user_cart/user_cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCheckoutController extends GetxController {
  // Services
  final AddressService _addressService = AddressService();
  late OrderService _orderService;
  final UserCartController _cartController = Get.find<UserCartController>();

  // Address
  var defaultAddress = Rxn<AddressModel>();
  var isLoadingAddress = false.obs;

  // Order
  var currentOrder = Rxn<OrderModel>();
  var orderItems = <OrderItemModel>[].obs;
  var isLoadingOrder = false.obs;
  var isPlacingOrder = false.obs;

  // Pricing
  var subtotal = 0.0.obs;
  var shippingFee = 10.0.obs;
  var discount = 0.0.obs;
  var totalAmount = 0.0.obs;

  // Error
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _orderService = OrderService(DioService.dio);
    fetchDefaultAddress();
    calculateTotals();
    print('✅ UserCheckoutController initialized');
  }

  // ==================== ADDRESS ====================

  Future<void> fetchDefaultAddress() async {
    try {
      isLoadingAddress.value = true;
      print('📍 Fetching default address...');

      final address = await _addressService.getDefaultAddress();
      defaultAddress.value = address;

      print('✅ Address fetched: ${address?.id} ');
    } catch (e) {
      errorMessage.value = 'Failed to load address: $e';
      print('❌ Address error: $e');
      Get.snackbar('Error', 'Failed to load address');
    } finally {
      isLoadingAddress.value = false;
    }
  }

  void changeAddress() {
    Get.toNamed('/user-address');
  }

  // ==================== PRICING ====================

  void calculateTotals() {
    try {
      subtotal.value = _cartController.getCartTotal();
      shippingFee.value = subtotal.value > 100 ? 0.0 : 10.0;
      discount.value = 0.0;
      totalAmount.value = subtotal.value + shippingFee.value - discount.value;

      print('💰 Totals calculated:');
      print('   Subtotal: \$${subtotal.value.toStringAsFixed(2)}');
      print('   Shipping: \$${shippingFee.value.toStringAsFixed(2)}');
      print('   Discount: \$${discount.value.toStringAsFixed(2)}');
      print('   Total: \$${totalAmount.value.toStringAsFixed(2)}');
    } catch (e) {
      print('❌ Error calculating totals: $e');
    }
  }

  double getTaxAmount() {
    return subtotal.value * 0.1;
  }

  // ==================== ORDER ====================

  Future<bool> placeOrder() async {
    try {
      // Validation
      if (defaultAddress.value == null) {
        _showError('Please select a delivery address');
        return false;
      }

      if (_cartController.cartItems.isEmpty) {
        _showError('Your cart is empty');
        return false;
      }

      isPlacingOrder.value = true;
      errorMessage.value = '';

      print('═══════════════════════════════════════════');
      print('🛒 PLACING ORDER');
      print('═══════════════════════════════════════════');
      print('Cart items: ${_cartController.cartItems.length}');
      print('Address ID: ${defaultAddress.value!.id}');
      print('Subtotal: \$${subtotal.value}');
      print('Shipping: \$${shippingFee.value}');
      print('═══════════════════════════════════════════');

      // Step 1: Create Order
      print('\n📝 STEP 1: Creating order...');
      final order = await _orderService.createOrder(
        addressId: defaultAddress.value!.id ?? 0,
        subtotal: subtotal.value,
        shippingFee: shippingFee.value,
        discount: discount.value,
      );

      if (order.id == null) {
        throw Exception('Order created but no ID returned');
      }

      currentOrder.value = order;
      print('✅ Order created successfully - ID: ${order.id}');

      // Step 2: Add Items to Order
      print('\n📝 STEP 2: Adding ${_cartController.cartItems.length} items to order...');
      int successfulItems = 0;

      for (int i = 0; i < _cartController.cartItems.length; i++) {
        final cartItem = _cartController.cartItems[i];
        try {
          print('   Adding item ${i + 1}/${_cartController.cartItems.length}: '
              'Product ID: ${cartItem.product?.id}, Qty: ${cartItem.quantity}');

          await _orderService.addOrderItem(
            orderId: order.id!,
            productId: cartItem.product?.id ?? 0,
            quantity: cartItem.quantity ?? 0,
          );

          successfulItems++;
          print('   ✅ Item added successfully');
        } catch (e) {
          print('   ❌ Failed to add item: ${cartItem.product?.name} - $e');
          _showError('Failed to add item: ${cartItem.product?.name}');
          return false;
        }
      }

      print('✅ All $successfulItems items added successfully\n');

      // Step 3: Fetch Order Items
      print('📝 STEP 3: Fetching order items...');
      await fetchOrderItems(order.id!);

      print('═══════════════════════════════════════════');
      print('✅ ORDER PLACED SUCCESSFULLY');
      print('Order ID: ${order.id}');
      print('═══════════════════════════════════════════\n');

      isPlacingOrder.value = false;

      // Clear cart after successful order
      await _cartController.clearCart();

      // Navigate to success screen or show success snackbar
      Get.snackbar(
        'Success',
        'Order placed successfully!',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      print('\n═══════════════════════════════════════════');
      print('❌ ORDER PLACEMENT FAILED');
      print('Error: $e');
      print('═══════════════════════════════════════════\n');

      errorMessage.value = _formatErrorMessage(e.toString());
      isPlacingOrder.value = false;

      Get.snackbar(
        'Error',
        errorMessage.value,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return false;
    }
  }

  Future<void> fetchOrderItems(int orderId) async {
    try {
      print('📦 Fetching order items for order ID: $orderId...');

      isLoadingOrder.value = true;
      final items = await _orderService.getOrderItems(orderId);
      orderItems.assignAll(items);

      print('✅ ${items.length} items fetched');
    } catch (e) {
      print('❌ Failed to fetch order items: $e');
      errorMessage.value = 'Failed to fetch order items';
      Get.snackbar('Error', 'Failed to fetch order items');
    } finally {
      isLoadingOrder.value = false;
    }
  }

  // ==================== UTILITY ====================

  void clearOrder() {
    currentOrder.value = null;
    orderItems.clear();
    errorMessage.value = '';
    print('🗑️ Order cleared');
  }

  void _showError(String message) {
    errorMessage.value = message;
    print('⚠️ Error: $message');
    Get.snackbar(
      'Error',
      message,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  String _formatErrorMessage(String error) {
    if (error.contains('404')) {
      return 'API endpoint not found. Check your server configuration.';
    } else if (error.contains('401') || error.contains('Unauthorized')) {
      return 'Authentication failed. Please login again.';
    } else if (error.contains('500')) {
      return 'Server error. Please try again later.';
    } else if (error.contains('Connection refused')) {
      return 'Cannot connect to server. Check your API URL.';
    } else if (error.contains('SocketException')) {
      return 'Network connection error. Check your internet.';
    } else {
      return error.length > 100 ? error.substring(0, 100) + '...' : error;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}