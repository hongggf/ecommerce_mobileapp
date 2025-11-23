import 'package:ecommerce_urban/modules/address/address_controller.dart';
import 'package:ecommerce_urban/modules/address/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddressListView extends GetView<AddressController> {
  const AddressListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'My Addresses',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A1A)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
          );
        }

        if (controller.addresses.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.addresses.length,
          itemBuilder: (context, index) {
            final address = controller.addresses[index];
            return _buildAddressCard(address);
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.openAddAddressForm,
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: address.isDefault
            ? Border.all(color: const Color(0xFF6C63FF), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        address.title == 'Home'
                            ? Icons.home
                            : address.title == 'Office'
                                ? Icons.work
                                : Icons.location_on,
                        color: const Color(0xFF6C63FF),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      address.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Default',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Color(0xFF666666)),
                const SizedBox(width: 8),
                Text(
                  address.fullName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Color(0xFF666666)),
                const SizedBox(width: 8),
                Text(
                  address.phoneNumber,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 16, color: Color(0xFF666666)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address.fullAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (!address.isDefault)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => controller.setDefaultAddress(address.id),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF6C63FF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Set as Default',
                        style: TextStyle(color: Color(0xFF6C63FF)),
                      ),
                    ),
                  ),
                if (!address.isDefault) const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.openEditAddressForm(address),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A1A1A),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => controller.deleteAddress(address.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Icon(Icons.delete, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No addresses found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first address',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }
}
