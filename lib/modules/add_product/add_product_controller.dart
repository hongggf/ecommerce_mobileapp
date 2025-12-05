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

  final ImagePicker picker = ImagePicker();

  int? editingProductId;

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

    final args = Get.arguments;
    if (args != null && args is Product) {
      editingProductId = args.id;

      nameController.text = args.name;
      descriptionController.text = args.description;
      selectedStatus = args.status;
      selectedCategoryId = args.categoryId;

      loadExistingAssets(args.id!);
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

  /// LOAD EXISTING UPLOADED IMAGES
  Future<void> loadExistingAssets(int id) async {
    try {
      final assets = await apiService.getProductAssets(id);
      uploadedAssets.value = assets;
    } catch (e) {
      print("Error loadExistingAssets: $e");
    }
  }

  /// PICK MULTIPLE IMAGES
  Future<void> pickImages() async {
    try {
      final picked = await picker.pickMultiImage();
      if (picked.isNotEmpty) {
        selectedImages.addAll(picked.map((e) => File(e.path)));
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick images: $e");
    }
  }

  /// UPLOAD IMAGES
  Future<void> uploadImages() async {
    if (selectedImages.isEmpty) {
      Get.snackbar("Error", "Please select images first");
      return;
    }
    if (editingProductId == null) {
      Get.snackbar("Error", "Create product first");
      return;
    }

    try {
      isUploading(true);

      for (int i = 0; i < selectedImages.length; i++) {
        await apiService.uploadProductAsset(
          selectedImages[i],
          editingProductId!,
          isPrimary: i == 0 && uploadedAssets.isEmpty,
        );
      }

      selectedImages.clear();
      await loadExistingAssets(editingProductId!);

      Get.snackbar("Success", "Images uploaded");
    } catch (e) {
      Get.snackbar("Error", "Upload failed: $e");
    } finally {
      isUploading(false);
    }
  }

  /// DELETE IMAGE
  Future<void> deleteImage(int assetId) async {
    try {
      await apiService.deleteProductAsset(assetId);
      await loadExistingAssets(editingProductId!);
      Get.snackbar("Success", "Image deleted");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete: $e");
    }
  }

  /// SUBMIT (CREATE / UPDATE PRODUCT)
  void submit() {
    final product = Product(
      id: editingProductId,
      name: nameController.text,
      description: descriptionController.text,
      status: selectedStatus,
      categoryId: selectedCategoryId!,
    );

    if (editingProductId == null) {
      apiService.createProduct(product);
    } else {
      apiService.updateProduct(editingProductId!, product);
    }
  }

  /// BASE64 DECODER (for UI)
 Uint8List decodeBase64(String base64String) {
  final parts = base64String.split(',');
  final base = parts.length > 1 ? parts[1] : parts[0];
  return Uint8List.fromList(base64Decode(base.replaceAll('\n', '')));
}
}
