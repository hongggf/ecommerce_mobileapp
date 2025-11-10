import 'package:ecommerce_urban/services/storage_services.dart';
import 'package:get/get.dart';


class AuthController extends GetxController {
  final StorageService _storage = StorageService();
  var username = ''.obs;

  Future<bool> isLoggedIn() async {
    final savedName = await _storage.getUsername();
    if (savedName != null && savedName.isNotEmpty) {
      username.value = savedName;
      return true;
    }
    return false;
  }

  Future<void> login(String name) async {
    await _storage.saveUsername(name);
    username.value = name;
  }

  Future<void> logout() async {
    await _storage.clear();
    username.value = '';
  }
}
