import 'package:ecommerce_urban/modules/order_management.dart/manage_order_binding.dart';
import 'package:ecommerce_urban/modules/order_management.dart/order_management_screen.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final orderMangementRoute = [
  GetPage(
    name: AppRoutes.manageOrders,
    page: () => ManageOrdersScreen(),
    binding: ManageOrderBinding(),
  ),
];