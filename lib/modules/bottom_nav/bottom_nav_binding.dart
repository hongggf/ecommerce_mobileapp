import 'package:ecommerce_urban/modules/auth/auth_controller.dart';
import 'package:ecommerce_urban/modules/bottom_nav/bottom_controller.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/admin_controller.dart';
import 'package:ecommerce_urban/modules/dashboard/customer/customer_controller.dart';
import 'package:ecommerce_urban/modules/profile/profile_controller.dart';

import 'package:get/get.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
   // Get.lazyPut<AdminController>(() => AdminController());
    Get.lazyPut<CustomerController>(() => CustomerController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut(()=> BottomNavController());
    
  }
}
