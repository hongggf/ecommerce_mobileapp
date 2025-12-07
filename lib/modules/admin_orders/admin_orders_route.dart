import 'package:ecommerce_urban/modules/admin_orders/admin_orders_binding.dart';
import 'package:ecommerce_urban/modules/admin_orders/admin_orders_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final adminOrderRoute = [
  GetPage(
    name: AppRoutes.adminOrders,
    page: () => AdminOrderView(),
    binding: AdminOrderBinding(),
  )
];