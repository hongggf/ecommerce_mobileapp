import 'package:get/get.dart';

class WishlistItem {
  final String id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final RxBool isWishlisted;

  WishlistItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.isWishlisted,
  });
}

class WishlistController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<WishlistItem> wishlistItems = <WishlistItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  void loadWishlist() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      wishlistItems.assignAll([
        WishlistItem(
          id: '1',
          name: 'Nike Running Shoes',
          image: "https://picsum.photos/300",
          price: 129.99,
          rating: 4.5,
          isWishlisted: true.obs,
        ),
        WishlistItem(
          id: '2',
          name: 'Adidas Sports Jacket',
          image: "https://picsum.photos/300",
          price: 89.99,
          rating: 4.3,
          isWishlisted: true.obs,
        ),
        WishlistItem(
          id: '3',
          name: 'Premium Watch',
          image: "https://picsum.photos/300",
          price: 249.99,
          rating: 4.8,
          isWishlisted: true.obs,
        ),
        WishlistItem(
          id: '4',
          name: 'Casual T-Shirt',
          image: "https://picsum.photos/300",
          price: 29.99,
          rating: 4.2,
          isWishlisted: true.obs,
        ),
      ]);
      isLoading.value = false;
    });
  }

  void toggleWishlist(String itemId) {
    final index = wishlistItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      wishlistItems[index].isWishlisted.toggle();
    }
  }

  void removeFromWishlist(String itemId) {
    wishlistItems.removeWhere((item) => item.id == itemId);
  }

  void clearWishlist() {
    wishlistItems.clear();
  }

  void addToCart(String itemId) {
    final item = wishlistItems.firstWhereOrNull((item) => item.id == itemId);
    if (item != null) {
      Get.snackbar('Cart', 'Added ${item.name} to cart',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
