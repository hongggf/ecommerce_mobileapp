import 'package:get/get.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  final RxInt quantity;
  final RxBool isSelected;
  String? size;
  String? color;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.isSelected,
    this.size,
    this.color,
  });
}

class CartController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = true.obs;
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxInt selectedItemsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    cartItems.addAll([
      CartItem(
        id: '1',
        name: 'Premium Nike Running Shoes',
        price: 129.99,
        image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300',
        quantity: 1.obs,
        isSelected: true.obs,
        size: 'M',
        color: 'Black',
      ),
      CartItem(
        id: '2',
        name: 'Adidas Sports Jacket',
        price: 89.99,
        image: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300',
        quantity: 2.obs,
        isSelected: false.obs,
        size: 'L',
        color: 'Blue',
      ),
      CartItem(
        id: '3',
        name: 'Cotton T-Shirt',
        price: 29.99,
        image: 'https://images.unsplash.com/photo-1521572215715-9c6c8dcd1f3d?w=300',
        quantity: 1.obs,
        isSelected: true.obs,
        size: 'M',
        color: 'White',
      ),
    ]);
  }

  bool isAllSelected() {
    if (cartItems.isEmpty) return false;
    return cartItems.every((item) => item.isSelected.value);
  }

  void selectAllItems(bool value) {
    for (var item in cartItems) {
      item.isSelected.value = value;
    }
    _updateSelectedCount();
  }

  void toggleItemSelection(String itemId) {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      cartItems[index].isSelected.toggle();
      _updateSelectedCount();
    }
  }

  void _updateSelectedCount() {
    selectedItemsCount.value = cartItems.where((item) => item.isSelected.value).length;
  }

  void increaseQuantity(String itemId) {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      cartItems[index].quantity.value++;
    }
  }

  void decreaseQuantity(String itemId) {
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1 && cartItems[index].quantity.value > 1) {
      cartItems[index].quantity.value--;
    }
  }

  void removeItem(String itemId) {
    cartItems.removeWhere((item) => item.id == itemId);
    _updateSelectedCount();
  }

  void clearCart() {
    cartItems.clear();
    selectedItemsCount.value = 0;
  }

  double getSelectedItemsTotal() {
    return cartItems
        .where((item) => item.isSelected.value)
        .fold(0, (sum, item) => sum + (item.price * item.quantity.value));
  }

  double getShippingCost() {
    final total = getSelectedItemsTotal();
    return total > 100 ? 0 : 9.99;
  }

  double getTax() {
    return getSelectedItemsTotal() * 0.1;
  }

  double getGrandTotal() {
    return getSelectedItemsTotal() + getShippingCost() + getTax();
  }

  void placeOrder() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
      Get.snackbar('Success', 'Order placed successfully!');
      clearCart();
    });
  }
}