class AppConstant {
  static const String baseUrl = "http://localhost:8085";

  // Auth
  static const String login = "/api/login";
  static const String register = "/api/register";
  static const String logout = "/api/logout";

  // Category
  static const String categories = "/api/categories"; // GET, POST
  static String categoryById(int id) => "/api/categories/$id"; // PUT, DELETE

  // Product
  static const String products = "/api/products"; // GET, POST
  static String productById(int id) => "/api/products/$id"; // PUT, DELETE
  static const String availableProducts = "/api/products/available"; // Available Products

  // Dashboard
  static const String dashboard = "/api/dashboard"; // GET

  // User Profile (ME)
  static const String me = "/api/me"; // GET
  static const String meUpdate = "/api/me/update"; // POST (multipart)

  // Reports
  static const String topSellingProducts = "/api/reports/products/top-selling";
  static const String leastSellingProducts = "/api/reports/products/least-selling";
  static const String productRevenue = "/api/reports/products/revenue";
  static const String stockLevel = "/api/reports/products/stock";
  static const String productDistribution = "/api/reports/products/distribution";
  static String productSalesByPeriod(String period) => "/api/reports/products/sales?period=$period";

  // Add inside AppConstant
  static const String cartItems = "/api/cart-items";
  static String cartItemById(int id) => "/api/cart-items/$id";

}