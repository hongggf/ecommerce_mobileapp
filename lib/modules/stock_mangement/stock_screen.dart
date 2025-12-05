import 'package:ecommerce_urban/modules/stock_mangement/stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StockScreen extends GetView<StockController> {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add a dummy stock for testing
              controller.addStock(
                StockItem(id: controller.stocks.length + 1, name: 'New Item', quantity: 10),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.stocks.isEmpty) {
          return const Center(child: Text('No stock available'));
        }
        return ListView.builder(
          itemCount: controller.stocks.length,
          itemBuilder: (context, index) {
            final item = controller.stocks[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(item.name),
                subtitle: Text('Quantity: ${item.quantity}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (item.quantity > 0) {
                          controller.updateQuantity(item.id, item.quantity - 1);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        controller.updateQuantity(item.id, item.quantity + 1);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        controller.removeStock(item.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
