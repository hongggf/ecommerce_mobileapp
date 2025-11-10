import 'package:ecommerce_urban/app/modules/bottom_nav/bottom_controller.dart';
import 'package:ecommerce_urban/app/modules/home/controller/category_controller.dart';
import 'package:ecommerce_urban/app/modules/home/controller/product_controller.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut(()=>BottomNavController());

     
  }
}
