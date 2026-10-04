import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final String selectedSize;
  final String selectedColor;
  int quantity;

  CartItemModel({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });

  double get totalPrice => product.effectivePrice * quantity;
}
