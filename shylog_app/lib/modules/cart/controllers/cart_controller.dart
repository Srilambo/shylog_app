import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxString appliedCoupon = ''.obs;
  final RxDouble discountPercent = 0.0.obs;

  int get totalItemCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * discountPercent.value;

  double get shippingFee => (subtotal > 50.0 || cartItems.isEmpty) ? 0.0 : 5.99;

  double get grandTotal => subtotal - discountAmount + shippingFee;

  void addToCart(ProductModel product, {String? size, String? color}) {
    final chosenSize = size ?? (product.sizes.isNotEmpty ? product.sizes.first : 'Medium');
    final chosenColor = color ?? (product.colors.isNotEmpty ? product.colors.first : 'Navy');

    final index = cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == chosenSize &&
          item.selectedColor == chosenColor,
    );

    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItemModel(
          product: product,
          selectedSize: chosenSize,
          selectedColor: chosenColor,
          quantity: 1,
        ),
      );
    }

    if (Get.context != null) {
      Get.snackbar(
        'Added to Cart',
        '${product.name} ($chosenSize) added.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void incrementQuantity(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  void decrementQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
    } else {
      removeFromCart(index);
    }
  }

  void removeFromCart(int index) {
    final removed = cartItems.removeAt(index);
    if (Get.context != null) {
      Get.snackbar(
        'Item Removed',
        '${removed.product.name} removed from your cart.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  bool applyCoupon(String code) {
    final clean = code.trim().toUpperCase();
    if (clean == 'SHYLOG15' || clean == 'BOYS15') {
      appliedCoupon.value = clean;
      discountPercent.value = 0.15;
      if (Get.context != null) {
        Get.snackbar(
          'Coupon Applied!',
          '15% discount applied to your order.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF16A34A),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
      return true;
    } else {
      if (Get.context != null) {
        Get.snackbar(
          'Invalid Coupon',
          'Try using coupon "SHYLOG15" for 15% off.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFDC2626),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
      return false;
    }
  }

  void clearCart() {
    cartItems.clear();
    appliedCoupon.value = '';
    discountPercent.value = 0.0;
  }
}
