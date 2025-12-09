// lib/modules/cart/repositories/cart_repository.dart

import 'package:ecommerce_urban/app/model/cart_item_model.dart';
import 'package:ecommerce_urban/app/model/cart_model.dart';
import 'package:ecommerce_urban/app/services/base_http_service.dart';


class CartRepository extends BaseHttpService {
  /// Create a new cart
  /// POST /carts
  Future<Cart> createCart() async {
    try {
      final response = await post('/carts', {});
      return Cart.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('Failed to create cart: $e');
    }
  }

  /// Get all carts for authenticated user
  /// GET /carts
  Future<List<Cart>> getCarts() async {
    try {
      print('📦 [CartRepository] getCarts called');
      final response = await get('/carts');
      
      print('📦 [CartRepository] Response: $response');

      // Handle both response formats
      List<dynamic> cartsList = [];
      
      if (response['carts'] != null) {
        // Format: { "carts": [...] }
        cartsList = response['carts'] as List;
      } else if (response['data'] != null) {
        // Format: { "data": [...] }
        cartsList = response['data'] as List;
      } else if (response is List) {
        // Format: [...]
        cartsList = response;
      }

      print('📦 [CartRepository] Found ${cartsList.length} carts');

      final carts = cartsList.map((cart) {
        print('📦 [CartRepository] Parsing cart: $cart');
        return Cart.fromJson(cart as Map<String, dynamic>);
      }).toList();

      return carts;
    } catch (e) {
      print('📦 [CartRepository] getCarts ERROR: $e');
      throw Exception('Failed to load carts: $e');
    }
  }

  /// Get single cart by ID
  /// GET /carts/{id}
  Future<Cart> getCart(int cartId) async {
    try {
      final response = await get('/carts/$cartId');
      return Cart.fromJson(response['data'] ?? response['cart'] ?? response);
    } catch (e) {
      throw Exception('Failed to load cart: $e');
    }
  }

  /// Update cart status
  /// PUT /carts/{id}
  Future<Cart> updateCart(int cartId, String status) async {
    try {
      final response = await put('/carts/$cartId', {'status': status});
      return Cart.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('Failed to update cart: $e');
    }
  }

  /// Delete cart
  /// DELETE /carts/{id}
  Future<void> deleteCart(int cartId) async {
    try {
      await delete('/carts/$cartId');
    } catch (e) {
      throw Exception('Failed to delete cart: $e');
    }
  }

  // =====================================================
  // CART ITEMS ENDPOINTS
  // =====================================================

  /// Get cart items
  /// GET /cart-items/{cartId}
  Future<List<CartItem>> getCartItems(int cartId) async {
    try {
      final response = await get('/cart-items/$cartId');
      final itemsList = response['data'] as List? ?? 
                        response['items'] as List? ?? 
                        (response is List ? response : []);
      return itemsList.map((item) => CartItem.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load cart items: $e');
    }
  }

  /// Add item to cart
  /// POST /cart-items
  Future<CartItem> addCartItem({
    required int cartId,
    required int variantId,
    required int quantity,
    String? size,
    String? color,
  }) async {
    try {
      print('📦 [CartRepository] addCartItem called');
      print('📦 Cart ID: $cartId');
      print('📦 Variant ID: $variantId');
      print('📦 Quantity: $quantity');
      print('📦 Size: $size');
      print('📦 Color: $color');

      final requestBody = {
        'cart_id': cartId,
        'variant_id': variantId,
        'quantity': quantity,
        if (size != null) 'size': size,
        if (color != null) 'color': color,
      };

      print('📦 [CartRepository] Request body: $requestBody');

      final response = await post('/cart-items', requestBody);

      print('📦 [CartRepository] Response received: $response');

      final cartItem = CartItem.fromJson(response['data'] ?? response);

      print('📦 [CartRepository] CartItem parsed successfully: ${cartItem.id}');

      return cartItem;
    } catch (e) {
      print('📦 [CartRepository] ERROR in addCartItem: $e');
      print('📦 [CartRepository] Error type: ${e.runtimeType}');
      throw Exception('Failed to add cart item: $e');
    }
  }

  /// Update cart item quantity
  /// PUT /cart-items/{id}
  Future<CartItem> updateCartItem({
    required int cartId,
    required int itemId,
    required int quantity,
  }) async {
    try {
      final response = await put('/cart-items/$itemId', {
        'quantity': quantity,
      });
      return CartItem.fromJson(response['data'] ?? response);
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  /// Remove item from cart
  /// DELETE /cart-items/{id}
  Future<void> removeCartItem(int itemId) async {
    try {
      await delete('/cart-items/$itemId');
    } catch (e) {
      throw Exception('Failed to remove cart item: $e');
    }
  }

  /// Clear entire cart (delete all items)
  /// Note: This removes all items by calling the delete endpoint for each item
  /// Alternatively, you may want to batch delete - adjust based on your API
  Future<void> clearCart(int cartId) async {
    try {
      final items = await getCartItems(cartId);
      for (var item in items) {
        await removeCartItem(int.parse(item.id));
      }
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
}