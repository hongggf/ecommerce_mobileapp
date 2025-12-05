import 'package:ecommerce_urban/modules/user_mangement/user_management_binding.dart';
import 'package:ecommerce_urban/modules/user_mangement/user_management_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final userMangementRoute =[
  GetPage(
    name: AppRoutes.userMangement,
    page: () => UserManagementView(),
    binding: UserManagementBinding(),
  ),
];