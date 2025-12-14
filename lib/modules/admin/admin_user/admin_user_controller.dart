import 'package:ecommerce_urban/api/model/user_model.dart';
import 'package:ecommerce_urban/api/service/user_service.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUserController extends GetxController {

  final UserService _userService = UserService();

  var users = <UserData>[].obs;
  var isLoading = false.obs;

  // Search, filter, sort
  var searchQuery = ''.obs;
  var filterRole = ''.obs;
  var sortBy = ''.obs;

  // Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  var role = "customer".obs;
  var editingUserId = Rx<int?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }

  /// Fetch users from API
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

  /// Set search/filter/sort
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

  /// Prepare form for creating or editing
  void prepareForm({UserData? user}) {
    if (user != null) {
      nameController.text = user.name ?? "";
      emailController.text = user.email ?? "";
      phoneController.text = user.phone ?? "";
      role.value = user.role ?? "customer";
      passwordController.clear();
      passwordConfirmController.clear();
      editingUserId.value = user.id;
    } else {
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      passwordConfirmController.clear();
      role.value = "customer";
      editingUserId.value = null;
    }
  }

  /// Create or update user
  Future<void> submitUserForm() async {
    if (editingUserId.value == null) {
      // Create
      await _createUser();
    } else {
      // Update
      await _updateUser();
    }
  }

  Future<void> _createUser() async {
    try {
      isLoading.value = true;
      await _userService.createUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmController.text,
        phone: phoneController.text,
        role: role.value,
      );
      ToastWidget.show(message: "User created successfully");
      await fetchUsers();
    } catch (e) {
      ToastWidget.show(type: "error", message: "Failed to create user!");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateUser() async {
    try {
      isLoading.value = true;
      await _userService.updateUser(
        id: editingUserId.value!,
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        role: role.value,
        password: passwordController.text.isNotEmpty ? passwordController.text : null,
        passwordConfirmation: passwordConfirmController.text.isNotEmpty
            ? passwordConfirmController.text
            : null,
      );
      ToastWidget.show(message: "User updated successfully");
      await fetchUsers();
    } catch (e) {
      ToastWidget.show(type: "error", message: "Failed to update user");
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete user
  Future<void> deleteUser(int id) async {
    // Show confirmation dialog first
    Get.defaultDialog(
      title: "Confirm Delete",
      middleText: "Are you sure you want to delete this user?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back(); // Close the dialog
        try {
          isLoading.value = true;
          await _userService.deleteUser(id);
          users.removeWhere((user) => user.id == id);
          ToastWidget.show(message: "User deleted successfully");
        } catch (e) {
          ToastWidget.show(type: "error", message: "Failed to delete user");
        } finally {
          isLoading.value = false;
        }
      },
    );
  }
}