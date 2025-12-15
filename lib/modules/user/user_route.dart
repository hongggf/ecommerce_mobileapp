import 'package:ecommerce_urban/modules/user/user_main/user_main_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

class UserRoute {

  static final pages = [

    /// User Main
    GetPage(
      name: AppRoutes.userMain,
      page: () => UserMainView(),
    ),
  ];

}