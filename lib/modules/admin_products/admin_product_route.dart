import 'package:ecommerce_urban/modules/admin_products/admin_products_binding.dart';
import 'package:ecommerce_urban/modules/admin_products/admin_products_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final adminProductsViewRoute = [
  GetPage(
    name: AppRoutes.adminProductsView,
    page: () => AdminProductsView(),
    binding: AdminProductsBinding(),
  )
];