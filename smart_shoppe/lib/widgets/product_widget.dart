import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/constants/app_methods.dart';
import 'package:smart_shoppe/providers/cart_provider.dart';
import 'package:smart_shoppe/providers/product_provider.dart';
import 'package:smart_shoppe/screens/inner_screens/product_details_screen.dart';
import 'package:smart_shoppe/widgets/text/title_text_widget.dart';
import '../models/product_model.dart';
import '../providers/viewed_recently_provider.dart';
import 'heart_button_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });

  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    ViewedRecentlyProvider viewedRecentlyProvider =
        Provider.of<ViewedRecentlyProvider>(context);

    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final ProductModel? findByProductId =
        productProvider.findByProductId(productId: widget.productId);
    Size size = MediaQuery.of(context).size;
    return findByProductId == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                viewedRecentlyProvider.addProductToHistory(
                    productId: findByProductId.productId);
                Navigator.of(context).pushNamed(ProductDetailsScreen.routName,
                    arguments: findByProductId.productId);
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FancyShimmerImage(
                      boxFit: BoxFit.cover,
                      height: size.height * 0.22,
                      imageUrl: findByProductId.productImage,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitleTextWidget(
                          maxLines: 2,
                          fontSize: 15,
                          label: findByProductId.productTitle,
                        ),
                      ),
                      Flexible(
                        child: HeartButtonWidget(
                            productId: findByProductId.productId),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitleTextWidget(
                            maxLines: 2,
                            fontSize: 15,
                            label: findByProductId.productPrice,
                            color: Colors.blueAccent),
                      ),
                      Flexible(
                        child: Material(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            onTap: () async {
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
                                if (!mounted) return;
                                AppMethods.showErrorORWarningDialog(
                                    context: context,
                                    subtitle: '$e',
                                    fct: () {});
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                cartProvider.isProductInCart(
                                        productId: findByProductId.productId)
                                    ? Icons.check
                                    : Icons.add_shopping_cart_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
