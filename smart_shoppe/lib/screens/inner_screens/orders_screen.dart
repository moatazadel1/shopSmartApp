import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/constants/assets_manager.dart';
import 'package:smart_shoppe/models/orders_model.dart';
import 'package:smart_shoppe/providers/order_provider.dart';
import 'package:smart_shoppe/widgets/cart/empty_cart_widget.dart';
import 'package:smart_shoppe/widgets/orders_widget.dart';
import '../../widgets/text/title_text_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = 'OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreen> {
  bool isEmptyOrders = false;
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).appBarTheme.titleTextStyle!.color,
        title: const TitleTextWidget(
          label: 'Placed orders',
        ),
      ),
      body: FutureBuilder<List<OrdersModel>>(
          future: ordersProvider.fetchOrder(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: SelectableText(
                    "An error has been occured ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || ordersProvider.getOrders.isEmpty) {
              return EmptyCartWidget(
                  imagePath: AssetsManager.orderBag,
                  title: "No orders has been placed yet",
                  subtitle: "",
                  buttonText: "Shop now");
            }
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, index) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: OrdersWidget(
                      ordersModel: ordersProvider.getOrders[index],
                    ));
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  thickness: 2,
                );
              },
            );
          })),
    );
  }
}
