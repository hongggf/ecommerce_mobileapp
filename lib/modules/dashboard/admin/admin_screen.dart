import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/app/widgets/item_widget.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/admin_controller.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/widgets/admin_kpi_card_widget.dart';
import 'package:ecommerce_urban/modules/dashboard/admin/widgets/admin_quick_action_card_widget.dart';
import 'package:ecommerce_urban/app/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({super.key});

  final AdminController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kpiSection(),
            SizedBox(height: AppSpacing.paddingM),
            quickAction(),
          ],
        ),
      ),
    );
  }

  Widget kpiSection(){
    return AdminKPICardWidget(
      items: [
        KPIItem(icon: Icons.error_outline, iconBgColor: Colors.redAccent, title: 'Low Stock', value: '1234'),
        KPIItem(icon: Icons.shopping_cart, iconBgColor: Colors.orange, title: 'Orders', value: '567'),
        KPIItem(icon: Icons.inventory_2_outlined, iconBgColor: Colors.blue, title: 'Products', value: '500'),
      ],
    );
  }

  Widget quickAction(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: "Quick Actions"),
        ItemWidget(
          item: CardItem(
            icon: Icons.add_box,
            iconBgColor: Colors.blue,
            title: 'Add New Product',
            rightIcon: Icons.arrow_forward,
            onTapCard: () => print('Add New Product clicked'),
          ),
        ),
        ItemWidget(
          item: CardItem(
            icon: Icons.shopping_cart,
            iconBgColor: Colors.orange,
            title: 'Create Order',
            rightIcon: Icons.arrow_forward,
            onTapCard: () => print('Create Order clicked'),
          ),
        ),
        ItemWidget(
          item: CardItem(
            icon: Icons.store,
            iconBgColor: Colors.green,
            title: 'Add Stock',
            rightIcon: Icons.arrow_forward,
            onTapCard: () => print('Add Stock clicked'),
          ),
        ),
        ItemWidget(
          item: CardItem(
            icon: Icons.person_add,
            iconBgColor: Colors.purple,
            title: 'Add User',
            rightIcon: Icons.arrow_forward,
            onTapCard: () => print('Add User clicked'),
          ),
        ),
      ],
    );
  }
}