class DashboardModel {
  final Totals totals;
  final WeeklySales weeklySales;
  final List<Product> lowStockProducts;
  final List<User> topNewUsers;
  final User currentUser;

  DashboardModel({
    required this.totals,
    required this.weeklySales,
    required this.lowStockProducts,
    required this.topNewUsers,
    required this.currentUser,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totals: Totals.fromJson(json['totals']),
      weeklySales: WeeklySales.fromJson(json['weekly_sales']),
      lowStockProducts: List<Product>.from(
          json['low_stock_products'].map((x) => Product.fromJson(x))),
      topNewUsers: List<User>.from(
          json['top_new_users'].map((x) => User.fromJson(x))),
      currentUser: User.fromJson(json['current_user']), // Parse current_user
    );
  }
}

class Totals {
  final int totalOrders;
  final int totalSales;
  final int totalCustomers;
  final int totalProducts;

  Totals({
    required this.totalOrders,
    required this.totalSales,
    required this.totalCustomers,
    required this.totalProducts,
  });

  factory Totals.fromJson(Map<String, dynamic> json) => Totals(
    totalOrders: json['total_orders'],
    totalSales: json['total_sales'],
    totalCustomers: json['total_customers'],
    totalProducts: json['total_products'],
  );
}

class WeeklySales {
  final List<int> salesSummary;
  final List<String> days;

  WeeklySales({required this.salesSummary, required this.days});

  factory WeeklySales.fromJson(Map<String, dynamic> json) => WeeklySales(
    salesSummary: List<int>.from(json['salesSummary']),
    days: List<String>.from(json['days']),
  );
}

// Product model for low stock products
class Product {
  final int id;
  final String name;
  final String image;
  final int stockQuantity;
  final int lowStockAlert;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.stockQuantity,
    required this.lowStockAlert,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    image: json['image'] ?? '',
    stockQuantity: json['stock_quantity'],
    lowStockAlert: json['low_stock_alert'],
  );
}

// User model for top new users
class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: json['role'],
    avatar: json['avatar']
  );
}