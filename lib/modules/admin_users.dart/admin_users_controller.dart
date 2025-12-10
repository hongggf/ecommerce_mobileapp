import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/model/user_model.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/model/role_model.dart';

class AdminUsersController extends GetxController {
  // ================= USERS STATE =================
  var allUsers = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var isLoadingUsers = false.obs;
  var userStatusFilter = 'All'.obs;

  // Editing fields for bottom sheet
  var editingUserName = ''.obs;
  var editingUserEmail = ''.obs;
  var editingUserPhone = ''.obs;
  var editingUserStatus = 'Active'.obs;

  // ================= ROLES STATE =================
  var allRoles = <RoleModel>[].obs;
  var isLoadingRoles = false.obs;

  // Editing fields for role
  var editingRoleName = ''.obs;
  var editingRoleDesc = ''.obs;

  // ================= USER STATS =================
  int get activeUsers =>
      allUsers.where((u) => u.status.toLowerCase() == 'active').length;

  int get inactiveUsers =>
      allUsers.where((u) => u.status.toLowerCase() == 'inactive').length;

  int get pendingUsers =>
      allUsers.where((u) => u.status.toLowerCase() == 'pending').length;

  // ==================== USER METHODS ====================
  void loadUsers() async {
    isLoadingUsers.value = true;
    try {
      // TODO: Replace with API call
      await Future.delayed(const Duration(seconds: 1));
      // Example mock data
      allUsers.value = [
        UserModel(
          id: '1',
          name: 'John Doe',
          email: 'john@example.com',
          status: 'active',
          createdAt: DateTime.now(),
          roles: ['Admin'],
        ),
        UserModel(
          id: '2',
          name: 'Jane Smith',
          email: 'jane@example.com',
          status: 'inactive',
          createdAt: DateTime.now(),
          roles: ['Manager'],
        ),
      ];
      filteredUsers.value = allUsers;
    } finally {
      isLoadingUsers.value = false;
    }
  }

  void searchUsers(String keyword) {
    if (keyword.isEmpty) {
      filteredUsers.value = allUsers;
    } else {
      filteredUsers.value = allUsers
          .where((u) =>
              u.name.toLowerCase().contains(keyword.toLowerCase()) ||
              u.email.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
  }

  void filterUsersByStatus(String status) {
    userStatusFilter.value = status;
    if (status == 'All') {
      filteredUsers.value = allUsers;
    } else {
      filteredUsers.value =
          allUsers.where((u) => u.status.toLowerCase() == status.toLowerCase()).toList();
    }
  }

  void createUser(Map<String, dynamic> data) async {
    isLoadingUsers.value = true;
    try {
      // TODO: Replace with API call to create user
      await Future.delayed(const Duration(seconds: 1));
      allUsers.add(UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: data['full_name'],
        email: data['email'],
        phone: data['phone'],
        status: data['status'],
        createdAt: DateTime.now(),
        roles: [],
      ));
      filteredUsers.value = allUsers;
      Get.snackbar('Success', 'User created successfully',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingUsers.value = false;
    }
  }

  void updateUser(String userId, Map<String, dynamic> data) async {
    isLoadingUsers.value = true;
    try {
      // TODO: Replace with API call
      await Future.delayed(const Duration(milliseconds: 500));
      final index = allUsers.indexWhere((u) => u.id == userId);
      if (index != -1) {
        final old = allUsers[index];
        allUsers[index] = UserModel(
          id: old.id,
          name: data['name'] ?? old.name,
          email: data['email'] ?? old.email,
          phone: data['phone'] ?? old.phone,
          status: data['status'] ?? old.status,
          createdAt: old.createdAt,
          updatedAt: DateTime.now(),
          roles: old.roles,
        );
      }
      filteredUsers.value = allUsers;
      Get.snackbar('Success', 'User updated successfully',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingUsers.value = false;
    }
  }

  void updateUserStatus(String userId, String status) {
    final index = allUsers.indexWhere((u) => u.id == userId);
    if (index != -1) {
      final old = allUsers[index];
      allUsers[index] = UserModel(
        id: old.id,
        name: old.name,
        email: old.email,
        phone: old.phone,
        status: status,
        createdAt: old.createdAt,
        updatedAt: DateTime.now(),
        roles: old.roles,
      );
      filteredUsers.value = allUsers;
    }
  }

  void deleteUser(String userId) {
    allUsers.removeWhere((u) => u.id == userId);
    filteredUsers.value = allUsers;
    Get.snackbar('Deleted', 'User deleted', snackPosition: SnackPosition.BOTTOM);
  }

  // ==================== ROLE METHODS ====================
  void loadRoles() async {
    isLoadingRoles.value = true;
    try {
      // TODO: Replace with API call
      await Future.delayed(const Duration(seconds: 1));
      allRoles.value = [
        RoleModel(
          id: '1',
          name: 'Admin',
          description: 'Administrator with full access',
          createdAt: DateTime.now(),
        ),
        RoleModel(
          id: '2',
          name: 'Manager',
          description: 'Manager with limited access',
          createdAt: DateTime.now(),
        ),
      ];
    } finally {
      isLoadingRoles.value = false;
    }
  }

  void updateRole(String roleId, Map<String, dynamic> data) async {
    isLoadingRoles.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = allRoles.indexWhere((r) => r.id == roleId);
      if (index != -1) {
        final old = allRoles[index];
        allRoles[index] = RoleModel(
          id: old.id,
          name: data['name'] ?? old.name,
          description: data['description'] ?? old.description,
          createdAt: old.createdAt,
          updatedAt: DateTime.now(),
        );
      }
    } finally {
      isLoadingRoles.value = false;
    }
  }

  void deleteRole(String roleId) {
    allRoles.removeWhere((r) => r.id == roleId);
    Get.snackbar('Deleted', 'Role deleted', snackPosition: SnackPosition.BOTTOM);
  }

  void assignRoleToUser(String userId, String roleId) {
    final userIndex = allUsers.indexWhere((u) => u.id == userId);
    final role = allRoles.firstWhere((r) => r.id == roleId, orElse: () => RoleModel(id: '', name: '', createdAt: DateTime.now()));
    if (userIndex != -1 && role.id.isNotEmpty) {
      final oldUser = allUsers[userIndex];
      final updatedRoles = [...?oldUser.roles];
      if (!updatedRoles.contains(role.name)) {
        updatedRoles.add(role.name);
        allUsers[userIndex] = UserModel(
          id: oldUser.id,
          name: oldUser.name,
          email: oldUser.email,
          phone: oldUser.phone,
          status: oldUser.status,
          createdAt: oldUser.createdAt,
          updatedAt: DateTime.now(),
          roles: updatedRoles,
        );
      }
      filteredUsers.value = allUsers;
    }
  }/// Public method for widgets to remove role directly by name
  void removeRoleFromUserDirect(UserModel user, String roleName) {
    final role = allRoles.firstWhere(
      (r) => r.name == roleName,
      orElse: () => RoleModel(
        id: '',
        name: roleName,
        description: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    if (role.id.isEmpty) {
      Get.snackbar('Error', 'Role not found',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFFFF0000));
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Remove Role'),
        content: Text('Remove "$roleName" from ${user.name}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              removeRoleFromUser(user.id, role.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void removeRoleFromUser(String userId, String roleId) {
    final userIndex = allUsers.indexWhere((u) => u.id == userId);
    final role = allRoles.firstWhere((r) => r.id == roleId, orElse: () => RoleModel(id: '', name: '', createdAt: DateTime.now()));
    if (userIndex != -1 && role.id.isNotEmpty) {
      final oldUser = allUsers[userIndex];
      final updatedRoles = [...?oldUser.roles];
      updatedRoles.remove(role.name);
      allUsers[userIndex] = UserModel(
        id: oldUser.id,
        name: oldUser.name,
        email: oldUser.email,
        phone: oldUser.phone,
        status: oldUser.status,
        createdAt: oldUser.createdAt,
        updatedAt: DateTime.now(),
        roles: updatedRoles,
      );
      filteredUsers.value = allUsers;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadUsers();
    loadRoles();
  }
}
