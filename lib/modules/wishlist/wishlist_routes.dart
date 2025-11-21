import 'package:ecommerce_urban/modules/product/product_detail/product_detail_screen.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/modules/wishlist/wishlist_screen.dart';
import 'package:ecommerce_urban/route/app_routes.dart';

final wishlistRoutes = [
  GetPage(
    name: AppRoutes.wishlist,
    page: () => WishlistScreen(),
  ),
  
];
