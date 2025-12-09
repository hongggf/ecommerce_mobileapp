// lib/modules/dashboard/customer/customer_controller.dart

import 'package:ecommerce_urban/app/model/category_model.dart';
import 'package:ecommerce_urban/app/model/product_model.dart';
import 'package:ecommerce_urban/app/repositories/category_repository.dart';
import 'package:ecommerce_urban/app/repositories/product_repository.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  final CategoryRepository _categoryRepo = CategoryRepository();
  final ProductRepository _productRepo = ProductRepository();

  // Observable variables
  final isLoading = false.obs;
  final isCategoriesLoading = false.obs;
  final isProductsLoading = false.obs;
  
  final categories = <CategoryModel>[].obs;
  final popularProducts = <ProductModel>[].obs;
  final selectedCategoryIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  // Load all dashboard data
  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadCategories(),
        loadPopularProducts(),
      ]);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    isCategoriesLoading.value = true;
    try {
      final result = await _categoryRepo.getCategories();
      categories.value = result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load categories: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  // Load popular products
  Future<void> loadPopularProducts() async {
    isProductsLoading.value = true;
    try {
      final result = await _productRepo.getPopularProducts(limit: 10);
      popularProducts.value = result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load popular products: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProductsLoading.value = false;
    }
  }

  // Handle category tap
  void onCategoryTap(int index) {
    selectedCategoryIndex.value = index;
    // Navigate to product list with category filter
    if (index < categories.length) {
      Get.toNamed('/product', arguments: {
        'categoryId': categories[index].id,
        'categoryName': categories[index].name,
      });
    }
  }

  // Navigate to product detail
  void goToProductDetail(ProductModel product) {
    Get.toNamed('/product_detail', arguments: {
      'productId': product.id,
      'product': product,
    });
  }

  // Refresh dashboard
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }
}