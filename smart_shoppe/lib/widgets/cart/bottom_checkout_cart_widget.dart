import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../text/subtitle_text_widget.dart';
import '../text/title_text_widget.dart';

class BottomCheckoutCartWidget extends StatelessWidget {
  const BottomCheckoutCartWidget({super.key, required this.function});
  final Function function;

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: TitleTextWidget(
                        fontSize: 15,
                        label:
                            "Total (${cartProvider.getCartItems.length} Products/${cartProvider.getQty()} Items)",
                      ),
                    ),
                    SubtitleTextWidget(
                      fontSize: 15,
                      label:
                          "${cartProvider.getTotalPrice(productProvider: productProvider)}\$",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 234, 237, 238),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  await function();
                },
                child: const Text(
                  "Checkout",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
