import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../admin_users_controller.dart';
import '../model/role_model.dart';

class RoleCardWidget extends StatelessWidget {
  final RoleModel role;

  const RoleCardWidget({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminUsersController>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.security, color: Colors.purple, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(role.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (role.description != null)
                    Text(
                      role.description!,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => controller.handleRoleAction(value, role),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
