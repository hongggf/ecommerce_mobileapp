import 'dart:convert';
import 'package:ecommerce_urban/app/constants/constants.dart';
import 'package:ecommerce_urban/app/modules/product/model/product_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  List<Product> lstProducts = [];

  var isLoading= false;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading=true;
      update();
      final url = Uri.parse(kProductUrl);
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print('Response: $data');

        // Check if it's a list or a map with "data" key
        List productsJson = data is List ? data : data['data'] ?? [];

        lstProducts =
            productsJson.map((e) => Product.fromJson(e)).toList();
        isLoading=false;
        update();
      } else {
        print('Failed to load products. Status: ${res.statusCode}');
      }
    } catch (e, stack) {
      print('Error fetching products: $e');
      print(stack);
    }
  }
}
