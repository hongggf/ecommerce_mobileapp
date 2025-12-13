// ============================================
// admin_users_controller.dart
// ============================================
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
  Future<void> loadUsers() async {
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
        UserModel(
          id: '3',
          name: 'Bob Wilson',
          email: 'bob@example.com',
          status: 'active',
          createdAt: DateTime.now(),
          roles: [],
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
      filteredUsers.value = allUsers
          .where((u) => u.status.toLowerCase() == status.toLowerCase())
          .toList();
    }
  }

  Future<void> createUser(Map<String, dynamic> data) async {
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
      Get.snackbar(
        'Success',
        'User created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create user: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
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
      Get.snackbar(
        'Success',
        'User updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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
      Get.snackbar(
        'Success',
        'User status updated',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void deleteUser(String userId) {
    allUsers.removeWhere((u) => u.id == userId);
    filteredUsers.value = allUsers;
    Get.snackbar(
      'Deleted',
      'User deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  // ==================== ROLE METHODS ====================
  Future<void> loadRoles() async {
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
        RoleModel(
          id: '3',
          name: 'Editor',
          description: 'Content editor role',
          createdAt: DateTime.now(),
        ),
      ];
    } finally {
      isLoadingRoles.value = false;
    }
  }

  Future<void> updateRole(String roleId, Map<String, dynamic> data) async {
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
        Get.snackbar(
          'Success',
          'Role updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoadingRoles.value = false;
    }
  }

  void deleteRole(String roleId) {
    allRoles.removeWhere((r) => r.id == roleId);
    Get.snackbar(
      'Deleted',
      'Role deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void assignRoleToUser(String userId, String roleId) {
    final userIndex = allUsers.indexWhere((u) => u.id == userId);
    final role = allRoles.firstWhere(
      (r) => r.id == roleId,
      orElse: () => RoleModel(id: '', name: '', createdAt: DateTime.now()),
    );
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
        Get.snackbar(
          'Success',
          'Role "${role.name}" assigned to ${oldUser.name}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
      filteredUsers.value = allUsers;
    }
  }

  /// Public method for widgets to remove role directly by name
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
      Get.snackbar(
        'Error',
        'Role not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Remove Role'),
        content: Text('Remove "$roleName" from ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              removeRoleFromUser(user.id, role.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void removeRoleFromUser(String userId, String roleId) {
    final userIndex = allUsers.indexWhere((u) => u.id == userId);
    final role = allRoles.firstWhere(
      (r) => r.id == roleId,
      orElse: () => RoleModel(id: '', name: '', createdAt: DateTime.now()),
    );
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
      Get.snackbar(
        'Success',
        'Role removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  // ==================== UI ACTION HANDLERS ====================
  
  /// Handle user card popup menu actions
  void handleUserAction(String action, UserModel user) {
    switch (action) {
      case 'edit':
        showEditUserDialog(user);
        break;
      case 'status':
        showChangeStatusDialog(user);
        break;
      case 'delete':
        showDeleteUserDialog(user);
        break;
    }
  }

  /// Handle role card popup menu actions
  void handleRoleAction(String action, RoleModel role) {
    switch (action) {
      case 'edit':
        showEditRoleDialog(role);
        break;
      case 'delete':
        showDeleteRoleDialog(role);
        break;
    }
  }

  // ==================== DIALOG METHODS ====================

  /// Show dialog to edit user
  void showEditUserDialog(UserModel user) {
    editingUserName.value = user.name;
    editingUserEmail.value = user.email;
    editingUserPhone.value = user.phone ?? '';
    editingUserStatus.value = user.status;

    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone ?? '');

    Get.dialog(
      AlertDialog(
        title: const Text('Edit User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => editingUserName.value = value,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => editingUserEmail.value = value,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => editingUserPhone.value = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              updateUser(user.id, {
                'name': nameController.text,
                'email': emailController.text,
                'phone': phoneController.text,
              });
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Show dialog to change user status
  void showChangeStatusDialog(UserModel user) {
    String selectedStatus = user.status;

    Get.dialog(
      AlertDialog(
        title: const Text('Change Status'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('Active'),
                  value: 'active',
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() => selectedStatus = value!);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Inactive'),
                  value: 'inactive',
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() => selectedStatus = value!);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Pending'),
                  value: 'pending',
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() => selectedStatus = value!);
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              updateUserStatus(user.id, selectedStatus);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Show dialog to delete user
  void showDeleteUserDialog(UserModel user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              deleteUser(user.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Show dialog to edit role
  void showEditRoleDialog(RoleModel role) {
    editingRoleName.value = role.name;
    editingRoleDesc.value = role.description ?? '';

    final nameController = TextEditingController(text: role.name);
    final descController = TextEditingController(text: role.description ?? '');

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Role Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => editingRoleName.value = value,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => editingRoleDesc.value = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              updateRole(role.id, {
                'name': nameController.text,
                'description': descController.text,
              });
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Show dialog to delete role
  void showDeleteRoleDialog(RoleModel role) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Role'),
        content: Text('Are you sure you want to delete "${role.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              deleteRole(role.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Show dialog to assign role to user
  void showAssignRoleDialog(UserModel user) {
    String? selectedRoleId;

    Get.dialog(
      AlertDialog(
        title: Text('Assign Role to ${user.name}'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedRoleId,
                  decoration: const InputDecoration(
                    labelText: 'Select Role',
                    border: OutlineInputBorder(),
                  ),
                  items: allRoles.map((role) {
                    return DropdownMenuItem(
                      value: role.id,
                      child: Text(role.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedRoleId = value);
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedRoleId != null) {
                assignRoleToUser(user.id, selectedRoleId!);
                Get.back();
              } else {
                Get.snackbar(
                  'Error',
                  'Please select a role',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Assign', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadUsers();
    loadRoles();
  }
}

// ============================================
// WIDGET FILES REMAIN THE SAME AS BEFORE
// ============================================
// (All the widget files from the previous artifact remain unchanged)