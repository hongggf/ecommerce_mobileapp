import 'package:get/get.dart';

class AdminController extends GetxController {
  var isLoadingStats = false.obs;
  var totalOrders = 0.obs;
  var totalProducts = 0.obs;
  var totalUsers = 0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshStats();
  }

  void refreshStats() async {
    isLoadingStats.value = true;
    await Future.delayed(Duration(milliseconds: 800));
    
    totalOrders.value = 245;
    totalProducts.value = 87;
    totalUsers.value = 523;
    
    isLoadingStats.value = false;
  }
}