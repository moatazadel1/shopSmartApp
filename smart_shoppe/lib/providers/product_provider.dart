import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_shoppe/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductModel> _productList = [];

  List<ProductModel> get getProductList {
    return _productList;
  }

  ProductModel? findByProductId({required String productId}) {
    if (_productList
        .where((element) => element.productId == productId)
        .isEmpty) {
      return null;
    }
    return _productList.firstWhere((element) => element.productId == productId);
  }

  List<ProductModel> findByCategory({required String categoryName}) {
    List<ProductModel> categoryList = _productList
        .where((element) =>
            element.productCategory.toLowerCase() == categoryName.toLowerCase())
        .toList();
    return categoryList;
  }

  List<ProductModel> searchQuery(
      {required String searchText, required List<ProductModel> passedList}) {
    List<ProductModel> searchList = passedList
        .where((element) => element.productTitle
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
    return searchList;
  }

  final collection = FirebaseFirestore.instance.collection("products");

  Future<List<ProductModel>> fetchData() async {
    try {
      await collection.orderBy('createdAt').get().then((value) {
        _productList.clear();

        for (var element in value.docs) {
          _productList.insert(0, ProductModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return _productList;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ProductModel>> fetchDataStream() {
    try {
      return collection.snapshots().map((event) {
        _productList.clear();
        for (var element in event.docs) {
          _productList.insert(0, ProductModel.fromFirestore(element));
        }
        return _productList;
      });
    } catch (e) {
      rethrow;
    }
  }

  // final List<ProductModel> _productList = [
  //   ProductModel(
  //     productId: 'iphone15-128gb-black',
  //     productTitle: 'Apple iPhone 15 pro (128Gb) - Black',
  //     productPrice: '1399.39',
  //     productCategory: 'Phones',
  //     productDescription:
  //         'The iPhone 15 pro series offered upgrades in performance, camera capabilities, and display features compared to its predecessors, maintaining a similar design language while refining and enhancing the user experience',
  //     productImage: AppConstants.productImgUrl,
  //     productQuantity: '10',
  //   ),
  // ];
}
