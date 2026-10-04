import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';

class WishlistController extends GetxController {
  final RxList<ProductModel> wishlistItems = <ProductModel>[].obs;

  bool isInWishlist(String productId) {
    return wishlistItems.any((item) => item.id == productId);
  }

  void toggleWishlist(ProductModel product) {
    final exists = isInWishlist(product.id);
    if (exists) {
      wishlistItems.removeWhere((item) => item.id == product.id);
      if (Get.context != null) {
        Get.snackbar(
          'Removed from Wishlist',
          '${product.name} removed from your saved items.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } else {
      wishlistItems.add(product);
      if (Get.context != null) {
        Get.snackbar(
          'Added to Wishlist',
          '${product.name} saved to your wishlist.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF97316),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    }
  }
}
