import 'package:ecommerce_urban/modules/admin_users.dart/widget/rolde_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../admin_users_controller.dart';

class RolesTab extends StatelessWidget {
  const RolesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminUsersController>();

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
            return RoleCardWidget(role: role);
          },
        ),
      );
    });
  }
}