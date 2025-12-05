import 'package:ecommerce_urban/app/services/auth_services.dart';
import 'package:ecommerce_urban/app/services/storage_services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final StorageService _storage = StorageService();
  final AuthService _authService = AuthService();

  var fullName = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var isLoggedIn = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    try {
      final token = await _storage.getToken();
      final userData = await _storage.getUserData();

      if (token != null && token.isNotEmpty && userData != null) {
        fullName.value = userData['full_name'] ?? '';
        email.value = userData['email'] ?? '';
        phone.value = userData['phone'] ?? '';
        isLoggedIn.value = true;
      }
    } catch (e) {
      isLoggedIn.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _authService.logout();
      fullName.value = '';
      email.value = '';
      phone.value = '';
      isLoggedIn.value = false;
    } catch (e) {
      Get.snackbar('Logout Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
