import 'package:ecommerce_urban/app/modules/profile/profile_controller.dart';
import 'package:get/get.dart';


class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
