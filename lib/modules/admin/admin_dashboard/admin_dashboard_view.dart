import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/constants/app_widget.dart';
import 'package:ecommerce_urban/app/widgets/icon_widget.dart';
import 'package:ecommerce_urban/app/widgets/item_widget.dart';
import 'package:ecommerce_urban/app/widgets/profile_widget.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:ecommerce_urban/modules/admin/admin_dashboard/admin_dashboard_controller.dart';
import 'package:ecommerce_urban/modules/admin/admin_dashboard/widget/metric_card_widget.dart';
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
  Widget _buildProfile(){
    return ProfileTileWidget(
      title: "Admin User",
      subtitle: "admin@system.com",
      avatarPath: "https://i.pravatar.cc/300",
      trailing: IconWidget(
        size: AppWidgetSize.iconS,
        icon: Icons.search,
        iconColor: Colors.white,
        onTap: (){
          print("On icon Tap");
        },
      ),
      onTap: () => print("Tapped"),
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
          TitleWidget(title: 'Dashboard Overview'),
          Row(
            spacing: AppSpacing.paddingSM,
            children: [
              Expanded(
                child: MetricCardWidget(
                  title: 'Total Orders',
                  value: controller.totalOrders.value.toString(),
                  color: Colors.blue,
                ),
              ),
              Expanded(
                child: MetricCardWidget(
                  title: 'Total Sales',
                  value: '\$${controller.totalSales.value.toStringAsFixed(2)}',
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
          Row(
            spacing: AppSpacing.paddingSM,
            children: [
              Expanded(
                child: MetricCardWidget(
                  title: 'Total Customers',
                  value: controller.totalCustomers.value.toString(),
                  color: Colors.orange,
                ),
              ),
              Expanded(
                child: MetricCardWidget(
                  title: 'Total Products',
                  value: controller.totalProducts.value.toString(),
                  color: Colors.green,
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
    return Obx(() => Container(
        width: 160,
        height: 100,
        padding: EdgeInsets.all(AppSpacing.paddingSM),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
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