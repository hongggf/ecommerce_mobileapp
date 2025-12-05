import 'package:ecommerce_urban/modules/admin_products/services/adminProductApiService.dart';
import 'package:get/get.dart';

import 'model/category_model.dart';
import 'model/product_model.dart';

class AdminProductsController extends GetxController {
  final Adminproductapiservice apiService = Adminproductapiservice();

  var products = <Product>[].obs;
  var categories = <Category>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      categories.value = await apiService.getCategories();
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      products.value = await apiService.getProducts();
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createProduct(Product product) async {
    try {
      isLoading.value = true;
      await apiService.createProduct(product);
      await fetchProducts();
      Get.back();
      Get.snackbar('Success', 'Product created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(int id, Product product) async {
    try {
      isLoading.value = true;
      await apiService.updateProduct(id, product);
      await fetchProducts();
      Get.back();
      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      isLoading.value = true;
      await apiService.deleteProduct(id);
      await fetchProducts();
      Get.snackbar('Success', 'Product deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    } finally {
      isLoading.value = false;
    }
  }
}