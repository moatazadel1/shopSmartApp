import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_shoppe/constants/assets_manager.dart';
import 'package:smart_shoppe/widgets/text/title_text_widget.dart';
import '../../providers/viewed_recently_provider.dart';
import '../../widgets/cart/empty_cart_widget.dart';
import '../../widgets/product_widget.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  const ViewedRecentlyScreen({super.key});
  static String routName = 'ViewedRecently';

  @override
  Widget build(BuildContext context) {
    ViewedRecentlyProvider viewedRecentlyProvider =
        Provider.of<ViewedRecentlyProvider>(context);

    return viewedRecentlyProvider.getviewedProdItems.isEmpty
        ? Scaffold(
            appBar: AppBar(
              foregroundColor:
                  Theme.of(context).appBarTheme.titleTextStyle!.color,
            ),
            body: SingleChildScrollView(
              child: EmptyCartWidget(
                  subtitle:
                      "Looks like you have not added anything to your viewed recently. Go ahead & explore top categories",
                  imagePath: AssetsManager.orderBag,
                  title: "You didn't view any products yet",
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
                      onTap: () {},
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
                      'Viewed recently (${viewedRecentlyProvider.getviewedProdItems.length})'),
              foregroundColor:
                  Theme.of(context).appBarTheme.titleTextStyle!.color,
            ),
            body: DynamicHeightGridView(
              builder: (context, index) {
                return ProductWidget(
                  productId: viewedRecentlyProvider.getviewedProdItems.values
                      .toList()[index]
                      .productId,
                );
              },
              itemCount: viewedRecentlyProvider.getviewedProdItems.length,
              crossAxisCount: 2,
            ),
          );
  }
}
