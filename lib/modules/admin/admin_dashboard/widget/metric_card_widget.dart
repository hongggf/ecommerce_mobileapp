import 'package:flutter/material.dart';
import 'package:ecommerce_urban/app/constants/app_colors.dart';

class MetricCardWidget extends StatelessWidget {
  final String title;
  final String value; // <-- Now a String
  final Color color;

  const MetricCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 160,
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              color: color,
            ),
            maxLines: 1,
          ),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}