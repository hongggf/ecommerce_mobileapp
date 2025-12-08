import 'package:ecommerce_urban/modules/admin_analystics/admin_analystics_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAnalyticsView extends StatelessWidget {
  const AdminAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminAnalyticsController>(
      init: AdminAnalyticsController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Analytics'),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => controller.refreshAnalytics(),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => controller.loadAllAnalytics(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                if (controller.isLoadingAnalytics.value) {
                  return const SizedBox(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeframe Filter
                    _buildTimeframeFilter(controller),
                    const SizedBox(height: 20),

                    // Orders Line Graph
                    _buildOrdersLineGraph(controller),
                    const SizedBox(height: 24),

                    // Top Selling Products Table
                    _buildTopSellingProductsTable(controller),
                    const SizedBox(height: 24),

                    // Orders Analytics Section
                    _buildSectionTitle('Orders Analytics'),
                    const SizedBox(height: 12),
                    _buildOrdersAnalyticsCards(controller),
                    const SizedBox(height: 24),

                    // Products Analytics Section
                    _buildSectionTitle('Products Analytics'),
                    const SizedBox(height: 12),
                    _buildProductsAnalyticsCards(controller),
                    const SizedBox(height: 24),

                    // Users Analytics Section
                    _buildSectionTitle('Users Analytics'),
                    const SizedBox(height: 12),
                    _buildUsersAnalyticsCards(controller),
                    const SizedBox(height: 24),

                    // Summary Section
                    _buildSummarySection(controller),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeframeFilter(AdminAnalyticsController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ['all', 'week', 'month', 'year'].map((timeframe) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Obx(() {
              final isSelected = controller.selectedTimeframe.value == timeframe;
              return ElevatedButton(
                onPressed: () => controller.setTimeframe(timeframe),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.purple : Colors.grey[300],
                  foregroundColor: isSelected ? Colors.white : Colors.black,
                ),
                child: Text(
                  timeframe.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersLineGraph(AdminAnalyticsController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Orders Trend (Last 7 Days)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: Obx(() {
              if (controller.orderTrend.isEmpty) {
                return const Center(child: Text('No data available'));
              }

              final maxY = controller.orderTrend.reduce((a, b) => a > b ? a : b);

              return LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: maxY > 0 ? maxY / 5 : 1,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          int index = value.toInt();
                          if (index >= 0 &&
                              index < controller.orderDates.length) {
                            return Text(
                              controller.orderDates[index],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        controller.orderTrend.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          controller.orderTrend[index],
                        ),
                      ),
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.withOpacity(0.3),
                            Colors.blue.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                  minY: 0,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellingProductsTable(AdminAnalyticsController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Selling Products',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.topSellingProducts.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No product sales data available'),
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 24,
                columns: const [
                  DataColumn(
                    label: Text(
                      'Product Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Quantity Sold',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Revenue',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
                rows: List.generate(
                  controller.topSellingProducts.length,
                  (index) {
                    final product = controller.topSellingProducts[index];
                    final isEven = index % 2 == 0;

                    return DataRow(
                      color: MaterialStateColor.resolveWith(
                        (states) => isEven
                            ? Colors.grey[50]!
                            : Colors.white,
                      ),
                      cells: [
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(
                              product.productName,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${product.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '\$${product.revenue.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildOrdersAnalyticsCards(AdminAnalyticsController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'Total Orders',
                '${controller.totalOrders.value}',
                Icons.shopping_cart,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAnalyticsCard(
                'Total Revenue',
                '\$${controller.totalRevenue.value.toStringAsFixed(2)}',
                Icons.attach_money,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'Completed',
                '${controller.completedOrders.value}',
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAnalyticsCard(
                'Pending',
                '${controller.pendingOrders.value}',
                Icons.schedule,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAnalyticsCard(
                'Cancelled',
                '${controller.cancelledOrders.value}',
                Icons.cancel,
                Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildAnalyticsCard(
          'Avg Order Value',
          '\$${controller.averageOrderValue.toStringAsFixed(2)}',
          Icons.trending_up,
          Colors.teal,
        ),
      ],
    );
  }

  Widget _buildProductsAnalyticsCards(AdminAnalyticsController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildAnalyticsCard(
            'Total Products',
            '${controller.totalProducts.value}',
            Icons.inventory,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAnalyticsCard(
            'Active',
            '${controller.activeProducts.value}',
            Icons.check,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAnalyticsCard(
            'Inactive',
            '${controller.inactiveProducts.value}',
            Icons.close,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildUsersAnalyticsCards(AdminAnalyticsController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildAnalyticsCard(
            'Total Users',
            '${controller.totalUsers.value}',
            Icons.people,
            Colors.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAnalyticsCard(
            'Active',
            '${controller.activeUsers.value}',
            Icons.check,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAnalyticsCard(
            'Inactive',
            '${controller.inactiveUsers.value}',
            Icons.close,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection(AdminAnalyticsController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
            'Total Revenue',
            '\$${controller.totalRevenue.value.toStringAsFixed(2)}',
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Completion Rate',
            '${controller.completionRate.toStringAsFixed(1)}%',
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Avg Order Value',
            '\$${controller.averageOrderValue.toStringAsFixed(2)}',
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Active Products',
            '${controller.activeProducts.value}/${controller.totalProducts.value}',
            Colors.purple,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Active Users',
            '${controller.activeUsers.value}/${controller.totalUsers.value}',
            Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}