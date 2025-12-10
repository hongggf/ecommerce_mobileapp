// View
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
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text('Analytics', style: TextStyle(fontWeight: FontWeight.w600)),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => controller.refreshAnalytics(),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => controller.loadAllAnalytics(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(20),
              child: Obx(() {
                if (controller.isLoadingAnalytics.value) {
                  return SizedBox(
                    height: 400,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimeframeFilter(controller, theme),
                    SizedBox(height: 24),
                    _buildOrdersLineGraph(controller, theme, isDark),
                    SizedBox(height: 24),
                    _buildTopSellingProductsTable(controller, theme, isDark),
                    SizedBox(height: 24),
                    _buildSectionTitle('Orders Analytics', theme),
                    SizedBox(height: 16),
                    _buildOrdersAnalyticsCards(controller, theme, isDark),
                    SizedBox(height: 24),
                    _buildSectionTitle('Products Analytics', theme),
                    SizedBox(height: 16),
                    _buildProductsAnalyticsCards(controller, theme, isDark),
                    SizedBox(height: 24),
                    _buildSectionTitle('Users Analytics', theme),
                    SizedBox(height: 16),
                    _buildUsersAnalyticsCards(controller, theme, isDark),
                    SizedBox(height: 24),
                    _buildSummarySection(controller, theme, isDark),
                    SizedBox(height: 24),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeframeFilter(AdminAnalyticsController controller, ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ['all', 'week', 'month', 'year'].map((timeframe) {
          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: Obx(() {
              final isSelected = controller.selectedTimeframe.value == timeframe;
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: () => controller.setTimeframe(timeframe),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? theme.primaryColor : Colors.grey[300],
                    foregroundColor: isSelected ? Colors.white : Colors.black87,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: isSelected ? 4 : 0,
                  ),
                  child: Text(
                    timeframe.toUpperCase(),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              );
            }),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersLineGraph(AdminAnalyticsController controller, ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: theme.primaryColor, size: 24),
              SizedBox(width: 8),
              Text(
                'Orders Trend (Last 7 Days)',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 280,
            child: Obx(() {
              if (controller.orderTrend.isEmpty) {
                return Center(
                  child: Text('No data available',
                    style: TextStyle(color: Colors.grey[600])),
                );
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
                        color: Colors.grey.withOpacity(0.15),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.15),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < controller.orderDates.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                controller.orderDates[index],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
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
                      gradient: LinearGradient(
                        colors: [theme.primaryColor, Colors.blue],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            theme.primaryColor.withOpacity(0.3),
                            Colors.blue.withOpacity(0.05),
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

  Widget _buildTopSellingProductsTable(AdminAnalyticsController controller, ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: Colors.amber, size: 24),
              SizedBox(width: 8),
              Text(
                'Top Selling Products',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Obx(() {
            if (controller.topSellingProducts.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No product sales data available',
                    style: TextStyle(color: Colors.grey[600])),
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 30,
                headingRowHeight: 50,
                dataRowHeight: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'Product Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Quantity Sold',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Revenue',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
                            ? (isDark ? Colors.grey[800]! : Colors.grey[50]!)
                            : (isDark ? Colors.grey[850]! : Colors.white),
                      ),
                      cells: [
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(
                              product.productName,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${product.quantity}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '\$${product.revenue.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 13,
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

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOrdersAnalyticsCards(AdminAnalyticsController controller, ThemeData theme, bool isDark) {
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
                theme,
                isDark,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildAnalyticsCard(
                'Total Revenue',
                '\$${controller.totalRevenue.value.toStringAsFixed(2)}',
                Icons.attach_money,
                Colors.green,
                theme,
                isDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'Completed',
                '${controller.completedOrders.value}',
                Icons.check_circle,
                Colors.green,
                theme,
                isDark,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildAnalyticsCard(
                'Pending',
                '${controller.pendingOrders.value}',
                Icons.schedule,
                Colors.blue,
                theme,
                isDark,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildAnalyticsCard(
                'Cancelled',
                '${controller.cancelledOrders.value}',
                Icons.cancel,
                Colors.red,
                theme,
                isDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildAnalyticsCard(
          'Avg Order Value',
          '\$${controller.averageOrderValue.toStringAsFixed(2)}',
          Icons.trending_up,
          Colors.teal,
          theme,
          isDark,
        ),
      ],
    );
  }

  Widget _buildProductsAnalyticsCards(AdminAnalyticsController controller, ThemeData theme, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildAnalyticsCard(
            'Total Products',
            '${controller.totalProducts.value}',
            Icons.inventory,
            Colors.blue,
            theme,
            isDark,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildAnalyticsCard(
            'Active',
            '${controller.activeProducts.value}',
            Icons.check,
            Colors.green,
            theme,
            isDark,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildAnalyticsCard(
            'Inactive',
            '${controller.inactiveProducts.value}',
            Icons.close,
            Colors.orange,
            theme,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildUsersAnalyticsCards(AdminAnalyticsController controller, ThemeData theme, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildAnalyticsCard(
            'Total Users',
            '${controller.totalUsers.value}',
            Icons.people,
            theme.primaryColor,
            theme,
            isDark,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildAnalyticsCard(
            'Active',
            '${controller.activeUsers.value}',
            Icons.check,
            Colors.green,
            theme,
            isDark,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildAnalyticsCard(
            'Inactive',
            '${controller.inactiveUsers.value}',
            Icons.close,
            Colors.orange,
            theme,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection(AdminAnalyticsController controller, ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.summarize, color: theme.primaryColor, size: 24),
              SizedBox(width: 8),
              Text(
                'Summary',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildSummaryRow('Total Revenue', '\$${controller.totalRevenue.value.toStringAsFixed(2)}', Colors.green, theme, isDark),
          SizedBox(height: 14),
          _buildSummaryRow('Completion Rate', '${controller.completionRate.toStringAsFixed(1)}%', Colors.blue, theme, isDark),
          SizedBox(height: 14),
          _buildSummaryRow('Avg Order Value', '\$${controller.averageOrderValue.toStringAsFixed(2)}', Colors.orange, theme, isDark),
          SizedBox(height: 14),
          _buildSummaryRow('Active Products', '${controller.activeProducts.value}/${controller.totalProducts.value}', theme.primaryColor, theme, isDark),
          SizedBox(height: 14),
          _buildSummaryRow('Active Users', '${controller.activeUsers.value}/${controller.totalUsers.value}', Colors.teal, theme, isDark),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color, ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}