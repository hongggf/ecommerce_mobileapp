import 'package:ecommerce_urban/api/service/dashboard_service.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/api/service/category_service.dart';
import 'package:ecommerce_urban/api/service/product_service.dart';
import 'package:ecommerce_urban/api/model/category_model.dart';
import 'package:ecommerce_urban/api/model/product_model.dart';

import '../../../api/model/dashboard_model.dart';

class UserHomeController extends GetxController {
  final DashboardService _service = DashboardService();
  final CategoryService _categoryService = CategoryService();
  final ProductService _productService = ProductService();

  var categories = <CategoryData>[].obs;
  var products = <ProductModel>[].obs;

  var isCategoryLoading = false.obs;
  var isProductLoading = false.obs;

  var selectedCategoryId = Rx<int?>(null);

  var currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    selectedCategoryId.value = null;
    fetchProductsByCategory(null);
    fetchCategories();
    fetchDashboard();
  }

  void fetchDashboard() async {
    try {
      final dashboard = await _service.fetchDashboard();
      currentUser.value = dashboard.currentUser;
    } catch (e) {
      ToastWidget.show(message: "Failed to fetch dashboard data: $e");
    } finally {
    }
  }

  /// Fetch all categories
  Future<void> fetchCategories() async {
    try {
      isCategoryLoading.value = true;
      categories.value = await _categoryService.getCategories();
    } catch (e) {
      Get.snackbar("Error", "Failed to load categories");
    } finally {
      isCategoryLoading.value = false;
    }
  }

  /// Fetch products by category
  Future<void> fetchProductsByCategory([int? categoryId]) async {
    try {

      selectedCategoryId.value = categoryId;

      isProductLoading.value = true;

      products.value = await _productService.getAvailableProducts(
        categoryId: categoryId,
        page: 1,
        perPage: 10,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load products",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProductLoading.value = false;
    }
  }

}