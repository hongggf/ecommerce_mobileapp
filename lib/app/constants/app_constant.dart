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
}