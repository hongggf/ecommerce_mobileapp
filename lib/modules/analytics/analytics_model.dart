import 'package:flutter/material.dart';

class SalesData {
  final String date;
  final double amount;
  final int orders;

  SalesData({
    required this.date,
    required this.amount,
    required this.orders,
  });
}

class TopProduct {
  final String id;
  final String name;
  final String imageUrl;
  final int unitsSold;
  final double revenue;
  final double percentage;

  TopProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.unitsSold,
    required this.revenue,
    required this.percentage,
  });
}

class InventoryData {
  final String category;
  final double value;
  final int items;
  final Color color;

  InventoryData({
    required this.category,
    required this.value,
    required this.items,
    required this.color,
  });
}

class AnalyticsOverview {
  final double totalSales;
  final double growthPercentage;
  final int totalOrders;
  final int ordersGrowth;
  final double averageOrderValue;
  final double inventoryValue;

  AnalyticsOverview({
    required this.totalSales,
    required this.growthPercentage,
    required this.totalOrders,
    required this.ordersGrowth,
    required this.averageOrderValue,
    required this.inventoryValue,
  });
}
