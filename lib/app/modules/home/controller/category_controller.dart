import 'package:ecommerce_urban/app/modules/home/models/category_model.dart';
import 'package:ecommerce_urban/app/modules/home/providers/category_providers.dart';
import 'package:get/get.dart';


class CategoryController extends GetxController {
  var isLoading = true.obs;
  var categories = <CategoryModel>[].obs;

  final CategoryProvider provider = CategoryProvider();

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      final result = await provider.getCategories();
      categories.assignAll(result);
    } finally {
      isLoading(false);
    }
  }
}
