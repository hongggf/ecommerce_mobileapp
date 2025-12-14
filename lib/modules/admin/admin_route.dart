import 'package:ecommerce_urban/modules/admin/admin_main/admin_main_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

class AdminRoute {

  static final pages = [

    /// Admin Main
    GetPage(
      name: AppRoutes.adminMain,
      page: () => AdminMainView(),
    ),


  ];

}