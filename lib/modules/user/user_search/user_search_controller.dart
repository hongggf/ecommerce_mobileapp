import 'package:get/get.dart';
import 'package:ecommerce_urban/api/model/product_model.dart';
import 'package:ecommerce_urban/api/service/product_service.dart';
import 'package:ecommerce_urban/app/widgets/toast_widget.dart';

class UserSearchController extends GetxController {
  final ProductService _service = ProductService();

  /// State
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;
  var search = ''.obs;
  var sort = ''.obs;
  final selectedCategoryId = RxnInt();
  final perPage = 10.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts({int page = 1}) async {
    try {
      isLoading.value = true;

      final result = await _service.getAvailableProducts(
        search: search.value,
        categoryId: selectedCategoryId.value,
        sort: sort.value,
        perPage: perPage.value,
        page: page,
      );

      products.value = result;

    } catch (e) {
      ToastWidget.show(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Search
  void onSearch(String value) {
    search.value = value;
    fetchProducts();
  }

  /// Filter
  void onCategoryChange(int? id) {
    selectedCategoryId.value = id;
    fetchProducts();
  }

  /// Sort
  void onSortChange(String value) {
    sort.value = value;
    fetchProducts();
  }
}