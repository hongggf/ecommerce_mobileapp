import 'package:ecommerce_urban/modules/analytics/analytics_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ChartPeriod { daily, weekly, monthly }

class AnalyticsController extends GetxController {
  final isLoading = false.obs;
  final selectedPeriod = ChartPeriod.daily.obs;
  final salesData = <SalesData>[].obs;
  final topProducts = <TopProduct>[].obs;
  final inventoryData = <InventoryData>[].obs;
  final overview = Rx<AnalyticsOverview?>(null);

  @override
  void onInit() {
    super.onInit();
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 1200));

    overview.value = _getDummyOverview();
    salesData.value = _getDummySalesData(selectedPeriod.value);
    topProducts.value = _getDummyTopProducts();
    inventoryData.value = _getDummyInventoryData();

    isLoading.value = false;
  }

  void changePeriod(ChartPeriod period) {
    selectedPeriod.value = period;
    salesData.value = _getDummySalesData(period);
  }

  Future<void> refreshAnalytics() async {
    await loadAnalytics();
  }

  // Dummy data generators
  AnalyticsOverview _getDummyOverview() {
    return AnalyticsOverview(
      totalSales: 125840.50,
      growthPercentage: 12.5,
      totalOrders: 1247,
      ordersGrowth: 8,
      averageOrderValue: 100.91,
      inventoryValue: 458920.00,
    );
  }

  List<SalesData> _getDummySalesData(ChartPeriod period) {
    switch (period) {
      case ChartPeriod.daily:
        return [
          SalesData(date: 'Mon', amount: 12500, orders: 85),
          SalesData(date: 'Tue', amount: 15800, orders: 102),
          SalesData(date: 'Wed', amount: 13200, orders: 91),
          SalesData(date: 'Thu', amount: 18500, orders: 120),
          SalesData(date: 'Fri', amount: 21000, orders: 145),
          SalesData(date: 'Sat', amount: 25400, orders: 168),
          SalesData(date: 'Sun', amount: 19440, orders: 136),
        ];
      case ChartPeriod.weekly:
        return [
          SalesData(date: 'Week 1', amount: 45000, orders: 320),
          SalesData(date: 'Week 2', amount: 52000, orders: 380),
          SalesData(date: 'Week 3', amount: 48000, orders: 340),
          SalesData(date: 'Week 4', amount: 58000, orders: 420),
        ];
      case ChartPeriod.monthly:
        return [
          SalesData(date: 'Jan', amount: 85000, orders: 650),
          SalesData(date: 'Feb', amount: 92000, orders: 720),
          SalesData(date: 'Mar', amount: 88000, orders: 680),
          SalesData(date: 'Apr', amount: 105000, orders: 820),
          SalesData(date: 'May', amount: 98000, orders: 760),
          SalesData(date: 'Jun', amount: 125840, orders: 1247),
        ];
    }
  }

  List<TopProduct> _getDummyTopProducts() {
    return [
      TopProduct(
        id: '1',
        name: 'Wireless Headphones Pro',
        imageUrl: 'https://via.placeholder.com/100',
        unitsSold: 456,
        revenue: 68400.00,
        percentage: 28.5,
      ),
      TopProduct(
        id: '2',
        name: 'Smart Watch Series 5',
        imageUrl: 'https://via.placeholder.com/100',
        unitsSold: 328,
        revenue: 49200.00,
        percentage: 20.5,
      ),
      TopProduct(
        id: '3',
        name: 'Laptop Pro 15"',
        imageUrl: 'https://via.placeholder.com/100',
        unitsSold: 142,
        revenue: 42600.00,
        percentage: 17.8,
      ),
      TopProduct(
        id: '4',
        name: 'Bluetooth Speaker',
        imageUrl: 'https://via.placeholder.com/100',
        unitsSold: 289,
        revenue: 25992.00,
        percentage: 10.8,
      ),
      TopProduct(
        id: '5',
        name: 'Phone Case Premium',
        imageUrl: 'https://via.placeholder.com/100',
        unitsSold: 512,
        revenue: 15360.00,
        percentage: 6.4,
      ),
    ];
  }

  List<InventoryData> _getDummyInventoryData() {
    return [
      InventoryData(
        category: 'Electronics',
        value: 185000,
        items: 342,
        color: const Color(0xFF2196F3),
      ),
      InventoryData(
        category: 'Clothing',
        value: 125000,
        items: 567,
        color: const Color(0xFF4CAF50),
      ),
      InventoryData(
        category: 'Home & Garden',
        value: 78500,
        items: 234,
        color: const Color(0xFFFF9800),
      ),
      InventoryData(
        category: 'Sports',
        value: 45200,
        items: 156,
        color: const Color(0xFF9C27B0),
      ),
      InventoryData(
        category: 'Books',
        value: 25220,
        items: 423,
        color: const Color(0xFFE91E63),
      ),
    ];
  }
}
