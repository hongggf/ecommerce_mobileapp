import 'package:ecommerce_urban/modules/admin/admin_category/admin_category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminCategoryView extends StatelessWidget {
  AdminCategoryView({super.key});

  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Category"),
      ),
      body: Column(
        children: [
          _buildCategoryList(context),
        ],
      )
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return Column(
      children: [

      ],
    );
  }
}