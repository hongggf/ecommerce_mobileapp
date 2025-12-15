import 'package:ecommerce_urban/api/controller/auth_controller.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/constants/app_widget.dart';
import 'package:ecommerce_urban/app/widgets/confirm_dialog_widget.dart';
import 'package:ecommerce_urban/app/widgets/icon_widget.dart';
import 'package:ecommerce_urban/app/widgets/item_widget.dart';
import 'package:ecommerce_urban/app/widgets/profile_widget.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:ecommerce_urban/modules/admin/admin_dashboard/admin_dashboard_controller.dart';
import 'package:ecommerce_urban/modules/admin/admin_dashboard/widget/admin_drawer_widget.dart';
import 'package:ecommerce_urban/modules/admin/admin_dashboard/widget/metric_card_widget.dart';
import 'package:ecommerce_urban/modules/admin/admin_dashboard/widget/summary_chart_widget.dart';
import 'package:ecommerce_urban/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboardView extends StatelessWidget {
  AdminDashboardView({super.key});

  final AdminDashboardController controller = Get.put(AdminDashboardController());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawerWidget(
        onTapItem: (route) {
          Navigator.pop(context);
        },
      ),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchDashboard,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.paddingSM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfile(),
            SizedBox(height: AppSpacing.paddingSM),
            _buildOverviewMetrics(context),
            SizedBox(height: AppSpacing.paddingSM),
            SummaryChartWidget(
              values: controller.salesSummary,
              labels: controller.days,
              title: 'Weekly Sales',
            ),
            SizedBox(height: AppSpacing.paddingSM),
            _buildLowStockAlerts(context),
            SizedBox(height: AppSpacing.paddingSM),
            _buildNewUsers(context),
          ],
        ),
      ),
    );
  }

  /// Profile
  Widget _buildProfile() {
    return Obx(() {
      final user = controller.currentUser.value;
      if (user == null) {
        // Show a placeholder while loading
        return ProfileTileWidget(
          title: "Loading...",
          subtitle: "",
          avatarPath: "https://i.pravatar.cc/300",
          trailing: IconWidget(
            size: AppWidgetSize.iconXS,
            icon: Icons.login,
            iconColor: Colors.white,
            onTap: () => authController.logout(),
          ),
          onTap: () => Get.toNamed(AppRoutes.adminProfile),
        );
      }

      return ProfileTileWidget(
        title: user.name,
        subtitle: user.email,
        avatarPath: user.avatar,
        trailing: IconWidget(
          size: AppWidgetSize.iconXS,
          icon: Icons.login,
          iconColor: Colors.white,
          onTap: () => authController.logout(),
        ),
        onTap: () => Get.toNamed(AppRoutes.adminProfile),
      );
    });
  }

  /// Overview Metrics Cards
  Widget _buildOverviewMetrics(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingSM),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.paddingSM,
        children: [
          TitleWidget(title: 'Dashboard Overview'),
          Row(
            spacing: AppSpacing.paddingSM,
            children: [
              Expanded(
                child: Obx(()=>MetricCardWidget(
                  title: 'Total Orders',
                  value: controller.totalOrders.toString(),
                  color: Colors.blue,
                ))
              ),
              Expanded(
                child: Obx(()=>MetricCardWidget(
                  title: 'Total Sales',
                  value: '\$${controller.totalSales.toStringAsFixed(2)}',
                  color: Colors.blueGrey,
                ))
              ),
            ],
          ),
          Row(
            spacing: AppSpacing.paddingSM,
            children: [
              Expanded(
                child: Obx(()=>MetricCardWidget(
                  title: 'Total Customers',
                  value: controller.totalCustomers.toString(),
                  color: Colors.orange,
                ))
              ),
              Expanded(
                child: Obx(()=>MetricCardWidget(
                  title: 'Total Products',
                  value: controller.totalProducts.toString(),
                  color: Colors.green,
                ))
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Low Stock Alerts
  Widget _buildLowStockAlerts(BuildContext context) {
    return Obx(() {
      final products = controller.lowStockProducts;

      return Container(
        padding: EdgeInsets.all(AppSpacing.paddingSM),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(title: "Low Stock Alerts"),
            SizedBox(height: AppSpacing.paddingSM),
            if (products.isEmpty)
              Text("No low stock products found"),
            ...products.map((product) => ItemWidget(
              icon: Icons.warning,
              iconBgColor: Colors.red.shade200,
              title: product.name,
              subtitle: "${product.stockQuantity} Stock",
              onTapCard: () {
                print("Tapped product: ${product.name}");
              },
            )),
          ],
        ),
      );
    });
  }

  /// New Users
  Widget _buildNewUsers(BuildContext context) {
    return Obx(() {
      final users = controller.topNewUsers;

      return Container(
        padding: EdgeInsets.all(AppSpacing.paddingSM),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(title: "New Users"),
            SizedBox(height: AppSpacing.paddingSM),
            if (users.isEmpty)
              Text("No new users found"),
            ...users.map((user) => ItemWidget(
              icon: Icons.person_outline,
              iconBgColor: Colors.green.shade200,
              title: user.name,
              subtitle: user.email,
              onTapCard: () {
                print("Tapped user: ${user.name}");
              },
            )),
          ],
        ),
      );
    });
  }
}