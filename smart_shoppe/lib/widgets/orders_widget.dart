import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/constants/app_constants.dart';
import 'package:smart_shoppe/models/orders_model.dart';
import 'package:smart_shoppe/providers/order_provider.dart';
import 'text/subtitle_text_widget.dart';
import 'text/title_text_widget.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({
    super.key,
    required this.ordersModel,
  });
  final OrdersModel ordersModel;

  @override
  State<OrdersWidget> createState() => _OrdersWidgetFreeState();
}

class _OrdersWidgetFreeState extends State<OrdersWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrdersProvider>(context);
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              boxFit: BoxFit.contain,
              height: size.width * 0.25,
              width: size.width * 0.25,
              imageUrl: AppConstants.productImgUrl,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitleTextWidget(
                          label: widget.ordersModel.productTitle,
                          maxLines: 2,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await orderProvider
                                .removeOrder(widget.ordersModel.orderId);
                            orderProvider.removeOneItem(
                                productId: widget.ordersModel.orderId);
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.red,
                            size: 22,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      const TitleTextWidget(
                        label: 'Price:  ',
                        fontSize: 15,
                      ),
                      Flexible(
                        child: SubtitleTextWidget(
                          label: "\$ ${widget.ordersModel.price}",
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SubtitleTextWidget(
                    label: "Qty: ${widget.ordersModel.quantity}",
                    fontSize: 15,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
