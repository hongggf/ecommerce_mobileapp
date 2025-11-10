import 'package:ecommerce_urban/app/modules/auth/controller/auth_controller.dart';
import 'package:ecommerce_urban/app/modules/bottom_nav/bottom_controller.dart';
import 'package:ecommerce_urban/app/modules/home/controller/category_controller.dart';
import 'package:ecommerce_urban/app/modules/home/controller/product_controller.dart';
import 'package:ecommerce_urban/app/modules/home/home_controller.dart';
import 'package:ecommerce_urban/app/modules/profile/profile_controller.dart';

import 'package:get/get.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut<HomeController>(() => HomeController());
     Get.lazyPut<ProfileController>(() => ProfileController());
      Get.lazyPut<AuthController>(() => AuthController());
     Get.lazyPut<CategoryController>(() => CategoryController());
     Get.lazyPut<ProductController>(() => ProductController());
    
    Get.lazyPut(()=> BottomNavController());
    
  }
}
