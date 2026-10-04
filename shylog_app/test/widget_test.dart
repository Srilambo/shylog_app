import 'package:flutter_test/flutter_test.dart';
import 'package:shylog_app/data/sample_data.dart';
import 'package:shylog_app/modules/cart/controllers/cart_controller.dart';
import 'package:shylog_app/modules/wishlist/controllers/wishlist_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Shylog Store Core Logic Tests', () {
    test('Sample products loaded with discounts and sizes', () {
      expect(SampleData.products.isNotEmpty, true);
      final shirt = SampleData.products.first;
      expect(shirt.name, contains('Shirt'));
      expect(shirt.hasDiscount, true);
      expect(shirt.sizes.isNotEmpty, true);
    });

    test('CartController adds items and computes total with discount', () {
      final cartCtrl = CartController();
      final product = SampleData.products.first;

      cartCtrl.addToCart(product, size: '6-8 Y', color: 'Sky Blue');
      expect(cartCtrl.totalItemCount, 1);
      expect(cartCtrl.subtotal, product.effectivePrice);

      // Apply coupon
      final applied = cartCtrl.applyCoupon('SHYLOG15');
      expect(applied, true);
      expect(cartCtrl.discountPercent.value, 0.15);
      expect(cartCtrl.discountAmount, closeTo(product.effectivePrice * 0.15, 0.01));

      // Remove item
      cartCtrl.clearCart();
      expect(cartCtrl.totalItemCount, 0);
      expect(cartCtrl.subtotal, 0.0);
    });

    test('WishlistController toggles products', () {
      final wishlistCtrl = WishlistController();
      final hoodie = SampleData.products[1];

      expect(wishlistCtrl.isInWishlist(hoodie.id), false);
      wishlistCtrl.toggleWishlist(hoodie);
      expect(wishlistCtrl.isInWishlist(hoodie.id), true);
      wishlistCtrl.toggleWishlist(hoodie);
      expect(wishlistCtrl.isInWishlist(hoodie.id), false);
    });
  });
}
