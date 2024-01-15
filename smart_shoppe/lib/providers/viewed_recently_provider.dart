import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/viewed_recently_model.dart';

class ViewedRecentlyProvider with ChangeNotifier {
  final Map<String, ViewedRecentlyModel> _viewedProdItems = {};

  Map<String, ViewedRecentlyModel> get getviewedProdItems {
    return _viewedProdItems;
  }

  void addProductToHistory({required String productId}) {
    _viewedProdItems.putIfAbsent(
      productId,
      () => ViewedRecentlyModel(
        id: const Uuid().v4(),
        productId: productId,
      ),
    );

    notifyListeners();
  }
}
