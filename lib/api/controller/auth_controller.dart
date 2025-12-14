import 'package:ecommerce_urban/api/model/auth_model.dart';
import 'package:ecommerce_urban/api/service/auth_service.dart';
import 'package:ecommerce_urban/app/services/storage_services.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final RxBool isLoading = false.obs;
  final Rxn<User> currentUser = Rxn<User>();

  /// LOGIN
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final AuthModel authModel =
      await _authService.login(email: email, password: password);

      if (authModel.token == null || authModel.user == null) {
        throw Exception("Invalid login response");
      }

      // Save data
      StorageService.saveToken(authModel.token!);
      StorageService.saveRole(authModel.user!.role ?? 'customer');

      currentUser.value = authModel.user;

      ToastWidget.show(message: authModel.message ?? "Login success");

      // Navigate by role
      if (authModel.user!.role == 'admin') {
        Get.offAllNamed(AppRoutes.adminMain);
      } else {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      ToastWidget.show(
        type: "error",
        message: "Login failed",
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// REGISTER
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    String role = "customer",
  }) async {
    try {
      isLoading.value = true;

      await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
        phone: phone,
        role: role,
      );

      ToastWidget.show(message: "Register success");
      Get.toNamed(AppRoutes.login);
    } catch (e) {
      ToastWidget.show(
        type: "error",
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (_) {}

    StorageService.clearAll();
    currentUser.value = null;

    Get.offAllNamed(AppRoutes.login);
  }
}