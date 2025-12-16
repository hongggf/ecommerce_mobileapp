import 'package:ecommerce_urban/api/model/address_model.dart';
import 'package:ecommerce_urban/app/constants/app_spacing.dart';
import 'package:ecommerce_urban/modules/user/user_address/user_address_controller.dart';
import 'package:ecommerce_urban/modules/user/user_address/widget/adress_card_item_widget.dart';
import 'package:ecommerce_urban/modules/user/user_address/widget/user_address_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAddressView extends StatelessWidget {

  final UserAddressController controller = Get.put(UserAddressController());

  UserAddressView ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchAddresses,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingSM),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: _buildAddress(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          UserAddressForm.show(controller: controller);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddress(BuildContext context){
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.addresses.isEmpty) {
        return const Center(child: Text('No addresses found'));
      }

      return ListView.builder(
        itemCount: controller.addresses.length,
        itemBuilder: (_, index) {
          final address = controller.addresses[index];
          return AddressItemWidget(address: address, controller: controller);
        },
      );
    });
  }
}