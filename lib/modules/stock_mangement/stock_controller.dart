import 'package:get/get.dart';

class StockController extends GetxController {
  // List of stock items
  var stocks = <StockItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStocks();
  }

  // Dummy fetch
  void fetchStocks() {
    stocks.assignAll([
      StockItem(id: 1, name: 'Apple', quantity: 50),
      StockItem(id: 2, name: 'Banana', quantity: 30),
      StockItem(id: 3, name: 'Orange', quantity: 20),
    ]);
  }

  void addStock(StockItem item) {
    stocks.add(item);
  }

  void removeStock(int id) {
    stocks.removeWhere((element) => element.id == id);
  }

  void updateQuantity(int id, int quantity) {
    var index = stocks.indexWhere((element) => element.id == id);
    if (index != -1) {
      stocks[index].quantity = quantity;
      stocks.refresh(); // update UI
    }
  }
}

class StockItem {
  int id;
  String name;
  int quantity;

  StockItem({
    required this.id,
    required this.name,
    required this.quantity,
  });
}
