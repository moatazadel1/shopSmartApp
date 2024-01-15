import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/constants/assets_manager.dart';
import 'package:smart_shoppe/providers/wishlist_provider.dart';
import 'package:smart_shoppe/widgets/text/title_text_widget.dart';
import '../../constants/app_methods.dart';
import '../../widgets/cart/empty_cart_widget.dart';
import '../../widgets/product_widget.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  static String routName = 'Wishlist';

  @override
  Widget build(BuildContext context) {
    WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(context);
    return wishlistProvider.getWishlistItems.isEmpty
        ? Scaffold(
            appBar: AppBar(
              foregroundColor:
                  Theme.of(context).appBarTheme.titleTextStyle!.color,
            ),
            body: SingleChildScrollView(
              child: EmptyCartWidget(
                  imagePath: AssetsManager.bagWish,
                  title: "Your Wishlist is empty",
                  subtitle:
                      "Looks like you have not added anything to your wishlist. Go ahead & explore top categories",
                  buttonText: "Shop Now"),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: const Color(0xffdbe1fd),
                    borderRadius: BorderRadius.circular(10.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      onTap: () {
                        AppMethods.showErrorORWarningDialog(
                            context: context,
                            subtitle: 'Remove all items?',
                            isError: false,
                            fct: () {
                              wishlistProvider.clearLocalWishlist();
                            });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          color: Colors.black,
                          (IconlyBold.delete),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              title: TitleTextWidget(
                  label:
                      'Wishlist (${wishlistProvider.getWishlistItems.length})'),
              foregroundColor:
                  Theme.of(context).appBarTheme.titleTextStyle!.color,
            ),
            body: DynamicHeightGridView(
              builder: (context, index) {
                return ProductWidget(
                  productId: wishlistProvider.getWishlistItems.values
                      .toList()[index]
                      .productId,
                );
              },
              itemCount: wishlistProvider.getWishlistItems.length,
              crossAxisCount: 2,
            ),
          );
  }
}
