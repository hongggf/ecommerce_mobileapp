import 'dart:io';
import 'package:get/get.dart';
import '../model/product_model.dart';
import '../model/product_varaint_model.dart';


class ProductManagementController extends GetxController {
  // Reactive variables
  var isLoading = false.obs;
  var isLoadingVariants = false.obs;
  var isLoadingAssets = false.obs;
  var currentStep = 0.obs;
  
  // Product data
  var product = Rxn<Product>();
  var productName = ''.obs;
  var productDescription = ''.obs;
  var productStatus = 'active'.obs;
  var selectedCategoryId = Rxn<int>();
  
  // Categories
  var categories = <Category>[].obs;
  
  // Variants
  var variants = <ProductVariant>[].obs;
  var selectedVariant = Rxn<ProductVariant>();
  var showVariantForm = false.obs;
  var variantName = ''.obs;
  var variantSku = ''.obs;
  var variantPrice = ''.obs;
  var variantStatus = 'active'.obs;
  
  // Assets
  var assets = <Asset>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    
    // Check if editing existing product
    final productArg = Get.arguments;
    if (productArg != null && productArg is Product) {
      product.value = productArg;
      productName.value = productArg.name;
      productDescription.value = productArg.description;
      productStatus.value = productArg.status;
      selectedCategoryId.value = productArg.categoryId;
      
      if (productArg.variants != null) {
        variants.value = productArg.variants!;
      }
    }
  }

  // Fetch categories
  Future<void> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    categories.value = [
      Category(id: 1, name: 'Electronics'),
      Category(id: 2, name: 'Clothing'),
      Category(id: 3, name: 'Home & Garden'),
      Category(id: 4, name: 'Sports'),
      Category(id: 5, name: 'Books'),
    ];
  }

  // Save product (step 0)
  Future<void> saveProduct() async {
    if (productName.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a product name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedCategoryId.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock save product
      if (product.value == null) {
        product.value = Product(
          id: DateTime.now().millisecondsSinceEpoch,
          name: productName.value,
          description: productDescription.value,
          status: productStatus.value,
          categoryId: selectedCategoryId.value!,
        );
      } else {
        product.value = Product(
          id: product.value!.id,
          name: productName.value,
          description: productDescription.value,
          status: productStatus.value,
          categoryId: selectedCategoryId.value!,
        );
      }
      
      isLoading.value = false;
      
      Get.snackbar(
        'Success',
        'Product saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      nextStep();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to save product',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Variant management
  void openVariantForm([ProductVariant? variant]) {
    if (variant != null) {
      selectedVariant.value = variant;
      variantName.value = variant.name;
      variantSku.value = variant.sku;
      variantPrice.value = variant.price.toString();
      variantStatus.value = variant.status;
    } else {
      selectedVariant.value = null;
      variantName.value = '';
      variantSku.value = '';
      variantPrice.value = '';
      variantStatus.value = 'active';
    }
    showVariantForm.value = true;
  }

  void closeVariantForm() {
    showVariantForm.value = false;
    selectedVariant.value = null;
  }

  Future<void> saveVariant() async {
    if (variantName.value.isEmpty || variantSku.value.isEmpty || variantPrice.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please fill all variant fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      
      final price = double.tryParse(variantPrice.value) ?? 0.0;
      
      if (selectedVariant.value != null) {
        // Update existing variant
        final index = variants.indexWhere((v) => v.id == selectedVariant.value!.id);
        if (index != -1) {
          variants[index] = ProductVariant(
            id: selectedVariant.value!.id,
            name: variantName.value,
            sku: variantSku.value,
            price: price,
            status: variantStatus.value,
          );
        }
      } else {
        // Add new variant
        variants.add(ProductVariant(
          id: DateTime.now().millisecondsSinceEpoch,
          name: variantName.value,
          sku: variantSku.value,
          price: price,
          status: variantStatus.value,
        ));
      }
      
      isLoading.value = false;
      closeVariantForm();
      
      Get.snackbar(
        'Success',
        'Variant saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to save variant',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteVariant(ProductVariant variant) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      variants.removeWhere((v) => v.id == variant.id);
      
      Get.snackbar(
        'Success',
        'Variant deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete variant',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Asset management
  void selectVariantForAssets(ProductVariant variant) {
    selectedVariant.value = variant;
    currentStep.value = 2;
    fetchAssets();
  }

  Future<void> fetchAssets() async {
    try {
      isLoadingAssets.value = true;
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock assets
      assets.value = [
        Asset(
          id: 1,
          url: 'https://picsum.photos/400/400?random=1',
          isPrimary: true,
        ),
        Asset(
          id: 2,
          url: 'https://picsum.photos/400/400?random=2',
          isPrimary: false,
        ),
        Asset(
          id: 3,
          url: 'https://picsum.photos/400/400?random=3',
          isPrimary: false,
        ),
      ];
      
      isLoadingAssets.value = false;
    } catch (e) {
      isLoadingAssets.value = false;
    }
  }

  Future<void> uploadAsset(File file) async {
    try {
      isLoadingAssets.value = true;
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Mock upload
      assets.add(Asset(
        id: DateTime.now().millisecondsSinceEpoch,
        url: 'https://picsum.photos/400/400?random=${assets.length + 4}',
        isPrimary: false,
      ));
      
      isLoadingAssets.value = false;
      
      Get.snackbar(
        'Success',
        'Image uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoadingAssets.value = false;
      Get.snackbar(
        'Error',
        'Failed to upload image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteAsset(Asset asset) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      assets.removeWhere((a) => a.id == asset.id);
      
      Get.snackbar(
        'Success',
        'Image deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Navigation
  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
}

// Mock Models
class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});
}

class Asset {
  final int id;
  final String url;
  final bool isPrimary;

  Asset({required this.id, required this.url, required this.isPrimary});
}