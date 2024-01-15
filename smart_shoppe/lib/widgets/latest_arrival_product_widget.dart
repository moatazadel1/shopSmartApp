import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/constants/app_methods.dart';
import 'package:smart_shoppe/models/product_model.dart';
import 'package:smart_shoppe/screens/inner_screens/product_details_screen.dart';
import 'package:smart_shoppe/widgets/heart_button_widget.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/viewed_recently_provider.dart';
import 'text/subtitle_text_widget.dart';
import 'text/title_text_widget.dart';

class LatestArrivalProductWidget extends StatelessWidget {
  const LatestArrivalProductWidget({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    final ProductModel? findByProductId =
        productProvider.findByProductId(productId: productId);

    Size size = MediaQuery.of(context).size;
    ViewedRecentlyProvider viewedRecentlyProvider =
        Provider.of<ViewedRecentlyProvider>(context);
    ProductModel productModel = Provider.of<ProductModel>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 10),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            viewedRecentlyProvider.addProductToHistory(
                productId: findByProductId.productId);
            Navigator.of(context).pushNamed(ProductDetailsScreen.routName,
                arguments: findByProductId.productId);
          },
          child: SizedBox(
            width: size.width * 0.45,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FancyShimmerImage(
                      boxFit: BoxFit.cover,
                      imageUrl: productModel.productImage,
                      width: size.width * 0.28,
                      height: size.width * 0.28,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTextWidget(
                        label: productModel.productTitle,
                        maxLines: 2,
                        fontSize: 16,
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            HeartButtonWidget(
                                productId: productModel.productId),
                            IconButton(
                              onPressed: () async {
                                if (cartProvider.isProductInCart(
                                    productId: findByProductId.productId)) {
                                  return;
                                }
                                try {
                                  await cartProvider.addToCartFirebase(
                                    context: context,
                                    productId: findByProductId.productId,
                                    qty: 1,
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  AppMethods.showErrorORWarningDialog(
                                      context: context,
                                      subtitle: '$e',
                                      fct: () {});
                                }
                              },
                              icon: Icon(
                                cartProvider.isProductInCart(
                                        productId: findByProductId!.productId)
                                    ? Icons.check
                                    : Icons.add_shopping_cart_outlined,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: SubtitleTextWidget(
                          label: "\$${productModel.productPrice}",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
