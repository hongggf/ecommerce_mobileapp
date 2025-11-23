import 'package:ecommerce_urban/modules/order/order_summary_screen.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final orderRoutes = [
  GetPage(
    name: AppRoutes.orderSummary,
    page: () => OrderSummaryScreen(),
   // binding: CartBinding(),
  )
];  