import 'package:ecommerce_urban/modules/admin_products/model/product_varaint_model.dart';
import 'package:get/get.dart';
import '../model/product_model.dart';
import '../model/category_model.dart';

class AdminProductsController extends GetxController {
  // Reactive variables
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var products = <Product>[].obs;
  var categories = <Category>[].obs;
  var selectedCategoryId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
  }

  // Fetch categories (mock data)
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock categories
      categories.value = [
        Category(id: 1, name: 'Electronics'),
        Category(id: 2, name: 'Clothing'),
        Category(id: 3, name: 'Home & Garden'),
        Category(id: 4, name: 'Sports'),
        Category(id: 5, name: 'Books'),
      ];
      
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  // Fetch products (mock data)
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Mock products
      products.value = [
        Product(
          id: 1,
          name: 'Wireless Headphones',
          description: 'Premium noise-cancelling wireless headphones with 30-hour battery life and superior sound quality.',
          status: 'active',
          categoryId: 1,
          variants: [
            ProductVariant(id: 1, name: 'Black', sku: 'WH-001-BLK', price: 199.99, status: 'active'),
            ProductVariant(id: 2, name: 'White', sku: 'WH-001-WHT', price: 199.99, status: 'active'),
          ],
        ),
        Product(
          id: 2,
          name: 'Smart Watch Pro',
          description: 'Advanced fitness tracking, heart rate monitoring, and smartphone notifications in a sleek design.',
          status: 'active',
          categoryId: 1,
          variants: [
            ProductVariant(id: 3, name: '42mm', sku: 'SW-002-42', price: 349.99, status: 'active'),
            ProductVariant(id: 4, name: '46mm', sku: 'SW-002-46', price: 379.99, status: 'active'),
          ],
        ),
        Product(
          id: 3,
          name: 'Cotton T-Shirt',
          description: 'Comfortable 100% organic cotton t-shirt. Perfect for everyday wear with a classic fit.',
          status: 'active',
          categoryId: 2,
          variants: [
            ProductVariant(id: 5, name: 'Small', sku: 'TS-003-S', price: 29.99, status: 'active'),
            ProductVariant(id: 6, name: 'Medium', sku: 'TS-003-M', price: 29.99, status: 'active'),
            ProductVariant(id: 7, name: 'Large', sku: 'TS-003-L', price: 29.99, status: 'active'),
          ],
        ),
        Product(
          id: 4,
          name: 'Yoga Mat Premium',
          description: 'Extra thick, non-slip yoga mat with carrying strap. Eco-friendly materials for your practice.',
          status: 'active',
          categoryId: 4,
          variants: [
            ProductVariant(id: 8, name: 'Blue', sku: 'YM-004-BLU', price: 49.99, status: 'active'),
            ProductVariant(id: 9, name: 'Purple', sku: 'YM-004-PUR', price: 49.99, status: 'active'),
          ],
        ),
        Product(
          id: 5,
          name: 'Coffee Maker Deluxe',
          description: 'Programmable coffee maker with thermal carafe. Brew the perfect cup every morning.',
          status: 'inactive',
          categoryId: 3,
          variants: [
            ProductVariant(id: 10, name: 'Standard', sku: 'CM-005-STD', price: 89.99, status: 'inactive'),
          ],
        ),
      ];
      
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  // Select category filter
  void selectCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
  }

  // Get filtered products
  List<Product> getFilteredProducts() {
    if (selectedCategoryId.value == null) {
      return products;
    }
    return products.where((p) => p.categoryId == selectedCategoryId.value).toList();
  }

  // Delete product
  Future<void> deleteProduct(int productId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      products.removeWhere((p) => p.id == productId);
      
      Get.snackbar(
        'Success',
        'Product deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete product',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

