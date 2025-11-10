import 'package:ecommerce_urban/app/modules/home/models/product_model.dart';
import 'package:flutter/material.dart';


class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(product.images.first, height: 300),
            SizedBox(height: 20),
            Text(product.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(product.description, textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}
