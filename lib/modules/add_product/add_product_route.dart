import 'package:ecommerce_urban/modules/add_product/add_product_binding.dart';
import 'package:ecommerce_urban/modules/add_product/add_product_screen.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final adminAddProductRoute = [
  GetPage(
    name: AppRoutes.adminAddProduct,
    page: () => AdminAddProductView(),
    binding: AddProductBinding(),
  ),
];