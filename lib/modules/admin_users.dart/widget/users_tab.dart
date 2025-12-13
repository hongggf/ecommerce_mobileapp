import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/widget/users_cards_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../admin_users_controller.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminUsersController>();

    return Column(
      children: [
        _buildUserStatsSection(controller),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingUsers.value &&
                controller.filteredUsers.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () => controller.loadUsers(),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                      child: _buildUserSearchAndFilter(controller)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final user = controller.filteredUsers[index];
                          return UserCardWidget(user: user);
                        },
                        childCount: controller.filteredUsers.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildUserStatsSection(AdminUsersController controller) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
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
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildUserSearchAndFilter(AdminUsersController controller) {
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
              fillColor: Theme.of(Get.context!).cardColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
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
                            backgroundColor: Theme.of(Get.context!).canvasColor,
                            selectedColor: Colors.purple,
                            labelStyle: TextStyle(
                              color: controller.userStatusFilter.value == status
                                  ? Colors.white
                                  : null,
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
}
