// lib/modules/product/product_detail/product_detail_controller.dart

import 'package:ecommerce_urban/app/model/product_model.dart';
import 'package:ecommerce_urban/app/repositories/product_repository.dart';
import 'package:ecommerce_urban/modules/cart/cart_controller.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _productRepo = ProductRepository();

  final isLoading = false.obs;
  Rx<ProductModel?> product = Rx<ProductModel?>(null);
  
  final selectedImageIndex = 0.obs;
  final quantity = 1.obs;
  final isFavorite = false.obs;
  final selectedSize = ''.obs;
  final selectedVariantId = Rx<int?>(null);

  List<String> productImages = [];
  List<String> sizes = [];
  List<ProductVariantModel> variants = [];

  int? productId;

  @override
  void onInit() {
    super.onInit();
    
    // Get arguments
    final args = Get.arguments;
    if (args != null) {
      productId = args['productId'];
      
      // If product object is passed, use it immediately
      if (args['product'] != null) {
        product.value = args['product'];
        _setupProductData();
      }
    }
    
    // Load full product details
    if (productId != null) {
      loadProductDetails();
    }
  }

  Future<void> loadProductDetails() async {
    if (productId == null) return;
    
    isLoading.value = true;
    try {
      final result = await _productRepo.getProductById(productId!);
      product.value = result;
      _setupProductData();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load product details: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _setupProductData() {
    if (product.value == null) return;
    
    // Setup images from assets
    if (product.value!.assets != null && product.value!.assets!.isNotEmpty) {
      productImages = product.value!.assets!
          .map((asset) => asset.url)
          .toList();
    } else {
      productImages = ['https://via.placeholder.com/400'];
    }
    
    // Setup variants and sizes
    if (product.value!.variants != null && product.value!.variants!.isNotEmpty) {
      variants = product.value!.variants!;
      sizes = variants.map((v) => v.name).toList();
      
      // Auto-select first variant
      if (variants.isNotEmpty) {
        selectedSize.value = variants.first.name;
        selectedVariantId.value = variants.first.id;
      }
    }
  }

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
    
    // Find and select the corresponding variant
    final variant = variants.firstWhere(
      (v) => v.name == size,
      orElse: () => variants.first,
    );
    selectedVariantId.value = variant.id;
  }

  double get currentPrice {
    if (selectedVariantId.value != null) {
      final variant = variants.firstWhere(
        (v) => v.id == selectedVariantId.value,
        orElse: () => variants.first,
      );
      return variant.price;
    }
    return product.value?.lowestPrice ?? 0.0;
  }

  /// Add product to cart with proper validation and data
  Future<void> addToCart() async {
    // Validation: Check if product exists
    if (product.value == null) {
      Get.snackbar(
        'Error',
        'Product data is missing',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validation: Check if size/variant is selected
    if (selectedSize.value.isEmpty && sizes.isNotEmpty) {
      Get.snackbar(
        'Error',
        'Please select a size',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Validation: Check if variant ID is selected
    if (selectedVariantId.value == null) {
      Get.snackbar(
        'Error',
        'Please select a variant',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      print('🛒 DEBUG: Adding to cart...');
      print('Variant ID: ${selectedVariantId.value}');
      print('Product Name: ${product.value!.name}');
      print('Price: $currentPrice');
      print('Quantity: ${quantity.value}');
      print('Size: ${selectedSize.value}');

      // Get or create CartController instance
      CartController cartController;
      try {
        cartController = Get.find<CartController>();
        print('🛒 DEBUG: CartController found');
      } catch (e) {
        print('🛒 DEBUG: CartController not found, initializing...');
        // Initialize CartController if not exists
        cartController = Get.put(CartController());
        print('🛒 DEBUG: CartController initialized');
      }

      // Call the addToCart method with proper product data
      await cartController.addToCart(
        variantId: selectedVariantId.value!,
        productName: product.value!.name,
        productImage: product.value!.primaryImageUrl,
        price: currentPrice,
        quantity: quantity.value,
        size: selectedSize.value,
        color: null, // Color not used in this variant
      );

      print('🛒 DEBUG: Item added to cart successfully');

      // Reset form after successful addition
      quantity.value = 1;
      // Don't reset size selection - user might want to add more

      // Optional: Navigate to cart
      // Get.toNamed('/cart');
    } catch (e) {
      print('🛒 DEBUG: Error adding to cart: $e');
      print('Error type: ${e.runtimeType}');
      
      Get.snackbar(
        'Error',
        'Failed to add to cart: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}