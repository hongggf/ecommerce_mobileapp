import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Mock Controller
class AdminAddProductController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final skuController = TextEditingController();
  final priceController = TextEditingController();
  
  var categories = <CategoryModel>[].obs;
  var selectedCategoryId = Rxn<int>();
  var selectedStatus = 'active'.obs;
  var isLoading = false.obs;
  var isCreatingCategory = false.obs;
  var isUploading = false.obs;
  var editingProductId = Rxn<int>();
  var editingVariantId = Rxn<int>();
  var selectedImages = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() {
    categories.value = [
      CategoryModel(id: 1, name: 'Electronics'),
      CategoryModel(id: 2, name: 'Clothing'),
      CategoryModel(id: 3, name: 'Home & Garden'),
    ];
    if (categories.isNotEmpty) {
      selectedCategoryId.value = categories.first.id;
    }
  }

  void createCategory(String name) async {
    isCreatingCategory.value = true;
    await Future.delayed(Duration(milliseconds: 500));
    categories.add(CategoryModel(id: categories.length + 1, name: name));
    Get.snackbar('Success', 'Category created successfully',
        backgroundColor: Colors.green, colorText: Colors.white);
    isCreatingCategory.value = false;
  }

  void createProduct() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    editingProductId.value = 123; // Mock product ID
    Get.snackbar('Success', 'Product created successfully',
        backgroundColor: Colors.green, colorText: Colors.white);
    isLoading.value = false;
  }

  void createVariant() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    editingVariantId.value = 456; // Mock variant ID
    Get.snackbar('Success', 'Variant created successfully',
        backgroundColor: Colors.green, colorText: Colors.white);
    isLoading.value = false;
  }

  void pickImages() {
    // Mock image selection
    selectedImages.add('mock_image_${selectedImages.length}');
    Get.snackbar('Images Selected', '${selectedImages.length} images selected');
  }

  void uploadImages() async {
    isUploading.value = true;
    await Future.delayed(Duration(seconds: 2));
    Get.snackbar('Success', 'Images uploaded successfully',
        backgroundColor: Colors.green, colorText: Colors.white);
    selectedImages.clear();
    isUploading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    skuController.dispose();
    priceController.dispose();
    super.onClose();
  }
}

class CategoryModel {
  final int id;
  final String name;
  CategoryModel({required this.id, required this.name});
}