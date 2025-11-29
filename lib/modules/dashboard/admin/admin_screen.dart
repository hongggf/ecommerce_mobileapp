// import 'package:ecommerce_urban/app/constants/app_spacing.dart';
// import 'package:ecommerce_urban/app/widgets/item_widget.dart';
// import 'package:ecommerce_urban/modules/dashboard/admin/admin_controller.dart';
// import 'package:ecommerce_urban/modules/dashboard/admin/widgets/admin_kpi_card_widget.dart';
// import 'package:ecommerce_urban/modules/dashboard/admin/widgets/admin_quick_action_card_widget.dart';
// import 'package:ecommerce_urban/app/widgets/title_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AdminScreen extends StatelessWidget {
//   AdminScreen({super.key});

//   final AdminController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             kpiSection(),
//             SizedBox(height: AppSpacing.paddingM),
//             quickAction(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget kpiSection() {
//     return AdminKPICardWidget(
//       items: [
//         KPIItem(
//             icon: Icons.error_outline,
//             iconBgColor: Colors.redAccent,
//             title: 'Low Stock',
//             value: '1234'),
//         KPIItem(
//             icon: Icons.shopping_cart,
//             iconBgColor: Colors.orange,
//             title: 'Orders',
//             value: '567'),
//         KPIItem(
//             icon: Icons.inventory_2_outlined,
//             iconBgColor: Colors.blue,
//             title: 'Products',
//             value: '500'),
//       ],
//     );
//   }

//   Widget quickAction() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TitleWidget(title: "Quick Actions"),
//         ItemWidget(
//           item: CardItem(
//             icon: Icons.category,
//             iconBgColor: Colors.blue,
//             title: 'Add New Category',
//             rightIcon: Icons.arrow_forward,
//             onTapCard: () => print('Add New Product clicked'),
//           ),
//         ),
//         ItemWidget(
//           item: CardItem(
//             icon: Icons.add_box,
//             iconBgColor: Colors.blue,
//             title: 'Add New Product',
//             rightIcon: Icons.arrow_forward,
//             onTapCard: () => print('Add New Product clicked'),
//           ),
//         ),
//         ItemWidget(
//           item: CardItem(
//             icon: Icons.shopping_cart,
//             iconBgColor: Colors.orange,
//             title: 'Create Order',
//             rightIcon: Icons.arrow_forward,
//             onTapCard: () => print('Create Order clicked'),
//           ),
//         ),
//         ItemWidget(
//           item: CardItem(
//             icon: Icons.store,
//             iconBgColor: Colors.green,
//             title: 'Add Stock',
//             rightIcon: Icons.arrow_forward,
//             onTapCard: () => print('Add Stock clicked'),
//           ),
//         ),
//         ItemWidget(
//           item: CardItem(
//             icon: Icons.person_add,
//             iconBgColor: Colors.purple,
//             title: 'Add User',
//             rightIcon: Icons.arrow_forward,
//             onTapCard: () => print('Add User clicked'),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/modules/add_product/add_product_screen.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/admin_controller.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/widgets/admin_kpi_card_widget.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/widgets/admin_quick_action_card_widget.dart';

import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({super.key});

  final AdminController controller = Get.find();

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
          // Refresh data from API
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
            Color.fromARGB(255, 13, 17, 229),
            Color.fromARGB(255, 186, 167, 230)
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
                // Navigate to detailed analytics
              },
              icon: const Icon(Icons.analytics_outlined, size: 18),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AdminKPICardWidget(
          items: [
            KPIItem(
              icon: Icons.error_outline,
              iconBgColor: Colors.redAccent,
              title: 'Low Stock',
              value: '1,234',
            ),
            KPIItem(
              icon: Icons.shopping_cart,
              iconBgColor: Colors.orange,
              title: 'Orders',
              value: '567',
            ),
            KPIItem(
              icon: Icons.inventory_2_outlined,
              iconBgColor: Colors.blue,
              title: 'Products',
              value: '500',
            ),
          ],
        ),
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
          onTap: () => Get.toNamed('/add_product'),
        ),
        AdminQuickActionCard(
          icon: Icons.shopping_cart,
          iconColor: Colors.white,
          iconBgColor: Colors.orange,
          title: 'Manage Orders',
          onTap: () {
            Get.toNamed('/manage_orders');
          },
        ),
        AdminQuickActionCard(
          icon: Icons.store,
          iconColor: Colors.white,
          iconBgColor: Colors.green,
          title: 'Stock Management',
          onTap: () {},
        ),
        AdminQuickActionCard(
          icon: Icons.people,
          iconColor: Colors.white,
          iconBgColor: Colors.purple,
          title: 'User Management',
          onTap: () {},
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
            Get.snackbar(
              'Coming Soon',
              'Settings feature',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      ],
    );
  }
}
