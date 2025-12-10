import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../admin_users_controller.dart';
import '../model/user_model.dart';
import '../admin_users_view.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel user;

  const UserCardWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminUsersController>();

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
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '.',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
                PopupMenuButton<String>(
                  onSelected: (value) => controller.handleUserAction(value, user),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'status', child: Text('Change Status')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
