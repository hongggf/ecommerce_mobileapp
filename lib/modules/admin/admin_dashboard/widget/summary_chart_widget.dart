import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryChartWidget extends StatelessWidget {
  final RxList<double> values;
  final List<String> labels;
  final String title;

  const SummaryChartWidget({
    super.key,
    required this.values,
    required this.labels,
    this.title = 'Sales Summary',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _buildDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context),
          const SizedBox(height: 16),
          _buildChart(context),
        ],
      ),
    );
  }

  // ------------------ UI PARTS ------------------

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: AppColors.lightSurface,
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Obx(
            () => BarChart(
          BarChartData(
            barTouchData: BarTouchData(enabled: false),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            titlesData: _buildTitles(context),
            barGroups: _buildBarGroups(),
          ),
        ),
      ),
    );
  }

  // ------------------ CHART CONFIG ------------------

  FlTitlesData _buildTitles(BuildContext context) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= values.length) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                values[index].toInt().toString(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= labels.length) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                labels[index],
                style: Theme.of(context).textTheme.labelSmall,
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(
      values.length,
          (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
            color: AppColors.primary,
            width: 18,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      ),
    );
  }
}