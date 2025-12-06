import 'package:ecommerce_urban/modules/admin_products/services/adminProductApiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'model/category_model.dart';
import 'model/product_model.dart';

class AdminProductsController extends GetxController {
  final Adminproductapiservice apiService = Adminproductapiservice();

  var products = <Product>[].obs;
  var categories = <Category>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedCategoryId = Rx<int?>(null); // Track selected category

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // Fetch both categories and products
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await Future.wait([
        fetchCategories(),
        fetchProducts(),
      ]);
    } catch (e) {
      errorMessage.value = 'Failed to load data: $e';
      print('❌ Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await apiService.getCategories();
      categories.value = fetchedCategories;
      print('✅ Categories loaded: ${categories.length}');
    } catch (e) {
      print('❌ Error fetching categories: $e');
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await apiService.getProducts();
      products.value = fetchedProducts;
      print('✅ Products loaded: ${products.length}');
    } catch (e) {
      print('❌ Error fetching products: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Select a category and filter products
  void selectCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    print('📁 Selected category: $categoryId');
  }

  // Get filtered products based on selected category
  List<Product> getFilteredProducts() {
    if (selectedCategoryId.value == null) {
      return products;
    }
    
    return products
        .where((product) => product.categoryId == selectedCategoryId.value)
        .toList();
  }

  // Create product
  Future<void> createProduct(Product product) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await apiService.createProduct(product);
      print('✅ Product created: ${product.name}');
      
      await fetchProducts();
      Get.back();
      Get.snackbar(
        'Success',
        'Product created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Error creating product: $e');
      Get.snackbar(
        'Error',
        'Failed to create product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update product
  Future<void> updateProduct(int id, Product product) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await apiService.updateProduct(id, product);
      print('✅ Product updated: ${product.name}');
      
      await fetchProducts();
      Get.back();
      Get.snackbar(
        'Success',
        'Product updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Error updating product: $e');
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Delete product
  Future<void> deleteProduct(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await apiService.deleteProduct(id);
      print('✅ Product deleted: $id');
      
      await fetchProducts();
      Get.snackbar(
        'Success',
        'Product deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Error deleting product: $e');
      Get.snackbar(
        'Error',
        'Failed to delete product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}