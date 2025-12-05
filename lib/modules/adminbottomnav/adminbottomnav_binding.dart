import 'package:ecommerce_urban/modules/admin_analystics/admin_analystics_controller.dart';
import 'package:ecommerce_urban/modules/admin_orders/admin_orders_controller.dart';
import 'package:ecommerce_urban/modules/admin_products/admin_products_controller.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/admin_users_controller.dart';
import 'package:ecommerce_urban/modules/adminbottomnav/adminbottom_controller.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/admin_controller.dart';

import 'package:get/get.dart';

class AdminbottomnavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminbottomController>(() => AdminbottomController());
    Get.lazyPut<AdminController>(() => AdminController());
    Get.lazyPut<AdminProductsController>(() => AdminProductsController());

    Get.lazyPut<AdminAnalyticsController>(() => AdminAnalyticsController());
    Get.lazyPut<AdminOrdersController>(() => AdminOrdersController());
    Get.lazyPut<AdminUsersController>(() => AdminUsersController());

    //Get.lazyPut(()=> BottomNavController());
  }
}
