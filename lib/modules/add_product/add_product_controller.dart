import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:ecommerce_urban/modules/admin_products/services/adminProductApiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../admin_products/model/product_asset.dart';
import '../admin_products/model/product_model.dart';

class AdminAddProductController extends GetxController {
  final apiService = Adminproductapiservice();

  final isLoading = false.obs;
  final isUploading = false.obs;

  var selectedImages = <File>[].obs;
  var uploadedAssets = <ProductAsset>[].obs;
  var categories = <dynamic>[].obs;

  final ImagePicker picker = ImagePicker();

  int? editingProductId;
  int? editingVariantId;

  // Controllers
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController skuController;
  late TextEditingController priceController;

  int? selectedCategoryId;
  String selectedStatus = "active";

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
      editingProductId = args.id;
      nameController.text = args.name;
      descriptionController.text = args.description;
      selectedStatus = args.status;
      selectedCategoryId = args.categoryId;

      if (args.id != null) {
        loadExistingAssets(args.id!);
      }
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

  // ==================== LOAD CATEGORIES ====================
  Future<void> loadCategories() async {
    try {
      final cats = await apiService.getCategories();
      categories.value = cats;
      print('✅ Categories loaded: ${categories.length}');
    } catch (e) {
      print('❌ Error loading categories: $e');
    }
  }

  // ==================== LOAD EXISTING ASSETS ====================
  Future<void> loadExistingAssets(int productId) async {
    try {
      isLoading(true);
      final assets = await apiService.getProductAssets(productId);
      uploadedAssets.value = assets;
      print('✅ Existing assets loaded: ${assets.length}');
    } catch (e) {
      print('❌ Error loading existing assets: $e');
    } finally {
      isLoading(false);
    }
  }

  // ==================== PICK IMAGES ====================
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

  // ==================== UPLOAD IMAGES ====================
  Future<void> uploadImages() async {
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

    if (editingProductId == null) {
      Get.snackbar(
        'Error',
        'Create product first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (editingVariantId == null) {
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

      for (int i = 0; i < selectedImages.length; i++) {
        print('📤 Uploading image ${i + 1}/${selectedImages.length}...');
        
        await apiService.uploadProductAsset(
          selectedImages[i],
          editingProductId!,
          editingVariantId!,
          isPrimary: i == 0 && uploadedAssets.isEmpty,
        );
      }

      print('✅ All images uploaded');
      selectedImages.clear();
      
      if (editingVariantId != null) {
        await loadExistingAssets(editingProductId!);
      }

      Get.snackbar(
        'Success',
        'Images uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Upload failed: $e');
      Get.snackbar(
        'Error',
        'Upload failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading(false);
    }
  }

  // ==================== DELETE IMAGE ====================
  Future<void> deleteImage(int assetId) async {
    try {
      isLoading(true);
      print('🗑️ Deleting asset: $assetId');
      
      await apiService.deleteProductAsset(assetId);

      if (editingProductId != null) {
        await loadExistingAssets(editingProductId!);
      }

      Get.snackbar(
        'Success',
        'Image deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Failed to delete image: $e');
      Get.snackbar(
        'Error',
        'Failed to delete: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // ==================== SUBMIT (CREATE / UPDATE PRODUCT) ====================
  Future<void> submit() async {
    // Validation
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Product name is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Product description is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedCategoryId == null) {
      Get.snackbar(
        'Error',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      final product = Product(
        id: editingProductId,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        status: selectedStatus,
        categoryId: selectedCategoryId!,
      );

      if (editingProductId == null) {
        print('➕ Creating product: ${product.name}');
        await apiService.createProduct(product);
        Get.snackbar(
          'Success',
          'Product created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print('🔄 Updating product: ${product.name}');
        await apiService.updateProduct(editingProductId!, product);
        Get.snackbar(
          'Success',
          'Product updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      Get.back();
    } catch (e) {
      print('❌ Submit failed: $e');
      Get.snackbar(
        'Error',
        'Failed to save product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // ==================== UTILITY: BASE64 DECODER ====================
  Uint8List decodeBase64(String base64String) {
    try {
      final parts = base64String.split(',');
      final base = parts.length > 1 ? parts[1] : parts[0];
      return Uint8List.fromList(base64Decode(base.replaceAll('\n', '')));
    } catch (e) {
      print('❌ Error decoding base64: $e');
      return Uint8List(0);
    }
  }
}