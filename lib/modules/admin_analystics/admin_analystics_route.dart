import 'package:ecommerce_urban/modules/admin_analystics/admin_analystics_binding.dart';
import 'package:ecommerce_urban/modules/admin_analystics/admin_analystics_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final adminAnalysticsRoute = [
  GetPage(
    name: AppRoutes.adminAnalytics,
    page: () => AdminAnalyticsView(),
    binding:AdminAnalyticsBinding(),
  )
];  