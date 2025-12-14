import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/item_widget.dart';
import 'package:ecommerce_urban/app/widgets/profile_widget.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:ecommerce_urban/modules/admin/admin_dashboard/admin_dashboard_controller.dart';
import 'package:ecommerce_urban/modules/admin/admin_dashboard/widget/summary_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboardView extends StatelessWidget {
  AdminDashboardView({super.key});

  final AdminDashboardController controller = Get.put(AdminDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.paddingSM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileTileWidget(
              title: "Admin User",
              subtitle: "admin@system.com",
              avatarPath: "https://i.pravatar.cc/300",
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () => print("Tapped"),
            ),
            // _buildHeader(context),
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
          Text(
            'Dashboard Overview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Row(
            spacing: AppSpacing.paddingSM,
            children: [
              Expanded(
                  child: _buildMetricCard(
                      title: 'Total Orders',
                      value: controller.totalOrders.value.toString(),
                      color: AppColors.accent,
                      obsValue: controller.totalOrders
                  ),
              ),
              Expanded(
                child: _buildMetricCard(
                    title: 'Total Sales',
                    value: '\$${controller.totalSales.value.toStringAsFixed(2)}',
                    color: AppColors.secondary,
                    obsValue: controller.totalSales
                ),
              ),
            ],
          ),
          Row(
            spacing: AppSpacing.paddingSM,
            children: [
              Expanded(
                child: _buildMetricCard(
                    title: 'Total Customers',
                    value: controller.totalCustomers.value.toString(),
                    color: AppColors.success,
                    obsValue: controller.totalCustomers
                ),
              ),
              Expanded(
                child: _buildMetricCard(
                    title: 'Total Products',
                    value: controller.totalProducts.value.toString(),
                    color: AppColors.primary,
                    obsValue: controller.totalProducts
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Single Metric Card
  Widget _buildMetricCard({required String title, required String value, required Color color, required Rx obsValue,}) {
    return Obx(
          () => Container(
        width: 160,
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              obsValue.value.toString(),
              style: TextStyle(
                  color: AppColors.lightTextPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }

  /// Low Stock Alerts
  Widget _buildLowStockAlerts(BuildContext context) {
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
          ItemWidget(
            icon: Icons.warning,
            iconBgColor: Colors.red.shade200,
            title: "Product Name 1",
            subtitle: "1 Stock",
            onTapCard: (){

            }
          ),
          ItemWidget(
              icon: Icons.warning,
              iconBgColor: Colors.red.shade200,
              title: "Product Name 2",
              subtitle: "1 Stock",
              onTapCard: (){

              }
          ),
        ],
      ),
    );
  }

  /// New Users
  Widget _buildNewUsers(BuildContext context) {
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
          ItemWidget(
              icon: Icons.person_outline,
              iconBgColor: Colors.green.shade200,
              title: "Username 1",
              onTapCard: (){

              }
          ),
          ItemWidget(
              icon: Icons.person_outline,
              iconBgColor: Colors.green.shade200,
              title: "Username 2",
              onTapCard: (){

              }
          ),
        ],
      ),
    );
  }
}