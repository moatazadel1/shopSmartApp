import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/models/product_model.dart';
import 'package:smart_shoppe/widgets/heart_button_widget.dart';
import 'package:smart_shoppe/widgets/text/text_effect_widget.dart';
import 'package:smart_shoppe/widgets/text/title_text_widget.dart';
import '../../constants/app_methods.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/text/subtitle_text_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  static String routName = "productDetails";
  const ProductDetailsScreen({super.key});
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    Size size = MediaQuery.of(context).size;
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final String productId =
        ModalRoute.of(context)!.settings.arguments as String;
    final ProductModel? findByProductId =
        productProvider.findByProductId(productId: productId);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).appBarTheme.titleTextStyle!.color,
        title: const TextEffectWidget(
          fontSize: 20,
          label: 'SmartShoppe',
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {},
                child: Badge(
                  alignment: Alignment.topLeft,
                  textColor: Colors.white,
                  label: const Text("4"),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(IconlyLight.bag2,
                        color: Theme.of(context)
                            .appBarTheme
                            .titleTextStyle!
                            .color),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: findByProductId == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: Column(
                children: [
                  FancyShimmerImage(
                    imageUrl: findByProductId.productImage,
                    height: size.height * 0.38,
                    width: double.infinity,
                    boxFit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TitleTextWidget(
                                label: findByProductId.productTitle,
                                fontSize: 18,
                                maxLines: 2,
                              ),
                            ),
                            SubtitleTextWidget(
                              label: "\$${findByProductId.productPrice}",
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: const CircleBorder()),
                                onPressed: () {},
                                child: HeartButtonWidget(
                                    productId: findByProductId.productId),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight - 10,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (cartProvider.isProductInCart(
                                          productId:
                                              findByProductId.productId)) {
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
                                    icon: Icon(
                                      cartProvider.isProductInCart(
                                              productId:
                                                  findByProductId.productId)
                                          ? Icons.check
                                          : Icons.add_shopping_cart_outlined,
                                      size: 22,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      cartProvider.isProductInCart(
                                              productId:
                                                  findByProductId.productId)
                                          ? "Already in cart"
                                          : "Add to cart",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TitleTextWidget(label: "About this item"),
                              SubtitleTextWidget(
                                  label:
                                      'In ${findByProductId.productCategory}')
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SubtitleTextWidget(
                            label: findByProductId.productDescription,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
