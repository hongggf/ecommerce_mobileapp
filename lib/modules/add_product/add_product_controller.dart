import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AddProductController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final skuController = TextEditingController();
  
  final selectedCategory = Rxn<String>();
  final selectedImages = <String>[].obs;
  final isLoading = false.obs;
  
  final categories = <String>[
    'Electronics',
    'Clothing',
    'Food & Beverages',
    'Home & Garden',
    'Sports',
    'Books',
    'Toys',
    'Beauty',
  ];

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    skuController.dispose();
    super.onClose();
  }

  void pickImages() {
    // TODO: Implement image picker
    // Example: use image_picker package
    Get.snackbar(
      'Info',
      'Image picker not implemented yet',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> saveProduct() async {
    if (!formKey.currentState!.validate()) return;
    
    if (selectedCategory.value == null) {
      Get.snackbar(
        'Error',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar(
      'Success',
      'Product added successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.back();
  }
}