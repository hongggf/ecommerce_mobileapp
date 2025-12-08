import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/modules/admin_orders/admin_create_order_screen.dart';
import 'package:ecommerce_urban/modules/admin_users.dart/create_new_user_screen.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/admin_controller.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/widgets/admin_kpi_card_widget.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/widgets/admin_quick_action_card_widget.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({super.key});

  final AdminController controller = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh dashboard stats
          controller.refreshStats();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              SizedBox(height: AppSpacing.paddingL),
              kpiSection(),
              SizedBox(height: AppSpacing.paddingL),
              quickAction(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 7, 11, 239),
            Color.fromARGB(255, 204, 189, 240)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6366F1).withOpacity(0.6),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back, Admin!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your e-commerce store efficiently',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget kpiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // Refresh stats
                controller.refreshStats();
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Refresh'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.isLoadingStats.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return AdminKPICardWidget(
            items: [
              KPIItem(
                icon: Icons.shopping_cart,
                iconBgColor: Colors.orange,
                title: 'Total Orders',
                value: '${controller.totalOrders.value}',
              ),
              KPIItem(
                icon: Icons.inventory_2_outlined,
                iconBgColor: Colors.blue,
                title: 'Total Products',
                value: '${controller.totalProducts.value}',
              ),
              KPIItem(
                icon: Icons.people,
                iconBgColor: Colors.purple,
                title: 'Total Users',
                value: '${controller.totalUsers.value}',
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget quickAction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: "Quick Actions"),
        const SizedBox(height: 12),
        AdminQuickActionCard(
          icon: Icons.add_box,
          iconColor: Colors.white,
          iconBgColor: Colors.blue,
          title: 'Add New Product',
          onTap: () => Get.toNamed('/admin_add_product'),
        ),
        AdminQuickActionCard(
          icon: Icons.shopping_cart,
          iconColor: Colors.white,
          iconBgColor: Colors.orange,
          title: 'Create new order',
          onTap: () {
            Get.to(() => CreateOrderScreen());
          },
        ),
        AdminQuickActionCard(
          icon: Icons.people,
          iconColor: Colors.white,
          iconBgColor: Colors.purple,
          title: 'Add New User',
          onTap: () {
            Get.to(() => const CreateUserScreen());
          },
        ),
        AdminQuickActionCard(
          icon: Icons.bar_chart,
          iconColor: Colors.white,
          iconBgColor: Colors.teal,
          title: 'Analytics',
          onTap: () {
            Get.toNamed('/analytics');
          },
        ),
        AdminQuickActionCard(
          icon: Icons.settings,
          iconColor: Colors.white,
          iconBgColor: Colors.blueGrey,
          title: 'Settings',
          onTap: () {
            Get.toNamed('/profile');
          },
        ),
      ],
    );
  }
}
