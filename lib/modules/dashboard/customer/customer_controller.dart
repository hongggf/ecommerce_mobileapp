// // lib/modules/dashboard/customer/customer_controller.dart

// import 'package:ecommerce_urban/app/model/category_model.dart';
// import 'package:ecommerce_urban/app/model/product_model.dart';
// import 'package:ecommerce_urban/app/repositories/category_repository.dart';
// import 'package:ecommerce_urban/app/repositories/product_repository.dart';
// import 'package:get/get.dart';

// class CustomerController extends GetxController {
//   final CategoryRepository _categoryRepo = CategoryRepository();
//   final ProductRepository _productRepo = ProductRepository();

//   // Observable variables
//   final isLoading = false.obs;
//   final isCategoriesLoading = false.obs;
//   final isProductsLoading = false.obs;
  
//   final categories = <CategoryModel>[].obs;
//   final popularProducts = <ProductModel>[].obs;
//   final selectedCategoryIndex = 0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadDashboardData();
//   }

//   // Load all dashboard data
//   Future<void> loadDashboardData() async {
//     isLoading.value = true;
//     try {
//       await Future.wait([
//         loadCategories(),
//         loadPopularProducts(),
//       ]);
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to load dashboard data: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Load categories
//   Future<void> loadCategories() async {
//     isCategoriesLoading.value = true;
//     try {
//       final result = await _categoryRepo.getCategories();
//       categories.value = result;
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to load categories: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isCategoriesLoading.value = false;
//     }
//   }

//   // Load popular products
//   Future<void> loadPopularProducts() async {
//     isProductsLoading.value = true;
//     try {
//       final result = await _productRepo.getPopularProducts(limit: 10);
//       popularProducts.value = result;
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to load popular products: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isProductsLoading.value = false;
//     }
//   }

//   // Handle category tap
//   void onCategoryTap(int index) {
//     selectedCategoryIndex.value = index;
//     // Navigate to product list with category filter
//     if (index < categories.length) {
//       Get.toNamed('/product', arguments: {
//         'categoryId': categories[index].id,
//         'categoryName': categories[index].name,
//       });
//     }
//   }

//   // Navigate to product detail
//   void goToProductDetail(ProductModel product) {
//     Get.toNamed('/product_detail', arguments: {
//       'productId': product.id,
//       'product': product,
//     });
//   }

//   // Refresh dashboard
//   Future<void> refreshDashboard() async {
//     await loadDashboardData();
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  // Reactive variables
  final RxBool isCategoriesLoading = false.obs;
  final RxBool isProductsLoading = false.obs;
  final RxInt cartItemCount = 0.obs;
  
  final RxList<Category> categories = <Category>[].obs;
  final RxList<Product> popularProducts = <Product>[].obs;
  final RxList<Product> featuredDeals = <Product>[].obs;
  final RxList<Banner> banners = <Banner>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  // Load initial data
  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadCategories(),
      _loadProducts(),
      _loadBanners(),
    ]);
  }

  // Load mock categories
  Future<void> _loadCategories() async {
    try {
      isCategoriesLoading.value = true;
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock category data
      categories.value = [
        Category(
          id: '1',
          name: 'Electronics',
          icon: Icons.phone_android_rounded,
          color: Colors.blue,
        ),
        Category(
          id: '2',
          name: 'Fashion',
          icon: Icons.checkroom_rounded,
          color: Colors.pink,
        ),
        Category(
          id: '3',
          name: 'Home',
          icon: Icons.home_rounded,
          color: Colors.orange,
        ),
        Category(
          id: '4',
          name: 'Beauty',
          icon: Icons.spa_rounded,
          color: Colors.purple,
        ),
        Category(
          id: '5',
          name: 'Sports',
          icon: Icons.sports_soccer_rounded,
          color: Colors.green,
        ),
        Category(
          id: '6',
          name: 'Books',
          icon: Icons.book_rounded,
          color: Colors.brown,
        ),
      ];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load categories: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  // Load mock products
  Future<void> _loadProducts() async {
    try {
      isProductsLoading.value = true;
      
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Mock popular products
      popularProducts.value = [
        Product(
          id: '1',
          name: 'Wireless Headphones',
          primaryImageUrl: '',
          lowestPrice: 89.99,
          rating: 4.5,
          reviews: 234,
          discount: 15,
        ),
        Product(
          id: '2',
          name: 'Smart Watch Pro',
          primaryImageUrl: '',
          lowestPrice: 299.99,
          rating: 4.8,
          reviews: 567,
          discount: 20,
        ),
        Product(
          id: '3',
          name: 'Laptop Backpack',
          primaryImageUrl: '',
          lowestPrice: 49.99,
          rating: 4.3,
          reviews: 123,
        ),
        Product(
          id: '4',
          name: 'Gaming Mouse',
          primaryImageUrl: '',
          lowestPrice: 59.99,
          rating: 4.6,
          reviews: 345,
          discount: 10,
        ),
        Product(
          id: '5',
          name: 'USB-C Hub',
          primaryImageUrl: '',
          lowestPrice: 39.99,
          rating: 4.4,
          reviews: 189,
        ),
      ];

      // Mock featured deals
      featuredDeals.value = [
        Product(
          id: '6',
          name: 'Premium Noise Cancelling Headphones',
          primaryImageUrl: '',
          lowestPrice: 249.99,
          rating: 4.9,
          reviews: 892,
          discount: 30,
        ),
        Product(
          id: '7',
          name: '4K Ultra HD Smart TV',
          primaryImageUrl: '',
          lowestPrice: 599.99,
          rating: 4.7,
          reviews: 456,
          discount: 25,
        ),
      ];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isProductsLoading.value = false;
    }
  }

  // Load mock banners
  Future<void> _loadBanners() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    banners.value = [
      Banner(
        id: '1',
        title: 'Summer Sale',
        subtitle: 'Up to 50% OFF on all items',
        colors: [Colors.orange, Colors.deepOrange],
      ),
      Banner(
        id: '2',
        title: 'New Arrivals',
        subtitle: 'Check out our latest collection',
        colors: [Colors.purple, Colors.deepPurple],
      ),
      Banner(
        id: '3',
        title: 'Flash Deals',
        subtitle: 'Limited time offers',
        colors: [Colors.blue, Colors.indigo],
      ),
    ];
  }

  // Refresh dashboard
  Future<void> refreshDashboard() async {
    await _loadInitialData();
    Get.snackbar(
      'Success',
      'Dashboard refreshed',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }

  // Category tap handler
  void onCategoryTap(int index) {
    final category = categories[index];
    Get.toNamed('/product', arguments: {
      'categoryId': category.id,
      'categoryName': category.name,
    });
  }

  // Navigate to product detail
  void goToProductDetail(Product product) {
    Get.toNamed('/product-detail', arguments: {
      'productId': product.id,
      'product': product,
    });
  }

  // Toggle wishlist
  void toggleWishlist(String productId) {
    // Find in popular products
    final popularIndex = popularProducts.indexWhere((p) => p.id == productId);
    if (popularIndex != -1) {
      popularProducts[popularIndex].isWishlisted =
          !popularProducts[popularIndex].isWishlisted;
      popularProducts.refresh();
    }

    // Find in featured deals
    final dealIndex = featuredDeals.indexWhere((p) => p.id == productId);
    if (dealIndex != -1) {
      featuredDeals[dealIndex].isWishlisted =
          !featuredDeals[dealIndex].isWishlisted;
      featuredDeals.refresh();
    }

    Get.snackbar(
      'Wishlist',
      popularIndex != -1 && popularProducts[popularIndex].isWishlisted ||
              dealIndex != -1 && featuredDeals[dealIndex].isWishlisted
          ? 'Added to wishlist'
          : 'Removed from wishlist',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(16),
    );
  }
}class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class Product {
  final String id;
  final String name;
  final String primaryImageUrl;
  final double lowestPrice;
  final double rating;
  final int reviews;
  final int discount;
  bool isWishlisted;

  Product({
    required this.id,
    required this.name,
    required this.primaryImageUrl,
    required this.lowestPrice,
    this.rating = 0.0,
    this.reviews = 0,
    this.discount = 0,
    this.isWishlisted = false,
  });
}

class Banner {
  final String id;
  final String title;
  final String subtitle;
  final List<Color> colors;

  Banner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.colors,
  });
}