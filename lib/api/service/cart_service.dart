import 'package:dio/dio.dart';
import 'package:ecommerce_urban/api/model/cart_item_model.dart';
import 'package:ecommerce_urban/app/constants/app_constant.dart';
import 'package:ecommerce_urban/app/services/dio_service.dart';

class CartService {
  final Dio _dio = DioService.dio;

  // GET: All cart items
  Future<List<CartItemModel>> getCartItems() async {
    final response = await _dio.get(AppConstant.cartItems);
    final List list = response.data['data'];
    return list.map((e) => CartItemModel.fromJson(e)).toList();
  }

  // POST: Add product to cart
  Future<CartItemModel> addToCart({required int productId, required int quantity}) async {
    final response = await _dio.post(AppConstant.cartItems, data: {
      'product_id': productId,
      'quantity': quantity,
    });
    return CartItemModel.fromJson(response.data['data']);
  }

  // PUT: Update cart quantity
  Future<CartItemModel> updateCartItem({required int cartId, required int quantity}) async {
    final response = await _dio.put(AppConstant.cartItemById(cartId), data: {
      'quantity': quantity,
    });
    return CartItemModel.fromJson(response.data['data']);
  }

  // DELETE: Remove cart item
  Future<void> removeCartItem({required int cartId}) async {
    await _dio.delete(AppConstant.cartItemById(cartId));
  }
}