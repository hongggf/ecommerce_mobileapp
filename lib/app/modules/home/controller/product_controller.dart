import 'package:ecommerce_urban/app/modules/home/models/product_model.dart';
import 'package:ecommerce_urban/app/modules/home/providers/product_providers.dart';
import 'package:get/get.dart';


class ProductController extends GetxController {
  var isLoading = true.obs;
  var productList = <ProductModel>[].obs;

  final ProductProvider provider = ProductProvider();

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      productList.value = await provider.getProducts();
    } finally {
      isLoading(false);
    }
  }
}
