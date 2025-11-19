import 'package:ecommerce_urban/modules/dashboard/admin/admin_binding.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/admin_screen.dart';
import 'package:ecommerce_urban/modules/dashboard/customer/customer_binding.dart';
import 'package:ecommerce_urban/modules/dashboard/customer/customer_screen.dart';
import 'package:ecommerce_urban/modules/dashboard/staff/staff_binding.dart';
import 'package:ecommerce_urban/modules/dashboard/staff/staff_screen.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

final dashboardRoutes = [
  GetPage(
    name: AppRoutes.admin,
    page: () => AdminScreen(),
    binding: AdminBinding(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.customer,
    page: () => CustomerScreen(),
    binding: CustomerBinding(),
  ),
  GetPage(
    name: AppRoutes.staff,
    page: () => StaffScreen(),
    binding: StaffBinding(),
  ),
];
