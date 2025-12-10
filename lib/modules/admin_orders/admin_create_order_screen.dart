import 'package:ecommerce_urban/modules/admin_orders/admin_create_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class CreateOrderScreen extends StatelessWidget {
  CreateOrderScreen({super.key});

  final controller = Get.put(CreateOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Order"),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section("Cart Information", _cartSection()),
            _section("Shipping Address", _shippingSection()),
            _section("Billing Address", _billingSection()),
            _section("Pricing Details", _pricingSection()),
            _section("Additional Notes", _notesSection()),
            const SizedBox(height: 20),
            _submitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------
  // SECTION WRAPPER
  // ----------------------------------------
  Widget _section(String title, Widget child) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  // ----------------------------------------
  // CART
  // ----------------------------------------
  Widget _cartSection() {
    return TextFormField(
      controller: controller.cartId,
      decoration: const InputDecoration(
        labelText: "Cart ID *",
        prefixIcon: Icon(Icons.shopping_cart),
        border: OutlineInputBorder(),
      ),
      validator: (v) => v!.isEmpty ? "Cart ID required" : null,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  // ----------------------------------------
  // SHIPPING
  // ----------------------------------------
  Widget _shippingSection() {
    return Column(
      children: [
        _input(controller.shipName, "Recipient Name *", Icons.person,
            required: true),
        const SizedBox(height: 12),
        _input(controller.shipLine1, "Address Line 1 *", Icons.home,
            required: true),
        const SizedBox(height: 12),
        _input(controller.shipLine2, "Address Line 2", Icons.home_outlined),
        const SizedBox(height: 12),

        /// CITY / STATE
        Row(
          children: [
            Expanded(
              child: _input(controller.shipCity, "City *",
                  Icons.location_city_outlined,
                  required: true),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _input(controller.shipState, "State", Icons.map_outlined),
            ),
          ],
        ),
        const SizedBox(height: 12),

        /// POSTAL / COUNTRY
        Row(
          children: [
            Expanded(
              child: _input(controller.shipPostal, "Postal Code",
                  Icons.local_post_office_outlined),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _input(controller.shipCountry, "Country Code *",
                  Icons.flag_circle,
                  required: true),
            ),
          ],
        ),
      ],
    );
  }

  // ----------------------------------------
  // BILLING
  // ----------------------------------------
  Widget _billingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // checkbox row no Obx wrapping children
        Row(
          children: [
            Obx(() => Checkbox(
                  value: controller.sameAsShipping.value,
                  onChanged: (v) {
                    controller.sameAsShipping.value = v ?? false;
                    if (v == true) controller.copyToBilling();
                  },
                )),
            const Text("Same as shipping"),
          ],
        ),
        const SizedBox(height: 12),

        Obx(() {
          if (controller.sameAsShipping.value) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              _input(controller.billName, "Recipient Name *", Icons.person,
                  required: true),
              const SizedBox(height: 12),
              _input(controller.billLine1, "Address Line 1 *", Icons.home,
                  required: true),
              const SizedBox(height: 12),
              _input(controller.billLine2, "Address Line 2",
                  Icons.home_outlined),
              const SizedBox(height: 12),

              /// City / State
              Row(
                children: [
                  Expanded(
                    child: _input(controller.billCity, "City *",
                        Icons.location_city_outlined,
                        required: true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:
                        _input(controller.billState, "State", Icons.map_sharp),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Postal / Country
              Row(
                children: [
                  Expanded(
                    child: _input(controller.billPostal, "Postal Code",
                        Icons.local_post_office_outlined),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _input(controller.billCountry, "Country Code *",
                        Icons.flag_circle,
                        required: true),
                  ),
                ],
              )
            ],
          );
        }),
      ],
    );
  }

  // ----------------------------------------
  // PRICING
  // ----------------------------------------
  Widget _pricingSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _moneyField(
                controller.discount,
                "Discount",
                Icons.discount_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child:
                  _moneyField(controller.tax, "Tax", Icons.receipt_long_outlined),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _moneyField(controller.shippingCost, "Shipping Cost",
            Icons.local_shipping_outlined),
      ],
    );
  }

  // ----------------------------------------
  // NOTES
  // ----------------------------------------
  Widget _notesSection() {
    return TextFormField(
      controller: controller.notes,
      maxLines: 3,
      decoration: const InputDecoration(
        hintText: "Enter any special instructions...",
        border: OutlineInputBorder(),
      ),
    );
  }

  // ----------------------------------------
  // SUBMIT BUTTON
  // ----------------------------------------
  Widget _submitButton() {
    return Obx(
      () => FilledButton(
        onPressed:
            controller.isSubmitting.value ? null : () => controller.submit(),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        child: controller.isSubmitting.value
            ? const CircularProgressIndicator(strokeWidth: 2)
            : const Text(
                "Create Order",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  // ----------------------------------------
  // INPUT FIELD BUILDER
  // ----------------------------------------
  Widget _input(TextEditingController c, String label, IconData icon,
      {bool required = false}) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: required
          ? (v) => v!.isEmpty ? "Required field" : null
          : null,
    );
  }

  // ----------------------------------------
  // MONEY FIELD
  // ----------------------------------------
  Widget _moneyField(TextEditingController c, String label, IconData icon) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        prefixText: "\$ ",
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
      ],
    );
  }
}
