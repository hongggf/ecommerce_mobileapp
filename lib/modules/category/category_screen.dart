import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/category_list_widget.dart';
import 'package:ecommerce_urban/app/widgets/search_widget.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart  ';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingS),
        child: Column(
          children: [
            SearchCardNavigation(
              onTap: () => Get.toNamed('/search'),
            ),
            SizedBox(height: AppSpacing.paddingL),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _popularCategorySection(),
                    SizedBox(height: AppSpacing.paddingXXL),
                    _allCategoriesGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _popularCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          title: "Popular Categories",
        ),
        SizedBox(height: AppSpacing.paddingXS),
        CategoryListWidget(
          categories: [
            Category(name: "Shoes"),
            Category(name: "Bags"),
            Category(name: "Watches"),
            Category(name: "Shoes"),
            Category(name: "Bags"),
            Category(name: "Watches"),
          ],
          selectedIndex: 0,
          onCategoryTap: (index) {
            print("Selected category index: $index");
          },
        ),
      ],
    );
  }

  Widget _allCategoriesGrid() {
    return Column(
      children: [
        TitleWidget(
          title: "All Categories",
        ),
        SizedBox(height: AppSpacing.paddingXS),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.paddingXS,
            crossAxisSpacing: AppSpacing.paddingXS,
            childAspectRatio: 2.5,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              child: Card(
                child: Center(
                  child: Text("Category Name",
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
