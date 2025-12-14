import 'package:ecommerce_urban/api/model/user_model.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:get/get.dart';
import '../service/user_service.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();

  var users = <UserData>[].obs;
  var isLoading = false.obs;

  /// Search, filter, sort
  var searchQuery = ''.obs;
  var filterRole = ''.obs;
  var sortBy = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// Fetch Users
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final userModel = await _userService.getUsers(
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        role: filterRole.value.isNotEmpty ? filterRole.value : null,
        sort: sortBy.value.isNotEmpty ? sortBy.value : null,
      );
      users.value = userModel.data ?? [];
    } catch (e) {
      ToastWidget.show(type: "error", message: "Failed to fetch users");
    } finally {
      isLoading.value = false;
    }
  }

  /// Create User
  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String role,
  }) async {
    try {
      isLoading.value = true;
      await _userService.createUser(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        role: role,
      );
      ToastWidget.show(message: "User created successfully");
      await fetchUsers();
    } catch (e) {
      ToastWidget.show(type: "error", message: "Failed to create user");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update User
  Future<void> updateUser({
    required int id,
    required String name,
    required String email,
    String? password,
    String? passwordConfirmation,
    required String phone,
    required String role,
  }) async {
    try {
      isLoading.value = true;
      await _userService.updateUser(
        id: id,
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        role: role,
      );
      ToastWidget.show(message: "User updated successfully");
      await fetchUsers();
    } catch (e) {
      ToastWidget.show(type: "error", message: "Failed to update user");
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete User
  Future<void> deleteUser(int id) async {
    try {
      isLoading.value = true;
      await _userService.deleteUser(id);
      ToastWidget.show(message: "User deleted successfully");
      users.removeWhere((user) => user.id == id);
    } catch (e) {
      ToastWidget.show(type: "error", message: "Failed to delete user");
    } finally {
      isLoading.value = false;
    }
  }

  void setSearch(String value) {
    searchQuery.value = value;
    fetchUsers();
  }

  void setFilterRole(String value) {
    filterRole.value = value;
    fetchUsers();
  }

  void setSort(String value) {
    sortBy.value = value;
    fetchUsers();
  }
}