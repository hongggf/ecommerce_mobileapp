import 'package:ecommerce_urban/modules/admin_users.dart/model/role_model.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/model/user_model.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/services/user_and_role_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUsersController extends GetxController {
  final UserService _userService = UserService();
  
  // Expose service for use in UI
  UserService get userService => _userService;

  // User state
  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxList<UserModel> filteredUsers = <UserModel>[].obs;
  final RxBool isLoadingUsers = false.obs;
  final RxString userSearchQuery = ''.obs;
  final RxString userStatusFilter = 'All'.obs;

  // Role state
  final RxList<RoleModel> allRoles = <RoleModel>[].obs;
  final RxBool isLoadingRoles = false.obs;

  // User detail state
  final Rx<UserModel?> selectedUser = Rx<UserModel?>(null);
  final RxList<RoleModel> userRoles = <RoleModel>[].obs;
  final RxList<RoleModel> availableRoles = <RoleModel>[].obs;
  final RxBool isLoadingUserRoles = false.obs;

  // Form state
  final RxString editingUserName = ''.obs;
  final RxString editingUserEmail = ''.obs;
  final RxString editingUserPhone = ''.obs;
  final RxString editingUserStatus = 'Active'.obs;

  final RxString editingRoleName = ''.obs;
  final RxString editingRoleDesc = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
    loadRoles();
  }

  // ==================== USER MANAGEMENT ====================

  Future<void> loadUsers() async {
    try {
      isLoadingUsers.value = true;
      final users = await _userService.fetchUsers();
      allUsers.assignAll(users);
      applyUserFilters();
      print('✅ Users loaded successfully');
    } catch (e) {
      print('❌ Error loading users: $e');
      Get.snackbar('Error', 'Failed to load users: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      isLoadingUsers.value = true;
      final newUser = await _userService.createUser(userData);
      if (newUser != null) {
        allUsers.insert(0, newUser);
        applyUserFilters();
        Get.snackbar('Success', 'User created successfully',
            snackPosition: SnackPosition.BOTTOM);
        print('✅ User created');
      }
    } catch (e) {
      print('❌ Error creating user: $e');
      Get.snackbar('Error', 'Failed to create user: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      isLoadingUsers.value = true;
      final success = await _userService.updateUser(userId, userData);
      if (success) {
        // Update local user in list
        final index = allUsers.indexWhere((u) => u.id == userId);
        if (index != -1) {
          final updatedUser = UserModel(
            id: allUsers[index].id,
            name: userData['name'] ?? userData['name'] ?? allUsers[index].name,
            email: userData['email'] ?? allUsers[index].email,
            phone: userData['phone'] ?? allUsers[index].phone,
            avatar: allUsers[index].avatar,
            status: userData['status'] ?? allUsers[index].status,
            createdAt: allUsers[index].createdAt,
            updatedAt: DateTime.now(),
            roles: allUsers[index].roles,
          );
          allUsers[index] = updatedUser;
          allUsers.refresh();
          applyUserFilters();
        }
        Get.snackbar('Success', 'User updated successfully',
            snackPosition: SnackPosition.BOTTOM);
        print('✅ User updated');
      }
    } catch (e) {
      print('❌ Error updating user: $e');
      Get.snackbar('Error', 'Failed to update user: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> updateUserStatus(String userId, String newStatus) async {
    try {
      isLoadingUsers.value = true;
      final success =
          await _userService.updateUser(userId, {'status': newStatus.toLowerCase()});
      if (success) {
        final index = allUsers.indexWhere((u) => u.id == userId);
        if (index != -1) {
          final updatedUser = UserModel(
            id: allUsers[index].id,
            name: allUsers[index].name,
            email: allUsers[index].email,
            phone: allUsers[index].phone,
            avatar: allUsers[index].avatar,
            status: newStatus.toLowerCase(),
            createdAt: allUsers[index].createdAt,
            updatedAt: DateTime.now(),
            roles: allUsers[index].roles,
          );
          allUsers[index] = updatedUser;
          allUsers.refresh();
          applyUserFilters();
        }
        Get.snackbar('Success', 'User status updated to $newStatus',
            snackPosition: SnackPosition.BOTTOM);
        print('✅ User status updated');
      }
    } catch (e) {
      print('❌ Error updating status: $e');
      Get.snackbar('Error', 'Failed to update status: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      isLoadingUsers.value = true;
      final success = await _userService.deleteUser(userId);
      if (success) {
        allUsers.removeWhere((u) => u.id == userId);
        applyUserFilters();
        Get.snackbar('Success', 'User deleted successfully',
            snackPosition: SnackPosition.BOTTOM);
        print('✅ User deleted');
      }
    } catch (e) {
      print('❌ Error deleting user: $e');
      Get.snackbar('Error', 'Failed to delete user: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingUsers.value = false;
    }
  }

  void searchUsers(String query) {
    userSearchQuery.value = query.toLowerCase();
    applyUserFilters();
  }

  void filterUsersByStatus(String status) {
    userStatusFilter.value = status;
    applyUserFilters();
  }

  void applyUserFilters() {
    var filtered = allUsers.toList();

    if (userStatusFilter.value != 'All') {
      final filterStatus = userStatusFilter.value.toLowerCase();
      filtered = filtered
          .where((u) => u.status.toLowerCase() == filterStatus)
          .toList();
    }

    if (userSearchQuery.value.isNotEmpty) {
      filtered = filtered.where((u) {
        return u.name.toLowerCase().contains(userSearchQuery.value) ||
            u.email.toLowerCase().contains(userSearchQuery.value);
      }).toList();
    }

    filteredUsers.assignAll(filtered);
  }

  int get totalUsers => allUsers.length;
  int get activeUsers => allUsers.where((u) => u.status.toLowerCase() == 'active').length;
  int get inactiveUsers => allUsers.where((u) => u.status.toLowerCase() == 'inactive').length;
  int get pendingUsers => allUsers.where((u) => u.status.toLowerCase() == 'pending' || u.status.toLowerCase() == 'pending').length;

  // ==================== ROLE MANAGEMENT ====================

  Future<void> loadRoles() async {
    try {
      isLoadingRoles.value = true;
      final roles = await _userService.fetchRoles();
      allRoles.assignAll(roles);
      availableRoles.assignAll(roles);
      print('✅ Roles loaded successfully');
    } catch (e) {
      print('❌ Error loading roles: $e');
      Get.snackbar('Error', 'Failed to load roles: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingRoles.value = false;
    }
  }

  Future<void> createRole(Map<String, dynamic> roleData) async {
    try {
      isLoadingRoles.value = true;
      final newRole = await _userService.createRole(roleData);
      if (newRole != null) {
        allRoles.insert(0, newRole);
        availableRoles.insert(0, newRole);
        Get.snackbar('Success', 'Role created successfully',
            snackPosition: SnackPosition.BOTTOM);
        print('✅ Role created');
      }
    } catch (e) {
      print('❌ Error creating role: $e');
      Get.snackbar('Error', 'Failed to create role: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingRoles.value = false;
    }
  }

  Future<void> updateRole(String roleId, Map<String, dynamic> roleData) async {
    try {
      isLoadingRoles.value = true;
      final success = await _userService.updateRole(roleId, roleData);
      if (success) {
        final index = allRoles.indexWhere((r) => r.id == roleId);
        if (index != -1) {
          final updatedRole = RoleModel(
            id: allRoles[index].id,
            name: roleData['name'] ?? allRoles[index].name,
            description: roleData['description'] ?? allRoles[index].description,
            createdAt: allRoles[index].createdAt,
            updatedAt: DateTime.now(),
          );
          allRoles[index] = updatedRole;
          allRoles.refresh();
          availableRoles.refresh();
        }
        Get.snackbar('Success', 'Role updated successfully',
            snackPosition: SnackPosition.BOTTOM);
        print('✅ Role updated');
      }
    } catch (e) {
      print('❌ Error updating role: $e');
      Get.snackbar('Error', 'Failed to update role: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingRoles.value = false;
    }
  }

  Future<void> deleteRole(String roleId) async {
    try {
      isLoadingRoles.value = true;
      final success = await _userService.deleteRole(roleId);
      if (success) {
        allRoles.removeWhere((r) => r.id == roleId);
        availableRoles.removeWhere((r) => r.id == roleId);
        Get.snackbar('Success', 'Role deleted successfully',
            snackPosition: SnackPosition.BOTTOM);
        print('✅ Role deleted');
      }
    } catch (e) {
      print('❌ Error deleting role: $e');
      Get.snackbar('Error', 'Failed to delete role: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingRoles.value = false;
    }
  }

  // ==================== USER ROLE MANAGEMENT ====================

  Future<void> loadUserRoles(String userId) async {
    try {
      isLoadingUserRoles.value = true;
      final roles = await _userService.listUserRoles(userId);
      userRoles.assignAll(roles);
      print('✅ User roles loaded');
    } catch (e) {
      print('❌ Error loading user roles: $e');
    } finally {
      isLoadingUserRoles.value = false;
    }
  }

  Future<void> assignRoleToUser(String userId, String roleId) async {
    try {
      isLoadingUserRoles.value = true;
      final success = await _userService.assignRole(userId, roleId);
      if (success) {
        // Reload user data to get updated roles
        final updatedUser = await _userService.fetchUserById(userId);
        if (updatedUser != null) {
          final index = allUsers.indexWhere((u) => u.id == userId);
          if (index != -1) {
            allUsers[index] = updatedUser;
            allUsers.refresh();
            applyUserFilters();
            print('✅ User roles updated: ${updatedUser.roles}');
          }
        }
        Get.snackbar(
          'Success',
          'Role assigned successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        );
        print('✅ Role assigned');
      }
    } catch (e) {
      print('❌ Error assigning role: $e');
      Get.snackbar(
        'Error',
        'Failed to assign role: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoadingUserRoles.value = false;
    }
  }

  Future<void> removeRoleFromUser(String userId, String roleId) async {
    try {
      isLoadingUserRoles.value = true;
      final success = await _userService.removeRole(userId, roleId);
      if (success) {
        // Reload user data to get updated roles
        final updatedUser = await _userService.fetchUserById(userId);
        if (updatedUser != null) {
          final index = allUsers.indexWhere((u) => u.id == userId);
          if (index != -1) {
            allUsers[index] = updatedUser;
            allUsers.refresh();
            applyUserFilters();
            print('✅ User roles updated: ${updatedUser.roles}');
          }
        }
        Get.snackbar(
          'Success',
          'Role removed successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        );
        print('✅ Role removed');
      }
    } catch (e) {
      print('❌ Error removing role: $e');
      Get.snackbar(
        'Error',
        'Failed to remove role: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoadingUserRoles.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}