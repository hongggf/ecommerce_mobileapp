import 'package:ecommerce_urban/modules/product/product/product_binding.dart';
import 'package:ecommerce_urban/modules/product/product_detail/product_detail_binding.dart';
import 'package:ecommerce_urban/modules/product/product_detail/product_detail_screen.dart';
import 'package:ecommerce_urban/modules/product/product/productList_screen.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

final productRoutes = [
  GetPage(
    name: AppRoutes.product,
    page: () => ProductListScreen(),
    binding: ProductBinding(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.productDetail,
    page: () => ProductDetailScreen(),
    binding: ProductDetailBinding(),
    transition: Transition.fadeIn,
  ),
];
