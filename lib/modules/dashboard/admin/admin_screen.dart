import 'package:ecommerce_urban/modules/admin_orders/admin_create_order_screen.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/admin_controller.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/widgets/admin_kpi_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({super.key});

  final AdminController controller = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refreshStats();
          await Future.delayed(Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(theme, isDark),
              SizedBox(height: 24),
              _buildKPISection(theme, isDark),
              SizedBox(height: 24),
              _buildQuickActionsSection(theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.4),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.dashboard, color: Colors.white, size: 28),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Manage your e-commerce store efficiently',
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPISection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: theme.primaryColor, size: 24),
                SizedBox(width: 8),
                Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: controller.refreshStats,
              icon: Icon(Icons.refresh, size: 18),
              label: Text('Refresh'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Obx(() {
          if (controller.isLoadingStats.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return _buildKPICards(theme, isDark);
        }),
      ],
    );
  }

  Widget _buildKPICards(ThemeData theme, bool isDark) {
    final items = [
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
        iconBgColor: theme.primaryColor,
        title: 'Total Users',
        value: '${controller.totalUsers.value}',
      ),
    ];

    return Column(
      children: items.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item.icon,
                  color: item.iconBgColor,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActionsSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.flash_on, color: theme.primaryColor, size: 24),
            SizedBox(width: 8),
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        _buildQuickActionCard(
          icon: Icons.add_box,
          iconColor: Colors.white,
          iconBgColor: Colors.blue,
          title: 'Add New Product',
          subtitle: 'Create a new product listing',
          onTap: () => Get.toNamed('/admin_add_product'),
          theme: theme,
          isDark: isDark,
        ),
        _buildQuickActionCard(
          icon: Icons.shopping_cart,
          iconColor: Colors.white,
          iconBgColor: Colors.orange,
          title: 'Create New Order',
          subtitle: 'Manually create an order',
          onTap: () => Get.to(CreateOrderScreen()),
          theme: theme,
          isDark: isDark,
        ),
        _buildQuickActionCard(
          icon: Icons.people,
          iconColor: Colors.white,
          iconBgColor: theme.primaryColor,
          title: 'Add New User',
          subtitle: 'Register a new user account',
          onTap: () => Get.snackbar('Info', 'Add user screen'),
          theme: theme,
          isDark: isDark,
        ),
        _buildQuickActionCard(
          icon: Icons.bar_chart,
          iconColor: Colors.white,
          iconBgColor: Colors.teal,
          title: 'Analytics',
          subtitle: 'View detailed reports',
          onTap: () => Get.toNamed('/analytics'),
          theme: theme,
          isDark: isDark,
        ),
        _buildQuickActionCard(
          icon: Icons.settings,
          iconColor: Colors.white,
          iconBgColor: Colors.blueGrey,
          title: 'Settings',
          subtitle: 'Configure your store',
          onTap: () => Get.toNamed('/profile'),
          theme: theme,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: iconBgColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
