import 'package:ecommerce_urban/modules/admin_users.dart/admin_users_controller.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/create_new_user_screen.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/model/role_model.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUsersView extends GetView<AdminUsersController> {
  const AdminUsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Management'),
          backgroundColor: Colors.purple,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => Get.to(() => const CreateUserScreen()),
              tooltip: 'Create New User',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Roles'),
              Tab(text: 'Assignment'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: TabBarView(
          children: [
            _buildUsersTab(),
            _buildRolesTab(),
            _buildAssignmentTab(),
          ],
        ),
      ),
    );
  }

  // ==================== USERS TAB ====================
  Widget _buildUsersTab() {
    return Column(
      children: [
        _buildUserStatsSection(),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingUsers.value &&
                controller.filteredUsers.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: controller.loadUsers,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildUserSearchAndFilter()),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final user = controller.filteredUsers[index];
                          return _buildUserCard(user);
                        },
                        childCount: controller.filteredUsers.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildUserStatsSection() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatCard('Total', '${controller.allUsers.length}',
                Icons.people, Colors.white),
            _buildStatCard('Active', '${controller.activeUsers}',
                Icons.check_circle, Colors.green),
            _buildStatCard('Inactive', '${controller.inactiveUsers}',
                Icons.cancel, Colors.red),
            _buildStatCard('Pending', '${controller.pendingUsers}',
                Icons.pending, Colors.orange),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildUserSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            onChanged: controller.searchUsers,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search, color: Colors.purple),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Active', 'Inactive', 'Pending']
                    .map((status) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(status),
                            selected:
                                controller.userStatusFilter.value == status,
                            onSelected: (_) =>
                                controller.filterUsersByStatus(status),
                            backgroundColor: Colors.white,
                            selectedColor: Colors.purple,
                            labelStyle: TextStyle(
                              color: controller.userStatusFilter.value == status
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.purple,
                  child: Text(
                    user.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : '.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleUserAction(value, user),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18, color: Colors.blue),
                          SizedBox(width: 12),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'status',
                      child: Row(
                        children: [
                          Icon(Icons.toggle_on, size: 18, color: Colors.orange),
                          SizedBox(width: 12),
                          Text('Change Status'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 12),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatusBadge(user.status),
                const SizedBox(width: 8),
                if (user.roles != null && user.roles!.isNotEmpty)
                  _buildBadge(user.roles!.join(', '), Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    final displayStatus = status.toLowerCase() == 'active' ? 'Active' :
                         status.toLowerCase() == 'inactive' ? 'Inactive' : 'Pending';
    
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'inactive':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        displayStatus,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  void _handleUserAction(String action, UserModel user) {
    switch (action) {
      case 'edit':
        _showEditUserBottomSheet(user);
        break;
      case 'status':
        _showStatusDialog(user);
        break;
      case 'delete':
        _showDeleteUserDialog(user);
        break;
    }
  }

  void _showEditUserBottomSheet(UserModel user) {
    controller.editingUserName.value = user.name;
    controller.editingUserEmail.value = user.email;
    controller.editingUserPhone.value = user.phone ?? '';
    controller.editingUserStatus.value = user.status.toLowerCase() == 'active' ? 'Active' : 'Inactive';

    final nameController = TextEditingController(text: controller.editingUserName.value);
    final emailController = TextEditingController(text: controller.editingUserEmail.value);
    final phoneController = TextEditingController(text: controller.editingUserPhone.value);

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const Text(
                  'Edit User',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Name Field
                TextField(
                  controller: nameController,
                  onChanged: (val) => controller.editingUserName.value = val,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Email Field
                TextField(
                  controller: emailController,
                  onChanged: (val) => controller.editingUserEmail.value = val,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Phone Field
                TextField(
                  controller: phoneController,
                  onChanged: (val) => controller.editingUserPhone.value = val,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Status Dropdown
                Obx(() {
                  return DropdownButtonFormField<String>(
                    value: controller.editingUserStatus.value,
                    decoration: InputDecoration(
                      labelText: 'Status',
                      prefixIcon: const Icon(Icons.check_circle),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['Active', 'Inactive']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.editingUserStatus.value = val;
                      }
                    },
                  );
                }),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed: controller.isLoadingUsers.value
                          ? null
                          : () {
                              controller.updateUser(user.id, {
                                'name': nameController.text,
                                'email': emailController.text,
                                'phone': phoneController.text,
                                'status': controller.editingUserStatus.value.toLowerCase(),
                              });
                              Future.delayed(const Duration(milliseconds: 500), () {
                                nameController.dispose();
                                emailController.dispose();
                                phoneController.dispose();
                                Get.back();
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoadingUsers.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showStatusDialog(UserModel user) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Active', 'Inactive']
              .map((status) => RadioListTile<String>(
                    title: Text(status),
                    value: status.toLowerCase(),
                    groupValue: user.status.toLowerCase(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateUserStatus(user.id, value);
                        Get.back();
                      }
                    },
                    activeColor: Colors.purple,
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showDeleteUserDialog(UserModel user) {
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
              controller.deleteUser(user.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ==================== ROLES TAB ====================
  Widget _buildRolesTab() {
    return Obx(() {
      if (controller.isLoadingRoles.value && controller.allRoles.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: controller.loadRoles,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.allRoles.length,
          itemBuilder: (context, index) {
            final role = controller.allRoles[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.security, color: Colors.purple, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (role.description != null)
                            Text(
                              role.description!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) =>
                          _handleRoleAction(value, role),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18, color: Colors.orange),
                              SizedBox(width: 12),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 12),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void _handleRoleAction(String action, RoleModel role) {
    switch (action) {
      case 'edit':
        _showEditRoleBottomSheet(role);
        break;
      case 'delete':
        _showDeleteRoleDialog(role);
        break;
    }
  }

  void _showEditRoleBottomSheet(RoleModel role) {
    controller.editingRoleName.value = role.name;
    controller.editingRoleDesc.value = role.description ?? '';

    final nameController = TextEditingController(text: controller.editingRoleName.value);
    final descController = TextEditingController(text: controller.editingRoleDesc.value);

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const Text(
                  'Edit Role',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Name Field
                TextField(
                  controller: nameController,
                  onChanged: (val) => controller.editingRoleName.value = val,
                  decoration: InputDecoration(
                    labelText: 'Role Name',
                    prefixIcon: const Icon(Icons.security),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description Field
                TextField(
                  controller: descController,
                  onChanged: (val) => controller.editingRoleDesc.value = val,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed: controller.isLoadingRoles.value
                          ? null
                          : () {
                              controller.updateRole(role.id, {
                                'name': nameController.text,
                                'description': descController.text,
                              });
                              Future.delayed(const Duration(milliseconds: 500), () {
                                nameController.dispose();
                                descController.dispose();
                                Get.back();
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoadingRoles.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showDeleteRoleDialog(RoleModel role) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Role'),
        content: Text('Are you sure you want to delete ${role.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteRole(role.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ==================== ASSIGNMENT TAB ====================
  Widget _buildAssignmentTab() {
    return Obx(() {
      if (controller.allUsers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text('No users available'),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.allUsers.length,
        itemBuilder: (context, index) {
          final user = controller.allUsers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.purple,
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user.email,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Current Roles:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (user.roles != null && user.roles!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: user.roles!
                          .map((role) => _buildBadge(role, Colors.blue))
                          .toList(),
                    )
                  else
                    Text(
                      'No roles assigned',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAssignRoleDialog(user),
                      icon: const Icon(Icons.add),
                      label: const Text('Assign Role'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _showAssignRoleDialog(UserModel user) {
    // Create a reactive copy of the user
    final Rx<UserModel> reactiveUser = user.obs;
    
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Obx(() {
          final currentUser = reactiveUser.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Manage Roles - ${currentUser.name}'),
              const SizedBox(height: 8),
              if (currentUser.roles != null && currentUser.roles!.isNotEmpty)
                Text(
                  'Current Roles: ${currentUser.roles!.join(", ")}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                  ),
                )
              else
                Text(
                  'No roles assigned yet',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          );
        }),
        content: Obx(() {
          final currentUser = reactiveUser.value;
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: controller.allRoles
                  .map((role) {
                    // Check if role is already assigned
                    final isAssigned = currentUser.roles?.contains(role.name) ?? false;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isAssigned
                              ? Colors.purple.withOpacity(0.5)
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          role.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isAssigned ? Colors.purple : Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (role.description != null)
                              Text(
                                role.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            if (isAssigned)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 14,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Already assigned',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        value: isAssigned,
                        onChanged: (value) async {
                          if (value == true && !isAssigned) {
                            // Assign new role
                            print('🔄 Assigning role: ${role.name}');
                            await controller.assignRoleToUser(currentUser.id, role.id);
                            // Update reactive user
                            final updatedUser = await controller.userService.fetchUserById(currentUser.id);
                            if (updatedUser != null) {
                              print('✅ Updated roles: ${updatedUser.roles}');
                              reactiveUser.value = updatedUser;
                            }
                          } else if (value == false && isAssigned) {
                            // Remove role
                            print('🔄 Removing role: ${role.name}');
                            await controller.removeRoleFromUser(currentUser.id, role.id);
                            // Update reactive user
                            final updatedUser = await controller.userService.fetchUserById(currentUser.id);
                            if (updatedUser != null) {
                              print('✅ Updated roles after removal: ${updatedUser.roles}');
                              reactiveUser.value = updatedUser;
                            }
                          } else if (value == true && isAssigned) {
                            // Try to assign already assigned role
                            Get.snackbar(
                              'Info',
                              '${role.name} is already assigned to ${currentUser.name}',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                            );
                          }
                        },
                        activeColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  })
                  .toList(),
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ],
      ),
    );
  }
}