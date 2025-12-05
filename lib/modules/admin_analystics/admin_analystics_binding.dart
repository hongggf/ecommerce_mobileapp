import 'package:ecommerce_urban/modules/admin_analystics/admin_analystics_controller.dart';
import 'package:get/get.dart';


class AdminAnalysticsBinding  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AdminAnalyticsController>(() => AdminAnalyticsController());
  }
}