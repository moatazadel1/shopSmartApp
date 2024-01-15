import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/providers/cart_provider.dart';

import '../../models/cart_model.dart';

class QuantityBottomSheetCartWidget extends StatelessWidget {
  const QuantityBottomSheetCartWidget({super.key, required this.cartModel});
  final CartModel cartModel;

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Container(
            width: 50,
            height: 6,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: 15,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    cartProvider.updateQuantity(
                      productId: cartModel.productId,
                      quantity: index + 1,
                    );
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
