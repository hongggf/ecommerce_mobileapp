import 'package:ecommerce_urban/api/model/address_model.dart';
import 'package:ecommerce_urban/modules/user/user_address/user_address_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCheckoutView extends StatelessWidget {
  final UserAddressController controller = Get.put(UserAddressController());

  UserCheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Addresses')),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: _buildAddress(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddressForm(context, null),
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
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(address.fullName),
              subtitle: Text(
                  '${address.street}, ${address.district}, ${address.province}\nPhone: ${address.phone}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showAddressForm(context, address),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.deleteAddress(address.id!),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _showAddressForm(BuildContext context, AddressModel? address) {
    final fullNameCtrl = TextEditingController(text: address?.fullName);
    final phoneCtrl = TextEditingController(text: address?.phone);
    final provinceCtrl = TextEditingController(text: address?.province);
    final districtCtrl = TextEditingController(text: address?.district);
    final streetCtrl = TextEditingController(text: address?.street);
    var isDefault = address?.isDefault ?? false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(address == null ? 'Add Address' : 'Edit Address'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: fullNameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
              TextField(controller: provinceCtrl, decoration: const InputDecoration(labelText: 'Province')),
              TextField(controller: districtCtrl, decoration: const InputDecoration(labelText: 'District')),
              TextField(controller: streetCtrl, decoration: const InputDecoration(labelText: 'Street')),
              CheckboxListTile(
                value: isDefault,
                onChanged: (val) => isDefault = val ?? false,
                title: const Text('Set as default'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newAddress = AddressModel(
                fullName: fullNameCtrl.text,
                phone: phoneCtrl.text,
                province: provinceCtrl.text,
                district: districtCtrl.text,
                street: streetCtrl.text,
                isDefault: isDefault,
              );

              if (address == null) {
                controller.addAddress(newAddress);
              } else {
                controller.updateAddress(address.id!, newAddress);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}