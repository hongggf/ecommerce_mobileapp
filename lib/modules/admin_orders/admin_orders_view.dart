// import 'package:ecommerce_urban/modules/admin_orders/admin_orders_controller.dart';
// import 'package:ecommerce_urban/modules/admin_orders/model/order_items_model.dart';
// import 'package:ecommerce_urban/modules/admin_orders/model/order_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AdminOrderView extends GetView<OrderController> {
//   const AdminOrderView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Orders Management'),
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           // Filter by status
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Obx(() => DropdownButton<String>(
//               isExpanded: true,
//               value: controller.statusFilter.value.isEmpty ? null : controller.statusFilter.value,
//               hint: const Text('Filter by Status'),
//               onChanged: (value) {
//                 controller.statusFilter.value = value ?? '';
//               },
//               items: [
//                 const DropdownMenuItem(value: '', child: Text('All Orders')),
//                 const DropdownMenuItem(value: 'pending', child: Text('Pending')),
//                 const DropdownMenuItem(value: 'processing', child: Text('Processing')),
//                 const DropdownMenuItem(value: 'shipped', child: Text('Shipped')),
//                 const DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
//                 const DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
//               ],
//             )),
//           ),
//           // Orders list
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               final filteredOrders = controller.getFilteredOrders();
              
//               if (filteredOrders.isEmpty) {
//                 return const Center(child: Text('No orders found'));
//               }

//               return ListView.builder(
//                 itemCount: filteredOrders.length,
//                 itemBuilder: (context, index) {
//                   final order = filteredOrders[index];
//                   return orderCard(context, order);
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget orderCard(BuildContext context, Order order) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: ListTile(
//         title: Text('Order #${order.orderNumber}',
//             style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Date: ${order.createdAt.split('T')[0]}'),
//             Text('Total: \$${order.grandTotal.toStringAsFixed(2)}'),
//           ],
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Chip(label: Text(order.status), 
//               backgroundColor: _getStatusColor(order.status)),
//             const SizedBox(height: 4),
//             Chip(label: Text(order.financialStatus),
//               backgroundColor: _getFinancialColor(order.financialStatus)),
//           ],
//         ),
//         onTap: () {
//           controller.loadOrderDetails(order.id);
//           showOrderBottomSheet(context, order);
//         },
//       ),
//     );
//   }

//   void showOrderBottomSheet(BuildContext context, OrderModel order) {
//     Get.bottomSheet(
//       Container(
//         color: Colors.white,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Order #${order.orderNumber}',
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: Get.back,
//                     ),
//                   ],
//                 ),
//                 const Divider(),
                
//                 // Order info
//                 Text('Order Information', style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 8),
//                 Text('Date: ${order.createdAt.split('T')[0]}'),
//                 Text('Status: ${order.status}'),
//                 Text('Payment: ${order.financialStatus}'),
//                 Text('Notes: ${order.notes ?? 'N/A'}'),
//                 const SizedBox(height: 16),

//                 // Customer info
//                 Text('Customer Information', style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 8),
//                 Text('Name: ${order.user?.name ?? 'N/A'}'),
//                 Text('Email: ${order.user?.email ?? 'N/A'}'),
//                 const SizedBox(height: 16),

//                 // Shipping address
//                 Text('Shipping Address', style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 8),
//                 addressWidget(order.shippingAddressSnapshot),
//                 const SizedBox(height: 16),

//                 // Billing address
//                 Text('Billing Address', style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 8),
//                 addressWidget(order.billingAddressSnapshot),
//                 const SizedBox(height: 16),

//                 // Items
//                 Text('Order Items', style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 8),
//                 Obx(() {
//                   if (controller.orderItems.isEmpty) {
//                     return const Text('No items');
//                   }
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: controller.orderItems.length,
//                     itemBuilder: (context, index) {
//                       final item = controller.orderItems[index];
//                       return itemCard(item);
//                     },
//                   );
//                 }),
//                 const SizedBox(height: 16),

//                 // Pricing breakdown
//                 pricingBreakdown(order),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//       isScrollControlled: true,
//     );
//   }

//   Widget addressWidget(Map<String, dynamic>? address) {
//     if (address == null || address.isEmpty) {
//       return const Text('N/A');
//     }
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(address['recipient_name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(address['line1'] ?? ''),
//           Text('${address['city'] ?? ''}, ${address['country_code'] ?? ''}'),
//         ],
//       ),
//     );
//   }

//   Widget itemCard(OrderItem item) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(item.product?.name ?? 'Product',
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       Text('${item.variant?.name ?? 'Variant'} • Qty: ${item.quantity}'),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red, size: 20),
//                   onPressed: () => controller.removeItem(item.id),
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Unit Price: \$${item.unitPrice.toStringAsFixed(2)}'),
//                 Text('Subtotal: \$${item.totalPrice.toStringAsFixed(2)}',
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//             if (item.taxAmount > 0) ...[
//               const SizedBox(height: 4),
//               Text('Tax: \$${item.taxAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
//             ],
//             if (item.discountAmount > 0) ...[
//               const SizedBox(height: 4),
//               Text('Discount: -\$${item.discountAmount.toStringAsFixed(2)}', 
//                   style: const TextStyle(fontSize: 12, color: Colors.green)),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget pricingBreakdown(Order order) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Column(
//         children: [
//           _pricingRow('Subtotal', order.subtotal),
//           if (order.discountTotal > 0)
//             _pricingRow('Discount', -order.discountTotal, color: Colors.green),
//           if (order.taxTotal > 0)
//             _pricingRow('Tax', order.taxTotal),
//           if (order.shippingTotal > 0)
//             _pricingRow('Shipping', order.shippingTotal),
//           const Divider(),
//           _pricingRow('Grand Total', order.grandTotal, isBold: true),
//         ],
//       ),
//     );
//   }

//   Widget _pricingRow(String label, double amount, {bool isBold = false, Color color = Colors.black}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
//           Text('\$${amount.abs().toStringAsFixed(2)}',
//               style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'pending':
//         return Colors.orange;
//       case 'processing':
//         return Colors.blue;
//       case 'shipped':
//         return Colors.cyan;
//       case 'delivered':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   Color _getFinancialColor(String status) {
//     switch (status) {
//       case 'pending':
//         return Colors.orange;
//       case 'paid':
//         return Colors.green;
//       case 'refunded':
//         return Colors.red;
//       case 'partially_refunded':
//         return Colors.amber;
//       default:
//         return Colors.grey;
//     }
//   }
// }