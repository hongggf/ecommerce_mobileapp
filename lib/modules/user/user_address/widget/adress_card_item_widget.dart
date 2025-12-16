import 'package:ecommerce_urban/api/model/address_model.dart';
import 'package:ecommerce_urban/modules/user/user_address/user_address_controller.dart';
import 'package:ecommerce_urban/modules/user/user_address/widget/user_address_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressItemWidget extends StatelessWidget {

  final AddressModel address;
  final UserAddressController controller;

  const AddressItemWidget({
    super.key,
    required this.address,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ICON
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              child: Icon(
                Icons.location_on,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(width: 12),

            /// ADDRESS DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME + DEFAULT LABEL
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          address.fullName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (address.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Default",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  /// ADDRESS
                  Text(
                    "${address.street}, ${address.district}, ${address.province}",
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),

                  /// PHONE
                  Text(
                    "Phone: ${address.phone}",
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// ACTION BUTTONS
            Column(
              children: [
                /// UPDATE BUTTON
                InkWell(
                  onTap: () {
                    UserAddressForm.show(controller: controller, editingAddress: address);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                /// DELETE BUTTON
                InkWell(
                  onTap: () {
                    controller.deleteAddress(address.id!);
                    Get.back();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 20,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}