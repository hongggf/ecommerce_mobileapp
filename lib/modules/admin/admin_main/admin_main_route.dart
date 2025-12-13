import 'package:ecommerce_urban/modules/admin/admin_main/admin_main_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

class AdminMainRoute {
  static final pages = [
    GetPage(
      name: AppRoutes.adminMain,
      page: () => AdminMainView(),
    ),
  ];
}