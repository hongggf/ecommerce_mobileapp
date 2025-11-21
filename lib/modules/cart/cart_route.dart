import 'package:ecommerce_urban/modules/cart/cart_binding.dart';
import 'package:ecommerce_urban/modules/cart/cart_screen.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

final cartRoute = [
  GetPage(
    name: AppRoutes.cart,
    page: () => CartScreen(),
    binding: CartBinding(),
  )
];
