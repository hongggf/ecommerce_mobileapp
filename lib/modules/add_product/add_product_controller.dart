import 'dart:io';

import 'package:ecommerce_urban/modules/admin_products/admin_products_controller.dart';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_model.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_varaint_model.dart';
import 'package:ecommerce_urban/modules/admin_products/services/adminProductApiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddProductController extends GetxController {
  final apiService = Adminproductapiservice();
  final productManagementController = Get.put(ProductManagementController());

  final isLoading = false.obs;
  final isUploading = false.obs;

  var selectedImages = <File>[].obs;
  var categories = <dynamic>[].obs;

  final ImagePicker picker = ImagePicker();

  final editingProductId = Rx<int?>(null);
  final editingVariantId = Rx<int?>(null);

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController skuController;
  late TextEditingController priceController;

  final selectedCategoryId = Rx<int?>(null);
  final selectedStatus = 'active'.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    skuController = TextEditingController();
    priceController = TextEditingController();

    loadCategories();

    final args = Get.arguments;
    if (args != null && args is Product) {
      _initializeEditMode(args);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    skuController.dispose();
    priceController.dispose();
    super.onClose();
  }

  Future<void> loadCategories() async {
    try {
      final cats = await apiService.getCategories();
      categories.value = cats;
      print('✅ Categories loaded: ${categories.length}');
    } catch (e) {
      print('❌ Error loading categories: $e');
    }
  }

  void _initializeEditMode(Product product) {
    editingProductId.value = product.id;
    nameController.text = product.name;
    descriptionController.text = product.description;
    selectedStatus.value = product.status;
    selectedCategoryId.value = product.categoryId;
  }

  Future<void> pickImages() async {
    try {
      final picked = await picker.pickMultiImage();
      if (picked.isNotEmpty) {
        selectedImages.addAll(picked.map((e) => File(e.path)));
        print('✅ Picked ${picked.length} images');
      }
    } catch (e) {
      print('❌ Error picking images: $e');
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ==================== CREATE PRODUCT ====================
  Future<void> createProduct() async {
    print('\n🚀 ========== CREATE PRODUCT STARTED ==========');
    print('Form validation starting...');

    if (!_validateProduct()) {
      print('❌ Validation failed');
      return;
    }

    try {
      isLoading(true);
      print('✅ Validation passed');
      print('Name: ${nameController.text}');
      print('Description: ${descriptionController.text}');
      print('Category ID: ${selectedCategoryId.value}');
      print('Status: ${selectedStatus.value}');

      final product = Product(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        status: selectedStatus.value,
        categoryId: selectedCategoryId.value!,
      );

      print('\n📤 Product object created:');
      print('Name: ${product.name}');
      print('Description: ${product.description}');
      print('CategoryId: ${product.categoryId}');
      print('Status: ${product.status}');

      print('\n🌐 Calling API...');
      final createdProduct = await apiService.createProduct(product);

      print('\n📥 API Response received:');
      print('Response type: ${createdProduct.runtimeType}');
      print('Product ID: ${createdProduct.id}');
      print('Product Name: ${createdProduct.name}');

      if (createdProduct.id == null) {
        print('❌ ERROR: No ID returned from API');
        throw Exception('Product creation failed - no ID returned from API');
      }

      editingProductId.value = createdProduct.id;
      print('\n✅ Product created successfully!');
      print('Product ID set to: ${editingProductId.value}');

      Get.snackbar(
        'Success ✅',
        'Product ID ${editingProductId.value} created!\nNow create variant & upload images.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      // Refresh product list
      if (Get.isRegistered<AdminProductsController>()) {
        print('Refreshing product list...');
        await Get.find<AdminProductsController>().fetchProducts();
      }
    } catch (e) {
      print('\n❌ ========== PRODUCT CREATION FAILED ==========');
      print('Error: $e');
      print('Error Type: ${e.runtimeType}');
      print('Stack trace: $e');

      Get.snackbar(
        '❌ Error',
        'Failed to create product:\n$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading(false);
      print('\n========== CREATE PRODUCT ENDED ==========\n');
    }
  }

  // ==================== CREATE VARIANT ====================
  Future<void> createVariant() async {
    print('\n🚀 ========== CREATE VARIANT STARTED ==========');

    if (!_validateVariant()) {
      print('❌ Validation failed');
      return;
    }

    if (editingProductId.value == null) {
      print('❌ No product ID set');
      Get.snackbar(
        'Error',
        'Create product first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);
      print('Product ID: ${editingProductId.value}');
      print('SKU: ${skuController.text}');
      print('Price: ${priceController.text}');

      final variant = ProductVariant(
        productId: editingProductId.value,
        name: skuController.text.trim(),
        sku: skuController.text.trim(),
        price: double.parse(priceController.text.trim()),
        status: selectedStatus.value,
      );

      print('🌐 Calling API...');
      final createdVariant = await apiService.createProductVariant(variant);

      if (createdVariant.id == null) {
        throw Exception('Variant creation failed - no ID returned from API');
      }

      editingVariantId.value = createdVariant.id;
      print('✅ Variant created: ID ${editingVariantId.value}');

      Get.snackbar(
        'Success ✅',
        'Variant ID ${editingVariantId.value} created!\nNow upload images.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      skuController.clear();
      priceController.clear();
    } catch (e) {
      print('❌ Variant creation failed: $e');
      Get.snackbar(
        '❌ Error',
        'Failed to create variant:\n$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading(false);
      print('========== CREATE VARIANT ENDED ==========\n');
    }
  }

  // ==================== UPLOAD IMAGES ====================
  Future<void> uploadImages() async {
    print('\n🚀 ========== UPLOAD IMAGES STARTED ==========');

    if (selectedImages.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select images first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (editingProductId.value == null) {
      Get.snackbar(
        'Error',
        'Create product first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (editingVariantId.value == null) {
      Get.snackbar(
        'Error',
        'Create variant first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isUploading(true);
      print('Images to upload: ${selectedImages.length}');
      print('Product ID: ${editingProductId.value}');
      print('Variant ID: ${editingVariantId.value}');

      for (int i = 0; i < selectedImages.length; i++) {
        print('\n📤 Uploading image ${i + 1}/${selectedImages.length}...');

        await apiService.uploadProductAsset(
          selectedImages[i],
          editingProductId.value!,
          editingVariantId.value!,
          isPrimary: i == 0,
        );
      }

      print('\n✅ All images uploaded successfully');
      selectedImages.clear();

      Get.snackbar(
        'Success ✅',
        'Images uploaded successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } catch (e) {
      print('❌ Upload failed: $e');
      Get.snackbar(
        '❌ Error',
        'Upload failed:\n$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isUploading(false);
      print('========== UPLOAD IMAGES ENDED ==========\n');
    }
  }

  // ==================== VALIDATION ====================
  bool _validateProduct() {
    print('\n🔍 Validating product...');

    if (nameController.text.trim().isEmpty) {
      print('❌ Name is empty');
      Get.snackbar('Error', 'Product name is required',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      print('❌ Description is empty');
      Get.snackbar('Error', 'Product description is required',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }

    if (selectedCategoryId.value == null) {
      print('❌ Category not selected');
      Get.snackbar('Error', 'Please select a category',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }

    print('✅ All validations passed');
    return true;
  }

  bool _validateVariant() {
    print('\n🔍 Validating variant...');

    if (skuController.text.trim().isEmpty) {
      print('❌ SKU is empty');
      Get.snackbar('Error', 'SKU is required',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }

    if (priceController.text.trim().isEmpty) {
      print('❌ Price is empty');
      Get.snackbar('Error', 'Price is required',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }

    try {
      double.parse(priceController.text.trim());
      print('✅ Price is valid: ${priceController.text.trim()}');
    } catch (e) {
      print('❌ Price is not a number');
      Get.snackbar('Error', 'Price must be a valid number',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }

    print('✅ All variant validations passed');
    return true;
  }
}
