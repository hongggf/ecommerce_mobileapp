import 'package:ecommerce_urban/modules/category/category_binding.dart';
import 'package:ecommerce_urban/modules/category/category_screen.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

final categoryRoute = [
  GetPage(
    name: AppRoutes.category,
    page: () => CategoryScreen(),
    binding: CategoryBinding(),
    transition: Transition.fadeIn,
  ),
];