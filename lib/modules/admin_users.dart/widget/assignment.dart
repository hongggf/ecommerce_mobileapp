import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../admin_users_controller.dart';
import '../model/user_model.dart';
import 'users_cards_widget.dart';

class AssignmentTab extends StatelessWidget {
  const AssignmentTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminUsersController>();

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

      return RefreshIndicator(
        onRefresh: () => controller.loadUsers(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.allUsers.length,
          itemBuilder: (context, index) {
            final user = controller.allUsers[index];
            return _buildUserAssignmentCard(controller, user);
          },
        ),
      );
    });
  }

  Widget _buildUserAssignmentCard(AdminUsersController controller, UserModel user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.purple,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(user.email, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Current Roles
            const Text('Current Roles:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            if (user.roles != null && user.roles!.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: user.roles!
                    .map((roleName) => Chip(
                          label: Text(roleName, style: const TextStyle(color: Colors.white, fontSize: 12)),
                          backgroundColor: Colors.purple,
                          deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
                          onDeleted: () => controller.removeRoleFromUserDirect(user, roleName),
                        ))
                    .toList(),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'No roles assigned',
                  style: TextStyle(color: Colors.orange[700], fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => controller.showAssignRoleDialog(user),
                icon: const Icon(Icons.add),
                label: const Text('Assign Role'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 