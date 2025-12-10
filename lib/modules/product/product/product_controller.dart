import 'package:get/get.dart';

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.category,
  });
}

class ProductController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxString categoryName = 'Products'.obs;
  final RxString selectedSort = 'Latest'.obs;
  final RxInt currentPage = 1.obs;
  final RxInt lastPage = 3.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts({bool refresh = false}) {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      final mockProducts = [
        Product(id: '1', name: 'Nike Running Shoes', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300', price: 129.99, rating: 4.5, category: 'Shoes'),
        Product(id: '2', name: 'Adidas Sports Shoe', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300', price: 139.99, rating: 4.3, category: 'Shoes'),
        Product(id: '3', name: 'Puma Casual', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300', price: 99.99, rating: 4.2, category: 'Shoes'),
        Product(id: '4', name: 'New Balance', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300', price: 119.99, rating: 4.6, category: 'Shoes'),
        Product(id: '5', name: 'Converse Classic', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300', price: 79.99, rating: 4.4, category: 'Shoes'),
        Product(id: '6', name: 'Air Jordan', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300', price: 189.99, rating: 4.8, category: 'Shoes'),
      ];

      if (refresh) {
        currentPage.value = 1;
      }

      products.assignAll(mockProducts);
      filteredProducts.assignAll(mockProducts);
      isLoading.value = false;
    });
  }

  void loadMore() {
    if (currentPage.value < lastPage.value) {
      isLoading.value = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        currentPage.value++;
        isLoading.value = false;
      });
    }
  }

  void applySort(String sortType) {
    selectedSort.value = sortType;
    final sorted = List<Product>.from(filteredProducts);

    switch (sortType) {
      case 'LowToHigh':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'HighToLow':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
        break;
    }

    filteredProducts.assignAll(sorted);
  }

  void goToProductDetail(Product product) {
    Get.toNamed('/product_detail', arguments: product);
  }
}