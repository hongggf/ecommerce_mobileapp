
// lib/modules/category/views/category_screen.dart
import 'package:ecommerce_urban/modules/category/cateogry_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_urban/app/constants/app_colors.dart';


class CategoryScreen extends GetView<CategoryController> {
  const CategoryScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Popular Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: controller.categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    return _buildCategoryCard(context, controller.categories[index]);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryItem category) {
    return GestureDetector(
      onTap: () => controller.selectCategory(category),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.primary.withOpacity(0.1),
          border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 12,
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => controller.selectCategory(category),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(category.icon, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}