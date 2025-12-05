import 'package:ecommerce_urban/modules/stock_mangement/stock_binding.dart';
import 'package:ecommerce_urban/modules/stock_mangement/stock_screen.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final stockRoute =[
  GetPage(
    name: AppRoutes.stockManagement,
    page: () => StockScreen(),
    binding: StockBinding(),
  ),
];