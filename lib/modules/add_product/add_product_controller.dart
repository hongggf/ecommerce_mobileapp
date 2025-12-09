import 'dart:io';

import 'package:ecommerce_urban/modules/admin_products/admin_products_controller.dart';
import 'package:ecommerce_urban/modules/admin_products/controller/product_mangement_controller.dart';
import 'package:ecommerce_urban/modules/admin_products/model/category_model.dart';
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
  final isCreatingCategory = false.obs;

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
  final selectedStatus = 'active'.obs; // Changed from 'active' to match backend

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

  // ==================== CREATE CATEGORY ====================
  Future<void> createCategory(String categoryName) async {
    print('\n🚀 ========== CREATE CATEGORY STARTED ==========');
    print('Category name: $categoryName');

    if (categoryName.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Category name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isCreatingCategory(true);

      final trimmedName = categoryName.trim();
      final slug = _generateSlug(trimmedName);

      final category = Category(
        name: trimmedName,
        slug: slug,
        position: 0,
      );

      print('📤 Creating category: ${category.name}');
      print('   Slug: ${category.slug}');
      final createdCategory = await apiService.createCategory(category);

      if (createdCategory.id == null) {
        throw Exception('Category creation failed - no ID returned');
      }

      // Reload categories
      await loadCategories();

      // Auto-select the newly created category
      selectedCategoryId.value = createdCategory.id;

      print('✅ Category created successfully!');
      print('Category ID: ${createdCategory.id}');
      print('Category Name: ${createdCategory.name}');

      Get.snackbar(
        'Success ✅',
        'Category "${createdCategory.name}" created and selected!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('❌ Category creation failed: $e');
      Get.snackbar(
        'Error ❌',
        'Failed to create category:\n$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isCreatingCategory(false);
      print('========== CREATE CATEGORY ENDED ==========\n');
    }
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

    if (!_validateProduct()) {
      print('❌ Validation failed');
      return;
    }

    try {
      isLoading(true);
      
      // FIXED: Ensure category_id is properly set
      if (selectedCategoryId.value == null) {
        throw Exception('Category ID is null - this should not happen after validation');
      }

      final productData = {
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'category_id': selectedCategoryId.value!,
        'status': selectedStatus.value,
      };

      print('📤 Creating product with data:');
      print('   Name: ${productData['name']}');
      print('   Description: ${productData['description']}');
      print('   Category ID: ${productData['category_id']}');
      print('   Status: ${productData['status']}');

      final product = Product(
        name: productData['name'] as String,
        description: productData['description'] as String,
        categoryId: productData['category_id'] as int,
        status: productData['status'] as String,
      );

      print('\n🌐 Calling API to create product...');
      print('📦 Product payload: ${product.toJson()}');
      
      final createdProduct = await apiService.createProduct(product);

      print('\n✅ Product created successfully!');
      print('   ID: ${createdProduct.id}');
      print('   Name: ${createdProduct.name}');
      print('   Status: ${createdProduct.status}');

      if (createdProduct.id == null) {
        throw Exception('Product creation failed - no ID returned from API');
      }

      editingProductId.value = createdProduct.id;

      Get.snackbar(
        'Success ✅',
        'Product created! ID: ${editingProductId.value}\nNow add a variant.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Refresh the product list
      print('\n🔄 Refreshing product list...');
      if (Get.isRegistered<AdminProductsController>()) {
        await Get.find<AdminProductsController>().fetchProducts();
        print('✅ Product list refreshed');
      } else {
        print('⚠️ AdminProductsController not registered, will refresh on next visit');
      }
    } catch (e, stackTrace) {
      print('\n❌ PRODUCT CREATION FAILED');
      print('Error: $e');
      print('Stack trace: $stackTrace');

      Get.snackbar(
        'Error ❌',
        'Failed to create product:\n$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading(false);
      print('========== CREATE PRODUCT ENDED ==========\n');
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
      print('   Available categories: ${categories.length}');
      Get.snackbar('Error', 'Please select a category',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return false;
    }

    print('✅ All validations passed');
    print('   Name: ${nameController.text.trim()}');
    print('   Description: ${descriptionController.text.trim()}');
    print('   Category ID: ${selectedCategoryId.value}');
    print('   Status: ${selectedStatus.value}');
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

  // ==================== HELPER: SLUG GENERATION ====================
  String _generateSlug(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[-\s]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}