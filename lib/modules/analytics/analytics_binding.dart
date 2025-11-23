import 'package:ecommerce_urban/modules/analytics/analytics_controller.dart';
import 'package:get/get.dart';

class AnalyticsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AnalyticsController>(() => AnalyticsController());
  }
}