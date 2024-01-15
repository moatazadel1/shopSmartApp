import 'package:flutter/material.dart';
import '../consts/assets_manager.dart';
import '../screens/edit_upload_product_screen.dart';
import '../screens/inner_screens/orders_screen.dart';
import '../screens/search_screen.dart';

class DashboardModel {
  final String text, imagePath;
  final Function onPressed;

  DashboardModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  static List<DashboardModel> dashboardBtnList(BuildContext context) => [
        DashboardModel(
          text: "Add a new product",
          imagePath: AssetsManager.cloud,
          onPressed: () {
            Navigator.pushNamed(
              context,
              EditOrUploadProductScreen.routeName,
            );
          },
        ),
        DashboardModel(
          text: "inspect all products",
          imagePath: AssetsManager.shoppingCart,
          onPressed: () {
            Navigator.pushNamed(
              context,
              SearchScreen.routeName,
            );
          },
        ),
        DashboardModel(
          text: "View Orders",
          imagePath: AssetsManager.order,
          onPressed: () {
            Navigator.pushNamed(
              context,
              OrdersScreenFree.routeName,
            );
          },
        ),
      ];
}
