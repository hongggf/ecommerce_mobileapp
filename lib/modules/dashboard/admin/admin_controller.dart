import 'package:get/get.dart';

class AdminController extends GetxController {
  // Summary Cards
  var summaries = <DashboardSummary>[
    DashboardSummary(title: 'Total Users', value: '1,234', icon: '👤'),
    DashboardSummary(title: 'Total Products', value: '567', icon: '📦'),
    DashboardSummary(title: 'Total Orders', value: '890', icon: '🛒'),
    DashboardSummary(title: 'Total Sales Amount', value: '\$45,678', icon: '💰'),
    DashboardSummary(title: 'Out-of-Stock Products', value: '12', icon: '❌'),
    DashboardSummary(title: 'Low Stock Alerts', value: '5', icon: '⚠️'),
    DashboardSummary(title: 'Total Suppliers', value: '34', icon: '🏭'),
  ].obs;

  // Quick Actions
  var quickActions = <QuickAction>[
    QuickAction(title: 'Add New Product', icon: '➕'),
    QuickAction(title: 'Create Order', icon: '📝'),
    QuickAction(title: 'Add Stock', icon: '📥'),
    QuickAction(title: 'Add User', icon: '👤➕'),
  ].obs;
   var categories = <String>[].obs;

  void addCategory(String name) {
    categories.add(name);
    print('Category Added: $name');
  }
}

class DashboardSummary {
  final String title;
  final String value;
  final String icon;

  DashboardSummary({required this.title, required this.value, required this.icon});
}

class QuickAction {
  final String title;
  final String icon;

  QuickAction({required this.title, required this.icon});
}