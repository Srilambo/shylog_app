import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../controllers/navigation_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../../home/views/home_view.dart';
import '../../products/views/product_listing_view.dart';
import '../../wishlist/views/wishlist_view.dart';
import '../../cart/views/cart_view.dart';
import '../../profile/views/profile_view.dart';

class MainNavigationShell extends StatelessWidget {
  const MainNavigationShell({super.key});

  static const List<Widget> _pages = [
    HomeView(),
    ProductListingView(),
    WishlistView(),
    CartView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.find<NavigationController>();
    final cartCtrl = Get.find<CartController>();
    final wishlistCtrl = Get.find<WishlistController>();

    final isDesktop = Breakpoints.isDesktop(context);

    return Obx(() {
      final selectedIndex = navCtrl.currentIndex.value;

      if (isDesktop) {
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: (idx) => navCtrl.changePage(idx),
                labelType: NavigationRailLabelType.all,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'SHYLOG',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                destinations: [
                  const NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.grid_view_outlined),
                    selectedIcon: Icon(Icons.grid_view),
                    label: Text('Shop'),
                  ),
                  NavigationRailDestination(
                    icon: Obx(() => badges.Badge(
                          showBadge: wishlistCtrl.wishlistItems.isNotEmpty,
                          badgeContent: Text(
                            '${wishlistCtrl.wishlistItems.length}',
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          child: const Icon(Icons.favorite_border),
                        )),
                    selectedIcon: const Icon(Icons.favorite),
                    label: const Text('Wishlist'),
                  ),
                  NavigationRailDestination(
                    icon: Obx(() => badges.Badge(
                          showBadge: cartCtrl.totalItemCount > 0,
                          badgeContent: Text(
                            '${cartCtrl.totalItemCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          child: const Icon(Icons.shopping_bag_outlined),
                        )),
                    selectedIcon: const Icon(Icons.shopping_bag),
                    label: const Text('Cart'),
                  ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: _pages[selectedIndex]),
            ],
          ),
        );
      }

      // Mobile & Tablet: BottomNavigationBar
      return Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (idx) => navCtrl.changePage(idx),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Obx(() => badges.Badge(
                    showBadge: wishlistCtrl.wishlistItems.isNotEmpty,
                    badgeContent: Text(
                      '${wishlistCtrl.wishlistItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    child: const Icon(Icons.favorite_border),
                  )),
              activeIcon: const Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Obx(() => badges.Badge(
                    showBadge: cartCtrl.totalItemCount > 0,
                    badgeContent: Text(
                      '${cartCtrl.totalItemCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    child: const Icon(Icons.shopping_bag_outlined),
                  )),
              activeIcon: const Icon(Icons.shopping_bag),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
