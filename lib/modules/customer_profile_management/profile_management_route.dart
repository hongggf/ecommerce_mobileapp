import 'package:ecommerce_urban/modules/customer_profile_management/profile_management_binding.dart';
import 'package:ecommerce_urban/modules/customer_profile_management/profile_management_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final profileManagementRoute = [
  GetPage(
    name: AppRoutes.profileManagement,
    page: () => ProfileManagementView(),
    binding: ProfileManagementBinding(),
  ),
];