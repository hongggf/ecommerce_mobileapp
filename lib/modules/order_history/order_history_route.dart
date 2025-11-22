import 'package:ecommerce_urban/modules/order_history/order_history_binding.dart';
import 'package:ecommerce_urban/modules/order_history/order_history_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

final orderHistoryRoutes = [
  GetPage(
    name: AppRoutes.orderHistory,
    page: () => OrderHistoryView(),
    binding: OrderHistoryBinding(),
    transition: Transition.fadeIn,
  ),

];
