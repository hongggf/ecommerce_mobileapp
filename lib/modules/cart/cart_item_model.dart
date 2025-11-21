import 'package:get/get.dart';

class CartItem {
  String id;
  String name;
  String image;
  double price;

  RxInt quantity;
  RxBool isSelected;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required int quantity,
    bool isSelected = false,
  })  : quantity = quantity.obs,
        isSelected = isSelected.obs;
}
