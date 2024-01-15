import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/providers/cart_provider.dart';
import 'package:smart_shoppe/widgets/heart_button_widget.dart';
import '../../models/cart_model.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../text/subtitle_text_widget.dart';
import '../text/title_text_widget.dart';
import 'quantity_bottom_sheet_widget.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final CartModel cartModelProvider = Provider.of<CartModel>(context);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final ProductModel? findByProductId =
        productProvider.findByProductId(productId: cartModelProvider.productId);

    Size size = MediaQuery.of(context).size;
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    return findByProductId == null
        ? const SizedBox.shrink()
        : FittedBox(
            child: IntrinsicWidth(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FancyShimmerImage(
                        boxFit: BoxFit.contain,
                        height: size.height * 0.2,
                        width: size.height * 0.2,
                        imageUrl: findByProductId.productImage,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.6,
                                child: TitleTextWidget(
                                    maxLines: 2,
                                    label: findByProductId.productTitle),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await cartProvider
                                          .removeCartItemFromFirebase(
                                              cartId: cartModelProvider.cartId,
                                              productId:
                                                  cartModelProvider.productId,
                                              qty: cartModelProvider.quantity);
                                      // cartProvider.removeOneItem(
                                      //     productId: findByProductId.productId);
                                    },
                                    icon: const Icon(IconlyLight.closeSquare),
                                  ),
                                  HeartButtonWidget(
                                      productId: findByProductId.productId)
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SubtitleTextWidget(
                                  label: '\$${findByProductId.productPrice}'),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Theme.of(context)
                                      .appBarTheme
                                      .titleTextStyle!
                                      .color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  side: BorderSide(
                                    color: Theme.of(context).highlightColor,
                                    width: 2,
                                  ),
                                ),
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    shape: const OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      ),
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    context: context,
                                    builder: (context) {
                                      return QuantityBottomSheetCartWidget(
                                        cartModel: cartModelProvider,
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(IconlyLight.arrowDown2),
                                label: Text(
                                  'Qty:${cartModelProvider.quantity}',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
