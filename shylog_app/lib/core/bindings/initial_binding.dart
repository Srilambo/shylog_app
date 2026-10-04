import 'package:get/get.dart';
import '../../modules/products/controllers/product_controller.dart';
import '../../modules/cart/controllers/cart_controller.dart';
import '../../modules/wishlist/controllers/wishlist_controller.dart';
import '../../modules/navigation/controllers/navigation_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NavigationController>(NavigationController(), permanent: true);
    Get.put<ProductController>(ProductController(), permanent: true);
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<WishlistController>(WishlistController(), permanent: true);
  }
}
