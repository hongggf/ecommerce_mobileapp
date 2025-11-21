import 'package:get/get.dart';
import 'cart_item_model.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;
  final selectedItemsCount = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSampleData();
  }

  void _initializeSampleData() {
    cartItems.addAll([
      CartItem(
        id: '1',
        name: 'Nike Air Max 90',
        image: 'https://picsum.photos/300?random=1',
        price: 129.99,
        quantity: 1,
      ),
      CartItem(
        id: '2',
        name: 'Adidas Ultraboost 21',
        image: 'https://picsum.photos/300?random=2',
        price: 189.99,
        quantity: 2,
      ),
      CartItem(
        id: '3',
        name: 'Puma Running Shoes',
        image: 'https://picsum.photos/300?random=3',
        price: 99.99,
        quantity: 1,
      ),
      CartItem(
        id: '4',
        name: 'New Balance 990v5',
        image: 'https://picsum.photos/300?random=4',
        price: 175.00,
        quantity: 1,
      ),
    ]);
  }

  // --------------------------
  // SELECTION LOGIC
  // --------------------------

  void toggleItemSelection(String id) {
    final item = cartItems.firstWhere((i) => i.id == id);
    item.isSelected.toggle();
    updateSelectedCount();
  }

  void selectAllItems(bool select) {
    for (var item in cartItems) {
      item.isSelected.value = select;
    }
    updateSelectedCount();
  }

  void updateSelectedCount() {
    selectedItemsCount.value =
        cartItems.where((item) => item.isSelected.value).length;
  }

  bool isAllSelected() {
    if (cartItems.isEmpty) return false;
    return cartItems.every((item) => item.isSelected.value);
  }

  // --------------------------
  // QUANTITY + DELETE
  // --------------------------

  void increaseQuantity(String id) {
    final item = cartItems.firstWhere((i) => i.id == id);
    item.quantity.value++;
  }

  void decreaseQuantity(String id) {
    final item = cartItems.firstWhere((i) => i.id == id);
    if (item.quantity.value > 1) {
      item.quantity.value--;
    }
  }

  void removeItem(String id) {
    cartItems.removeWhere((i) => i.id == id);
    updateSelectedCount();
  }

  // --------------------------
  // TOTALS
  // --------------------------

  double getSelectedItemsTotal() {
    return cartItems
        .where((i) => i.isSelected.value)
        .fold(0, (sum, item) => sum + (item.price * item.quantity.value));
  }

  double getShippingCost() {
    final total = getSelectedItemsTotal();
    return total > 100 ? 0 : 10.0;
  }

  double getTax() => getSelectedItemsTotal() * 0.1;

  double getGrandTotal() =>
      getSelectedItemsTotal() + getShippingCost() + getTax();

  List<CartItem> getSelectedItems() {
    return cartItems.where((i) => i.isSelected.value).toList();
  }

  // --------------------------
  // ORDER PROCESS
  // --------------------------

  void placeOrder() {
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;

      cartItems.clear();
      selectedItemsCount.value = 0;
    });
  }
}
