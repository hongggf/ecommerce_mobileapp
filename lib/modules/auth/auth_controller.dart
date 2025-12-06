// import 'package:ecommerce_urban/app/services/auth_services.dart';
import 'package:ecommerce_urban/app/services/auth_services.dart';
import 'package:ecommerce_urban/app/services/storage_services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final StorageService _storage = StorageService();
  final AuthService _authService = AuthService();

  var fullName = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var role = ''.obs; // 🔥 ADD ROLE
  var isLoggedIn = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // ==============================================================
  // 🔥 CHECK LOGIN STATUS WHEN APP STARTS
  // ==============================================================
  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    try {
      final token = await _storage.getToken();
      final userData = await _storage.getUserData();

      if (token != null && token.isNotEmpty && userData != null) {
        fullName.value = userData['full_name'] ?? '';
        email.value = userData['email'] ?? '';
        phone.value = userData['phone'] ?? '';
        role.value = userData['role'] ?? ''; // 🔥 LOAD ROLE

        isLoggedIn.value = true;
      } else {
        isLoggedIn.value = false;
      }
    } catch (e) {
      isLoggedIn.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // ==============================================================
  // 🔥 SAVE LOGIN DATA AFTER USER LOGINS
  // ==============================================================
  Future<bool> saveLoginData(Map<String, dynamic> data) async {
    try {
      // Extract fields from API response
      final token = data["token"];
      final user = data["user"];

      if (token == null || user == null) return false;

      await _storage.saveToken(token);

      await _storage.saveUserData({
        "full_name": user["full_name"],
        "email": user["email"],
        "phone": user["phone"],
        "role": user["role"], // 🔥 save user role
      });

      // Update controller values
      fullName.value = user["full_name"];
      email.value = user["email"];
      phone.value = user["phone"];
      role.value = user["role"];
      isLoggedIn.value = true;

      return true;
    } catch (e) {
      return false;
    }
  }

  // ==============================================================
  // 🔥 GET USER ROLE (used in SplashController)
  // ==============================================================
  Future<String?> getUserRole() async {
    try {
      final userData = await _storage.getUserData();
      return userData?["role"];
    } catch (e) {
      return null;
    }
  }

  // ==============================================================
  // 🔥 LOGOUT
  // ==============================================================
  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _authService.logout(); // backend logout (optional)
      await _storage.clearAll(); // 🔥 clear token + userData

      fullName.value = '';
      email.value = '';
      phone.value = '';
      role.value = '';
      isLoggedIn.value = false;
    } catch (e) {
      Get.snackbar('Logout Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
