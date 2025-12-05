
// lib/modules/dashboard/admin/views/admin_analytics_view.dart
import 'package:ecommerce_urban/modules/admin_analystics/admin_analystics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AdminAnalyticsView extends StatelessWidget {
  late final AdminAnalyticsController controller = Get.find<AdminAnalyticsController>();

  AdminAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Analytics Content Here'),
          ],
        ),
      ),
      
    );
  }
}
