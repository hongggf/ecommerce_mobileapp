import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Mock Models
class TopSellingProduct {
  final String productName;
  final int quantity;
  final double revenue;
  TopSellingProduct({required this.productName, required this.quantity, required this.revenue});
}

// Mock Controller
class AdminAnalyticsController extends GetxController {
  var isLoadingAnalytics = false.obs;
  var selectedTimeframe = 'all'.obs;
  
  var totalOrders = 0.obs;
  var totalRevenue = 0.0.obs;
  var completedOrders = 0.obs;
  var pendingOrders = 0.obs;
  var cancelledOrders = 0.obs;
  var totalProducts = 0.obs;
  var activeProducts = 0.obs;
  var inactiveProducts = 0.obs;
  var totalUsers = 0.obs;
  var activeUsers = 0.obs;
  var inactiveUsers = 0.obs;
  
  var orderTrend = <double>[].obs;
  var orderDates = <String>[].obs;
  var topSellingProducts = <TopSellingProduct>[].obs;

  double get averageOrderValue => totalOrders.value > 0 
      ? totalRevenue.value / totalOrders.value 
      : 0.0;
  
  double get completionRate => totalOrders.value > 0 
      ? (completedOrders.value / totalOrders.value) * 100 
      : 0.0;

  @override
  void onInit() {
    super.onInit();
    loadAllAnalytics();
  }

  Future<void> loadAllAnalytics() async {
    isLoadingAnalytics.value = true;
    await Future.delayed(Duration(milliseconds: 800));
    
    // Mock data
    totalOrders.value = 245;
    totalRevenue.value = 15420.50;
    completedOrders.value = 198;
    pendingOrders.value = 32;
    cancelledOrders.value = 15;
    totalProducts.value = 87;
    activeProducts.value = 72;
    inactiveProducts.value = 15;
    totalUsers.value = 523;
    activeUsers.value = 487;
    inactiveUsers.value = 36;
    
    orderTrend.value = [12, 19, 15, 25, 22, 30, 28];
    orderDates.value = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    topSellingProducts.value = [
      TopSellingProduct(productName: 'Wireless Headphones', quantity: 45, revenue: 2250.00),
      TopSellingProduct(productName: 'Smart Watch Pro', quantity: 38, revenue: 9500.00),
      TopSellingProduct(productName: 'USB-C Cable', quantity: 120, revenue: 1200.00),
      TopSellingProduct(productName: 'Phone Case', quantity: 95, revenue: 1425.00),
      TopSellingProduct(productName: 'Laptop Stand', quantity: 28, revenue: 1680.00),
    ];
    
    isLoadingAnalytics.value = false;
  }

  void setTimeframe(String timeframe) {
    selectedTimeframe.value = timeframe;
    loadAllAnalytics();
  }

  void refreshAnalytics() {
    loadAllAnalytics();
  }
}
