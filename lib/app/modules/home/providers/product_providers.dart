import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductProvider {
  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse("https://dummyjson.com/products"));
    final body = jsonDecode(response.body);

    List data = body['products'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
