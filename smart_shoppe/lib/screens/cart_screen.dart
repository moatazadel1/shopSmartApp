import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/constants/app_methods.dart';
import 'package:smart_shoppe/constants/assets_manager.dart';
import 'package:smart_shoppe/providers/cart_provider.dart';
import 'package:smart_shoppe/providers/product_provider.dart';
import 'package:smart_shoppe/providers/user_provider.dart';
import 'package:smart_shoppe/widgets/cart/cart_widget.dart';
import 'package:smart_shoppe/widgets/text/title_text_widget.dart';
import 'package:uuid/uuid.dart';
import '../widgets/cart/bottom_checkout_cart_widget.dart';
import '../widgets/cart/empty_cart_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: SingleChildScrollView(
              child: EmptyCartWidget(
                  imagePath: AssetsManager.shoppingCart,
                  title: "Your cart is empty",
                  subtitle:
                      "Looks like you have not added anything to your cart. Go ahead & explore top categories",
                  buttonText: "Shop Now"),
            ),
          )
        : Scaffold(
            bottomSheet: BottomCheckoutCartWidget(function: () async {
              await placeOrder(
                cartProvider: cartProvider,
                productProvider: productProvider,
                userProvider: userProvider,
              );
            }),
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      onTap: () {
                        AppMethods.showErrorORWarningDialog(
                            context: context,
                            subtitle: 'Remove all items?',
                            isError: false,
                            fct: () async {
                              // cartProvider.clearLocalCart();
                              await cartProvider.clearCartFromFirebase();
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle!
                              .color,
                          (IconlyBold.delete),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              title: TitleTextWidget(
                  label: 'Cart (${cartProvider.getCartItems.length})'),
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  AssetsManager.shoppingCart,
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cartProvider.getCartItems.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                          value: cartProvider.getCartItems.values
                              .toList()
                              .reversed
                              .toList()[index],
                          child: const CartWidget());
                    },
                  ),
                ),
                const SizedBox(
                  height: kBottomNavigationBarHeight + 10,
                ),
              ],
            ),
          );
  }

  Future<void> placeOrder({
    required CartProvider cartProvider,
    required ProductProvider productProvider,
    required UserProvider userProvider,
  }) async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() {
        isLoading = true;
      });
      cartProvider.getCartItems.forEach((key, value) async {
        final getCurrProduct =
            productProvider.findByProductId(productId: value.productId);
        final orderId = const Uuid().v4();
        await FirebaseFirestore.instance.collection("orders").doc(orderId).set({
          'orderId': orderId,
          'userId': uid,
          'productId': value.productId,
          "productTitle": getCurrProduct!.productTitle,
          'price': double.parse(getCurrProduct.productPrice) * value.quantity,
          'totalPrice':
              cartProvider.getTotalPrice(productProvider: productProvider),
          'quantity': value.quantity,
          'imageUrl': getCurrProduct.productImage,
          'userName': userProvider.getUserModel!.userName,
          'orderDate': Timestamp.now(),
        });
      });
      await cartProvider.clearCartFromFirebase();
      cartProvider.clearLocalCart();
    } catch (e) {
      if (!mounted) return;
      AppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
