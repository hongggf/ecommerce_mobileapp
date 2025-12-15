import 'package:ecommerce_urban/modules/admin/admin_report/admin_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminReportView extends StatelessWidget {
  final ReportController controller = Get.put(ReportController());

  AdminReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Top Selling Products"),
              const SizedBox(height: 8),
              _buildBarChart(controller.topSelling.value),
              const SizedBox(height: 16),

              _buildSectionTitle("Least Selling Products"),
              const SizedBox(height: 8),
              _buildBarChart(controller.leastSelling.value),
              const SizedBox(height: 16),

              _buildSectionTitle("Product Revenue"),
              const SizedBox(height: 8),
              _buildBarChart(controller.revenueReport.value),
              const SizedBox(height: 16),

              _buildSectionTitle("Stock Level"),
              const SizedBox(height: 8),
              _buildStockList(controller.stockLevels),
              const SizedBox(height: 16),

              _buildSectionTitle("Product Distribution"),
              const SizedBox(height: 8),
              _buildPieChart(controller.distribution.value),
              const SizedBox(height: 16),

              // _buildSectionTitle("Sales by Period"),
              // const SizedBox(height: 8),
              // Container(
              //   height: 200,
              //   child: Row(
              //     children: ['day', 'week', 'month'].map((p) {
              //       return Padding(
              //         padding: const EdgeInsets.only(right: 8),
              //         child: ElevatedButton(
              //           onPressed: () => controller.setPeriod(p),
              //           child: Text(p.toUpperCase()),
              //         ),
              //       );
              //     }).toList(),
              //   ),
              // ),
              // const SizedBox(height: 8),
              // _buildBarChart(controller.salesByPeriod.value?.data),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  /// ---------------- Bar Chart ----------------
  Widget _buildBarChart(data) {
    if (data == null || data.labels.isEmpty) return const Text("No data");

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (data.values.reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  if (idx < 0 || idx >= data.labels.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      data.labels[idx],
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                reservedSize: 50,
              ),
            ),

          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(data.labels.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data.values[i].toDouble(),
                  color: Colors.blueAccent,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// ---------------- Pie Chart ----------------
  Widget _buildPieChart(data) {
    if (data == null || data.labels.isEmpty) return const Text("No data");

    final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple];

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: List.generate(data.labels.length, (i) {
            final value = data.values[i].toDouble();
            final color = colors[i % colors.length];
            return PieChartSectionData(
              value: value,
              color: color,
              title: "${data.labels[i]}\n${value.toInt()}",
              radius: 60,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            );
          }),
        ),
      ),
    );
  }

  /// ---------------- Stock List ----------------
  Widget _buildStockList(List stocks) {
    if (stocks.isEmpty) return const Text("No data");

    return Column(
      children: stocks.map((s) {
        return ListTile(
          title: Text(s.product),
          trailing: Text(s.stockQuantity.toString()),
        );
      }).toList(),
    );
  }
}