// lib/modules/product/product_list/product_controller.dart

import 'package:ecommerce_urban/app/model/product_model.dart';
import 'package:ecommerce_urban/app/repositories/product_repository.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final ProductRepository _productRepo = ProductRepository();

  final isLoading = false.obs;
  final products = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;

  final selectedSort = 'Latest'.obs;
  final selectedFilter = 'None'.obs;

  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final total = 0.obs;

  int? categoryId;
  String? categoryName;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null) {
      categoryId = args['categoryId'];
      categoryName = args['categoryName'];
    }

    print('🎯 ProductController initialized');
    print('📂 Category ID: $categoryId');
    print('📝 Category Name: $categoryName');

    loadProducts();
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      products.clear();
    }

    isLoading.value = true;

    try {
      final result = await _productRepo.getProducts(
        page: currentPage.value,
        perPage: 15,
        categoryId: categoryId,
      );

      final List<ProductModel> newProducts = result['data'];

      if (refresh) {
        products.value = newProducts;
      } else {
        products.addAll(newProducts);
      }

      lastPage.value = result['last_page'];
      total.value = result['total'];

      _applyFiltersAndSort();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (currentPage.value < lastPage.value && !isLoading.value) {
      currentPage.value++;
      await loadProducts();
    }
  }

  void _applyFiltersAndSort() {
    var tempList = List<ProductModel>.from(products);

    // Filter
    if (selectedFilter.value == '<50') {
      tempList = tempList.where((p) => p.lowestPrice < 50).toList();
    } else if (selectedFilter.value == 'Nike') {
      tempList =
          tempList.where((p) => p.name.toLowerCase().contains('nike')).toList();
    }

    // Sort
    if (selectedSort.value == 'LowToHigh') {
      tempList.sort((a, b) => a.lowestPrice.compareTo(b.lowestPrice));
    } else if (selectedSort.value == 'HighToLow') {
      tempList.sort((a, b) => b.lowestPrice.compareTo(a.lowestPrice));
    }

    filteredProducts.value = tempList;
  }

  void applySort(String sortType) {
    selectedSort.value = sortType;
    _applyFiltersAndSort();
  }

  void applyFilter(String filterType) {
    selectedFilter.value = filterType;
    _applyFiltersAndSort();
  }

  void goToProductDetail(ProductModel product) {
    Get.toNamed('/product_detail', arguments: {
      'productId': product.id,
      'product': product,
    });
  }
}
