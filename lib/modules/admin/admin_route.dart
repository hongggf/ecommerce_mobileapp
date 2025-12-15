import 'package:ecommerce_urban/modules/admin/admin_category/admin_category_view.dart';
import 'package:ecommerce_urban/modules/admin/admin_inventory/admin_inventory_view.dart';
import 'package:ecommerce_urban/modules/admin/admin_main/admin_main_view.dart';
import 'package:ecommerce_urban/modules/admin/admin_order/admin_order_view.dart';
import 'package:ecommerce_urban/modules/admin/admin_order_detail/admin_order_detail_view.dart';
import 'package:ecommerce_urban/modules/admin/admin_profile/admin_profile_view.dart';
import 'package:ecommerce_urban/modules/admin/admin_report/admin_report_view.dart';
import 'package:ecommerce_urban/modules/admin/admin_user/admin_user_view.dart';
import 'package:ecommerce_urban/modules/admin/admin_user_detail/admin_user_detail_view.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

class AdminRoute {

  static final pages = [

    /// Admin Main
    GetPage(
      name: AppRoutes.adminMain,
      page: () => AdminMainView(),
    ),
    GetPage(
      name: AppRoutes.adminCategory,
      page: () => AdminCategoryView(),
    ),
    GetPage(
      name: AppRoutes.adminInventory,
      page: () => AdminInventoryView(),
    ),
    GetPage(
      name: AppRoutes.adminOrder,
      page: () => AdminOrderView(),
    ),
    GetPage(
      name: AppRoutes.adminOrderDetail,
      page: () => AdminOrderDetailView(),
    ),
    GetPage(
      name: AppRoutes.adminProfile,
      page: () => AdminProfileView(),
    ),
    GetPage(
      name: AppRoutes.adminUser,
      page: () => AdminUserView(),
    ),
    GetPage(
      name: AppRoutes.adminUserDetail,
      page: () => AdminUserDetailView(),
    ),
    GetPage(
      name: AppRoutes.adminReport,
      page: () => AdminReportView(),
    ),
  ];

}