import 'package:ecommerce_urban/app/constants/app_colors.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:flutter/material.dart';

class Category {
  final String name;
  Category({required this.name});
}

class CategoryListWidget extends StatelessWidget {
  final List<Category>? categories;
  final int? selectedIndex;
  final ValueChanged<int>? onCategoryTap;
  final double? height;

  const CategoryListWidget({
    super.key,
    this.categories,
    this.selectedIndex,
    this.onCategoryTap,
    this.height = 45,
  });

  @override
  Widget build(BuildContext context) {
    final list = categories ?? [];

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final category = list[index];
          return GestureDetector(
            onTap: () {
              if (onCategoryTap != null) onCategoryTap!(index);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.paddingS),
                  child: Center(
                    child: Text(
                      category.name.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}