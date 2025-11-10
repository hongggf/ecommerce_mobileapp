import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryProvider {
  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products/category-list'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((cat) => CategoryModel.fromJson(cat)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
