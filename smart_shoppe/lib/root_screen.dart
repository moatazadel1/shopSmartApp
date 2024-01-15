import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/providers/product_provider.dart';
import 'package:smart_shoppe/screens/cart_screen.dart';
import 'package:smart_shoppe/screens/home_screen.dart';
import 'package:smart_shoppe/screens/profile_screen.dart';
import 'package:smart_shoppe/screens/search_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'providers/wishlist_provider.dart';

class RootScreen extends StatefulWidget {
  static const routName = 'RootScreen';

  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late PageController controller;
  int currentPage = 0;
  bool _isLoading = true;
  List<Widget> destinations = [];
  List<Widget> widgets = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentPage);
  }

  Future<void> fetchFCT() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      Future.wait({
        productProvider.fetchData(),
        userProvider.fetchUserInfo(),
      });
      Future.wait({
        cartProvider.fetchCart(),
        wishlistProvider.fetchWishlist(),
      });
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  @override
  void didChangeDependencies() {
    if (_isLoading) {
      fetchFCT();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: PageView(
        // physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: widgets,
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
      ),
      bottomNavigationBar: NavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedIndex: currentPage,
          elevation: 2,
          height: kBottomNavigationBarHeight,
          onDestinationSelected: (value) {
            setState(() {
              currentPage = value;
            });
            controller.jumpToPage(currentPage);
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(IconlyLight.home),
              label: 'Home',
              selectedIcon: Icon(
                IconlyBold.home,
              ),
            ),
            const NavigationDestination(
              icon: Icon(IconlyLight.search),
              label: 'Search',
              selectedIcon: Icon(
                IconlyBold.search,
              ),
            ),
            NavigationDestination(
              icon: Badge(
                textColor: Colors.white,
                label: Text(cartProvider.getCartItems.length.toString()),
                child: const Icon(IconlyLight.bag2),
              ),
              label: 'Cart',
              selectedIcon: const Icon(
                IconlyBold.bag2,
              ),
            ),
            const NavigationDestination(
              icon: Icon(IconlyLight.profile),
              label: 'Profile',
              selectedIcon: Icon(
                IconlyBold.profile,
              ),
            ),
          ]),
    );
  }
}
