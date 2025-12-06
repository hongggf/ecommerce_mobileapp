import 'dart:io';
import 'package:ecommerce_urban/modules/admin_products/model/category_model.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_asset.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_model.dart';
import 'package:ecommerce_urban/modules/admin_products/model/product_varaint_model.dart';
import 'package:ecommerce_urban/modules/admin_products/services/adminProductApiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductManagementController extends GetxController {
  final apiService = Adminproductapiservice();

  // Product State
  final product = Rx<Product?>(null);
  final productName = RxString('');
  final productDescription = RxString('');
  final selectedCategoryId = RxnInt();
  final productStatus = RxString('active');

  // Variants State
  final variants = RxList<ProductVariant>([]);
  final selectedVariant = Rx<ProductVariant?>(null);
  final variantName = RxString('');
  final variantSku = RxString('');
  final variantPrice = RxString('');
  final variantStatus = RxString('active');

  // Assets State
  final assets = RxList<ProductAsset>([]);
  final selectedAsset = Rx<ProductAsset?>(null);

  // UI State
  final isLoading = RxBool(false);
  final isLoadingVariants = RxBool(false);
  final isLoadingAssets = RxBool(false);
  final isUploading = RxBool(false);
  final categories = RxList<Category>([]);
  final errorMessage = RxString('');
  final currentStep = RxInt(0);
  final showVariantForm = RxBool(false);
  final showAssetForm = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Product) {
      _initializeWithProduct(args);
    } else {
      _loadCategories();
    }
  }

  // ==================== INITIALIZATION ====================
  Future<void> _initializeWithProduct(Product productData) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      product.value = productData;
      productName.value = productData.name;
      productDescription.value = productData.description;
      selectedCategoryId.value = productData.categoryId;
      productStatus.value = productData.status;

      await _loadCategories();
      if (productData.id != null) {
        await _loadVariants(productData.id!);
      }
    } catch (e) {
      errorMessage.value = 'Failed to initialize: $e';
      print('❌ Error initializing: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCategories() async {
    try {
      final fetchedCategories = await apiService.getCategories();
      categories.value = fetchedCategories;
      print('✅ Categories loaded: ${categories.length}');
    } catch (e) {
      errorMessage.value = 'Failed to load categories: $e';
      print('❌ Error loading categories: $e');
    }
  }

  // ==================== PRODUCT MANAGEMENT ====================
  Future<void> saveProduct() async {
    if (!_validateProduct()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final newProduct = Product(
        id: product.value?.id,
        name: productName.value.trim(),
        description: productDescription.value.trim(),
        status: productStatus.value,
        categoryId: selectedCategoryId.value!,
      );

      if (product.value?.id != null) {
        await apiService.updateProduct(product.value!.id!, newProduct);
        print('✅ Product updated');
        Get.snackbar('Success', 'Product updated',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        final created = await apiService.createProduct(newProduct);
        product.value = created;
        print('✅ Product created with ID: ${created.id}');
        Get.snackbar('Success', 'Product created',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      }

      if (product.value?.id != null) {
        print('📋 Product ID exists: ${product.value!.id}');
        currentStep.value = 1;
        await _loadVariants(product.value!.id!);
      } else {
        print('❌ ERROR: Product has no ID!');
        Get.snackbar('Error', 'Product was not saved properly');
        return;
      }
    } catch (e) {
      print('❌ Error saving product: $e');
      Get.snackbar('Error', 'Failed to save product: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct() async {
    if (product.value?.id == null) return;

    try {
      isLoading.value = true;
      await apiService.deleteProduct(product.value!.id!);
      print('✅ Product deleted');
      Get.back();
      Get.snackbar('Success', 'Product deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      print('❌ Error deleting product: $e');
      Get.snackbar('Error', 'Failed to delete product: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateProduct() {
    if (productName.value.trim().isEmpty) {
      _showError('Product name is required');
      return false;
    }
    if (productDescription.value.trim().isEmpty) {
      _showError('Product description is required');
      return false;
    }
    if (selectedCategoryId.value == null) {
      _showError('Please select a category');
      return false;
    }
    return true;
  }

  // ==================== VARIANT MANAGEMENT ====================
  Future<void> _loadVariants(int productId) async {
    try {
      isLoadingVariants.value = true;
      print('📋 Loading variants for product $productId...');

      final allVariants = await apiService.getProductVariants(productId);
      print('✅ API returned ${allVariants.length} total variants');

      // Filter to only this product's variants
      final filtered =
          allVariants.where((v) => v.productId == productId).toList();
      print('📊 Filtered to product $productId: ${filtered.length} variants');

      variants.value = filtered;

      if (filtered.isNotEmpty) {
        filtered.forEach((v) {
          print('   ✓ ${v.name} (ID: ${v.id}, ProductID: ${v.productId}, SKU: ${v.sku})');
        });
      } else {
        print('⚠️ No variants found for product $productId');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load variants: $e';
      print('❌ Error loading variants: $e');
      variants.value = [];
    } finally {
      isLoadingVariants.value = false;
    }
  }

  void openVariantForm([ProductVariant? variant]) {
    if (variant != null) {
      selectedVariant.value = variant;
      variantName.value = variant.name;
      variantSku.value = variant.sku;
      variantPrice.value = variant.price.toString();
      variantStatus.value = variant.status;
    } else {
      _resetVariantForm();
    }
    showVariantForm.value = true;
  }

  void closeVariantForm() {
    _resetVariantForm();
    showVariantForm.value = false;
  }

  void _resetVariantForm() {
    selectedVariant.value = null;
    variantName.value = '';
    variantSku.value = '';
    variantPrice.value = '';
    variantStatus.value = 'active';
  }

  Future<void> saveVariant() async {
    if (!_validateVariant()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('\n🔍 ===== SAVING VARIANT =====');
      print('Product ID: ${product.value?.id}');
      print('Variant Name: ${variantName.value}');
      print('Variant SKU: ${variantSku.value}');
      print('Variant Price: ${variantPrice.value}');

      final variant = ProductVariant(
        id: selectedVariant.value?.id,
        productId: product.value?.id,
        name: variantName.value.trim(),
        sku: variantSku.value.trim(),
        price: double.parse(variantPrice.value.trim()),
        status: variantStatus.value,
      );

      if (selectedVariant.value?.id != null) {
        print('🔄 Updating variant ID: ${selectedVariant.value!.id}');
        await apiService.updateProductVariant(
            selectedVariant.value!.id!, variant);
        print('✅ Variant updated');
        Get.snackbar('Success', 'Variant updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        print('➕ Creating new variant...');
        final created = await apiService.createProductVariant(variant);
        print('✅ Variant created with ID: ${created.id}');
        Get.snackbar('Success', 'Variant created successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      }

      closeVariantForm();

      // Wait a bit for DB to update
      await Future.delayed(const Duration(milliseconds: 500));

      // Reload variants - THIS IS KEY
      if (product.value?.id != null) {
        print('📋 Reloading variants...');
        await _loadVariants(product.value!.id!);
        
        if (variants.isNotEmpty) {
          print('✅ Variants reloaded: ${variants.length} total');
          
          // Auto-select the newly created/updated variant
          ProductVariant? savedVariant;
          if (selectedVariant.value?.id != null) {
            // Updated variant - find by ID
            savedVariant = variants.firstWhereOrNull(
              (v) => v.id == selectedVariant.value?.id,
            );
            print('🔍 Looking for updated variant ID: ${selectedVariant.value?.id}');
          } else {
            // New variant - select the last one (most recently created)
            savedVariant = variants.last;
            print('🔍 New variant created - selecting last one: ${savedVariant.name}');
          }

          if (savedVariant != null) {
            print('🎯 Auto-selecting variant: ${savedVariant.name} (ID: ${savedVariant.id})');
            selectedVariant.value = savedVariant;
          }
        } else {
          print('⚠️ WARNING: Variants list is empty after reload!');
        }
      }

      print('============================\n');
    } catch (e) {
      print('❌ Error saving variant: $e');

      String errorMsg = 'Failed to save variant';

      if (e.toString().contains('SKU has already been used')) {
        errorMsg =
            '❌ SKU Error: This SKU has already been used.\n\nPlease use a different SKU.';
      } else if (e.toString().contains('SKU')) {
        errorMsg = '❌ SKU Error: ${e.toString()}';
      } else if (e.toString().contains('price')) {
        errorMsg = '❌ Price Error: Please enter a valid price.';
      } else if (e.toString().contains('name')) {
        errorMsg = '❌ Name Error: Variant name is required.';
      }

      Get.snackbar('Error', errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteVariant(ProductVariant variant) async {
    if (variant.id == null) return;

    try {
      isLoading.value = true;
      await apiService.deleteProductVariant(variant.id!);
      print('✅ Variant deleted');

      if (product.value?.id != null) {
        await _loadVariants(product.value!.id!);
      }
      Get.snackbar('Success', 'Variant deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      print('❌ Error deleting variant: $e');
      Get.snackbar('Error', 'Failed to delete variant: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateVariant() {
    if (variantName.value.trim().isEmpty) {
      _showError('Variant name is required');
      return false;
    }
    if (variantSku.value.trim().isEmpty) {
      _showError('SKU is required');
      return false;
    }
    if (variantPrice.value.trim().isEmpty) {
      _showError('Price is required');
      return false;
    }
    try {
      double.parse(variantPrice.value.trim());
    } catch (e) {
      _showError('Price must be a valid number');
      return false;
    }
    return true;
  }

  // ==================== ASSET MANAGEMENT ====================
  Future<void> loadAssets(int variantId) async {
    try {
      isLoadingAssets.value = true;
      
      // Use product ID, not variant ID
      if (product.value?.id == null) {
        print('⚠️ No product ID available');
        assets.value = [];
        return;
      }
      
      print('🖼️ Loading assets for product ${product.value!.id}...');
      final fetchedAssets = await apiService.getProductAssets(product.value!.id!);
      assets.value = fetchedAssets;
      print('✅ Assets loaded: ${assets.length}');
    } catch (e) {
      errorMessage.value = 'Failed to load assets: $e';
      print('❌ Error loading assets: $e');
      assets.value = [];
    } finally {
      isLoadingAssets.value = false;
    }
  }

  void selectVariantForAssets(ProductVariant variant) {
    selectedVariant.value = variant;
    currentStep.value = 2;
    // Load assets for the product, not variant
    if (product.value?.id != null) {
      loadAssets(product.value!.id!);
    }
  }

  void closeAssetForm() {
    showAssetForm.value = false;
  }

  Future<void> uploadAsset(File imageFile, {bool isPrimary = false}) async {
    if (selectedVariant.value?.id == null || product.value?.id == null) return;

    try {
      isUploading.value = true;

      await apiService.uploadProductAsset(
        imageFile,
        product.value!.id!,
        selectedVariant.value!.id!,
        isPrimary: isPrimary,
      );
      print('✅ Asset uploaded');
      Get.snackbar('Success', 'Image uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      // Load assets using product ID
      if (product.value?.id != null) {
        await loadAssets(product.value!.id!);
      }
    } catch (e) {
      print('❌ Error uploading asset: $e');
      Get.snackbar('Error', 'Failed to upload image: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> deleteAsset(ProductAsset asset) async {
    if (asset.id == null) return;

    try {
      isLoading.value = true;
      await apiService.deleteProductAsset(asset.id!);
      print('✅ Asset deleted');

      // Reload using product ID
      if (product.value?.id != null) {
        await loadAssets(product.value!.id!);
      }
      Get.snackbar('Success', 'Image deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      print('❌ Error deleting asset: $e');
      Get.snackbar('Error', 'Failed to delete image: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== UTILITIES ====================
  void _showError(String message) {
    Get.snackbar(
      'Validation Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void nextStep() {
    currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    currentStep.value = step;
  }

  @override
  void onClose() {
    productName.close();
    productDescription.close();
    selectedCategoryId.close();
    productStatus.close();
    variantName.close();
    variantSku.close();
    variantPrice.close();
    variantStatus.close();
    variants.close();
    assets.close();
    categories.close();
    isLoading.close();
    isLoadingVariants.close();
    isLoadingAssets.close();
    isUploading.close();
    errorMessage.close();
    currentStep.close();
    showVariantForm.close();
    showAssetForm.close();
    super.onClose();
  }
}