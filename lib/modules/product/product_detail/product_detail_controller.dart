import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isFavorite = false.obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxString selectedSize = 'M'.obs;
  final RxInt quantity = 1.obs;
  final RxDouble currentPrice = 0.0.obs;

  final RxList<String> sizes = <String>['XS', 'S', 'M', 'L', 'XL', 'XXL'].obs;
  final RxList<String> productImages = <String>[
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
  ].obs;

  String productName = 'Premium Nike Running Shoe';
  String productDesc = 'High quality running shoe with excellent comfort and durability. Perfect for daily running and casual wear.';
  double basePrice = 129.99;

  @override
  void onInit() {
    super.onInit();
    loadProductDetail();
  }

  void loadProductDetail() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      currentPrice.value = basePrice;
      isLoading.value = false;
    });
  }

  void selectSize(String size) {
    selectedSize.value = size;
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
    isFavorite.toggle();
  }

  void addToCart() {
    Get.snackbar('Success', 'Added to cart!', snackPosition: SnackPosition.BOTTOM);
  }
}
