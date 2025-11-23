import 'package:ecommerce_urban/modules/dashboard/admin/admin_binding.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/admin_screen.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final adminRoute = [
  GetPage(
    name: AppRoutes.admin,
    page: () => AdminScreen(),
    binding: AdminBinding(),
  ),
];  