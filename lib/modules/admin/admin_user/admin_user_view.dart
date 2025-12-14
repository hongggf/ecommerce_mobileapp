import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/modules/admin/admin_user/admin_user_controller.dart';
import 'package:ecommerce_urban/modules/admin/admin_user/widget/admin_user_item_widget.dart';
import 'package:ecommerce_urban/modules/admin/admin_user/widget/admin_user_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUserView extends StatelessWidget {
  AdminUserView({super.key});

  final AdminUserController controller = Get.put(AdminUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchUsers,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingSM),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: AppSpacing.marginM),
            _buildFilterAndSort(),
            Expanded(child: _buildUserList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.prepareForm();
          AdminUserForm.show(controller: controller);
        },
        icon: const Icon(Icons.add),
        label: const Text("Create User"),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: const InputDecoration(
        hintText: "Search by name",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      onChanged: controller.setSearch,
    );
  }

  Widget _buildFilterAndSort() {
    return Row(
      children: [
        Obx(
              () => DropdownButton<String>(
            hint: const Text("Filter by Role"),
            value: controller.filterRole.value.isEmpty ? null : controller.filterRole.value,
            items: ["customer", "admin"]
                .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                .toList(),
            onChanged: (value) {
              if (value != null) controller.setFilterRole(value);
            },
          ),
        ),
        const SizedBox(width: 16),
        Obx(
              () => DropdownButton<String>(
            hint: const Text("Sort"),
            value: controller.sortBy.value.isEmpty ? null : controller.sortBy.value,
            items: [
              DropdownMenuItem(value: "name_asc", child: Text("Name A-Z")),
              DropdownMenuItem(value: "name_desc", child: Text("Name Z-A")),
              DropdownMenuItem(value: "role", child: Text("Role")),
            ],
            onChanged: (value) {
              if (value != null) controller.setSort(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserList() {
    return Obx(
          () {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.users.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        return ListView.separated(
          itemCount: controller.users.length,
          separatorBuilder: (_, __) => const SizedBox(),
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return AdminUserItemWidget(
              name: user.name.toString(),
              subtitle: user.email.toString(),
              role: user.role.toString(),
              onEdit: (){
                controller.prepareForm(user: user);
                AdminUserForm.show(controller: controller);
              },
              onDelete: () => controller.deleteUser(user.id!.toInt()),
            );
          },
        );
      },
    );
  }
}