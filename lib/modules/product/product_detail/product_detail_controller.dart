import 'package:get/get.dart';
import 'package:flutter/material.dart';
class ProductDetailController extends GetxController {
var selectedImageIndex = 0.obs;
  var quantity = 1.obs;
  var isFavorite = false.obs;
  var selectedSize = ''.obs;
  var selectedColor = ''.obs;

  final List<String> productImages = [
    'https://picsum.photos/400/400',
    'https://picsum.photos/401/401',
    'https://picsum.photos/402/402',
  ];
 final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  
  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    Get.snackbar(
      'Wishlist',
      isFavorite.value ? 'Added to wishlist' : 'Removed from wishlist',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void selectColor( color) {
    selectedColor.value = color.toString();
  }

  void addToCart() {
    if (selectedSize.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a size',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
       
      );
      return;
    }

    Get.snackbar(
      'Success',
      'Added ${quantity.value} item(s) to cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      
    );
  }
}