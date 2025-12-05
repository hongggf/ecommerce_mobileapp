import 'package:ecommerce_urban/app/services/storage_services.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final StorageService _storage = StorageService();
  var name = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    name.value = (await _storage.getUserData() as String?) ?? '';
  }

  Future<void> logout() async {
    await _storage.clear(); // clear all stored data (username, etc.)
    Get.offAllNamed('/login');
  }
}
