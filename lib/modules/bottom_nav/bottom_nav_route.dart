import 'package:ecommerce_urban/modules/bottom_nav/bottom_nav.dart';
import 'package:ecommerce_urban/modules/bottom_nav/bottom_nav_binding.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

final bottomNavRoute = [
  GetPage(
    name: AppRoutes.bottomNav,
    page: () => BottomNav(),
    binding: BottomNavBinding(),
  )
];
