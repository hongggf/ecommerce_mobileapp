// lib/modules/cart/bindings/cart_binding.dart

import 'package:ecommerce_urban/modules/cart/cart_controller.dart';
import 'package:get/get.dart';


class CartBinding extends Bindings {
  @override
  void dependencies() {
    // Use fenix: true to keep controller alive even if it's unbound
    Get.lazyPut<CartController>(
      () {
        print('🛒 [CartBinding] Initializing CartController');
        return CartController();
      },
      fenix: true,
    );
  }
}