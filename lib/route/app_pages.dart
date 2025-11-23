import 'package:ecommerce_urban/modules/add_product/add_product_route.dart';
import 'package:ecommerce_urban/modules/address/address_route.dart';
import 'package:ecommerce_urban/modules/auth/auth_route.dart';
import 'package:ecommerce_urban/modules/bottom_nav/bottom_nav_route.dart';
import 'package:ecommerce_urban/modules/cart/cart_route.dart';
import 'package:ecommerce_urban/modules/category/category_route.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/admin_route.dart';
import 'package:ecommerce_urban/modules/dashboard/dashboard_route.dart';
import 'package:ecommerce_urban/modules/order/order_route.dart';
import 'package:ecommerce_urban/modules/order_history/order_history_route.dart';
import 'package:ecommerce_urban/modules/order_management.dart/order_management_route.dart';
import 'package:ecommerce_urban/modules/product/product_route.dart';
import 'package:ecommerce_urban/modules/profile/profile_routes.dart';
import 'package:ecommerce_urban/modules/profile_management/profile_management_route.dart';
import 'package:ecommerce_urban/modules/wishlist/wishlist_routes.dart';

class AppPages {
  static final pages = [
    ...authRoutes,
    ...adminRoute,
    ...profileRoutes,
    ...wishlistRoutes,
    ...addProductRoute,
    ...orderMangementRoute,
    ...cartRoute,
    ...productRoutes,
    ...addressRoute,
    ...profileManagementRoute,
    ...orderHistoryRoutes,
    ...categoryRoute,
    ...bottomNavRoute,
    ...orderRoutes,
    ...dashboardRoutes,
  ];
}
