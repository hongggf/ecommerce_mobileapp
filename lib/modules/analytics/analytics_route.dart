import 'package:ecommerce_urban/modules/analytics/analytics_binding.dart';
import 'package:ecommerce_urban/modules/analytics/analytics_screen.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final analyticsRoute = [
  // Define analytics routes here
  GetPage(
    name:AppRoutes.analytics  ,
    page: () => AnalyticsScreen(), // Replace with AnalyticsScreen()
    binding: AnalyticsBinding(), // Replace with AnalyticsBinding()
  ),
];