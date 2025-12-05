import 'package:ecommerce_urban/modules/admin_users.dart/admin_users_binding.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/admin_users_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final adminUsersRoute = [
  GetPage(
    name: AppRoutes.adminUsers,
    page: () => AdminUsersView(),
    binding: AdminUsersBinding(),
  )
];