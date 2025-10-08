import 'package:ecommerce_urban/app/modules/product/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductView extends StatelessWidget {
  ProductView({super.key});

  final controller = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Products"),
        ),
        body: GetBuilder<ProductController>(builder: (_) {
          if(controller.isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(
            itemCount: controller.lstProducts.length,
            itemBuilder: (BuildContext context, int index) {
              final product = controller.lstProducts[index];
              return ListTile(
                trailing: Image.network(product.category!.image!),
                title: Text("${product.title}"),
                subtitle: Text("\$${product.price}"),
              );
            },
          );
        }));
  }
}
