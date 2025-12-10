import 'package:ecommerce_urban/modules/admin_products/binding/admin_products_binding.dart';
import 'package:ecommerce_urban/modules/admin_products/views/admin_products_view.dart';

import 'package:ecommerce_urban/modules/admin_products/views/product_managmetn_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final adminProductsViewRoute = [
  GetPage(
    name: AppRoutes.adminProductsView,
    page: () => AdminProductsView(),
    binding: AdminProductsBinding(),
  ),
  GetPage(
    name: AppRoutes.productManagement,
    page: () => ProductManagementView(),
    binding: AdminProductsBinding(),
  ),
];
