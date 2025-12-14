import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/category_list_widget.dart';
import 'package:ecommerce_urban/modules/admin/admin_category/admin_category_controller.dart';
import 'package:ecommerce_urban/modules/admin/admin_category/widget/admin_category_form.dart';
import 'package:ecommerce_urban/modules/admin/admin_category/widget/category_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminCategoryView extends StatelessWidget {
  final AdminCategoryController controller = Get.put(AdminCategoryController());

  AdminCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchCategories,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.prepareForm();
          AdminCategoryForm.show(controller: controller);
        },
        icon: const Icon(Icons.add),
        label: const Text("Create Category"),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingSM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: AppSpacing.marginM),
            _buildSortDropdown(),
            _buildCategoriesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: const InputDecoration(
        hintText: "Search by name",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        controller.fetchCategories(search: value);
      },
    );
  }

  Widget _buildSortDropdown() {
    return Obx(() => DropdownButton<String>(
      value: controller.sortBy.value.isEmpty ? "all" : controller.sortBy.value,
      hint: const Text("Sort"),
      items: [
        const DropdownMenuItem(value: "all", child: Text("All")),
        const DropdownMenuItem(value: "name_asc", child: Text("Name A-Z")),
        const DropdownMenuItem(value: "name_desc", child: Text("Name Z-A")),
        const DropdownMenuItem(value: "newest", child: Text("Newest First")),
      ],
      onChanged: (value) {
        if (value != null) {
          controller.sortBy.value = value;
          if (value == "all") {
            controller.fetchCategories(); // no sort applied
          } else {
            controller.fetchCategories(sort: value);
          }
        }
      },
    ));
  }

  Widget _buildCategoriesList(){
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.categories.isEmpty) {
          return const Center(child: Text("No categories found"));
        }

        return ListView.separated(
          itemCount: controller.categories.length,
          separatorBuilder: (_, __) => const SizedBox(),
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return AdminCategoryItemWidget(
              name: category.name.toString(),
              status: category.slug.toString(),
              onDelete: () => controller.deleteCategory(category.id!.toInt()),
              onEdit: (){
                controller.prepareForm(category: category);
                AdminCategoryForm.show(controller: controller);
              },
            );
          },
        );
      }),
    );
  }

  // void _showCategoryForm() {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (_) => Padding(
  //       padding: EdgeInsets.only(
  //         bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
  //         top: 16,
  //         left: 16,
  //         right: 16,
  //       ),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Top handle
  //             Container(
  //               width: 40,
  //               height: 4,
  //               margin: const EdgeInsets.only(bottom: 16),
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[300],
  //                 borderRadius: BorderRadius.circular(2),
  //               ),
  //             ),
  //
  //             // Title
  //             Text(
  //               controller.editingCategoryId.value == null
  //                   ? "Create Category"
  //                   : "Edit Category",
  //               style: Theme.of(Get.context!).textTheme.titleMedium
  //                   ?.copyWith(fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 16),
  //
  //             // Name
  //             TextField(
  //               controller: controller.nameController,
  //               decoration: const InputDecoration(
  //                 labelText: "Name",
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 12),
  //
  //             // Slug
  //             TextField(
  //               controller: controller.slugController,
  //               decoration: const InputDecoration(
  //                 labelText: "Slug",
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //
  //             // Submit Button
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 onPressed: controller.submitCategoryForm,
  //                 child: Text(controller.editingCategoryId.value == null
  //                     ? "Create"
  //                     : "Update"),
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}