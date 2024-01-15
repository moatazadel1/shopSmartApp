import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_shoppe/models/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  final List<OrdersModel> ordersList = [];
  List<OrdersModel> get getOrders => ordersList;
  // final ordersDB = FirebaseFirestore.instance.collection("orders");

  Future<void> removeOrder(String orderId) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
  }

  void removeOneItem({required String productId}) {
    ordersList.removeWhere((element) => element.productId == productId);
    notifyListeners();
  }

  Future<List<OrdersModel>> fetchOrder() async {
    // final auth = FirebaseAuth.instance;
    // User? user = auth.currentUser;
    // var uid = user!.uid;
    try {
      await FirebaseFirestore.instance
          .collection("orders")
          .get()
          .then((orderSnapshot) {
        ordersList.clear();
        for (var element in orderSnapshot.docs) {
          ordersList.insert(
            0,
            OrdersModel(
              orderId: element.get('orderId'),
              productId: element.get('productId'),
              userId: element.get('userId'),
              price: element.get('price').toString(),
              productTitle: element.get('productTitle').toString(),
              quantity: element.get('quantity').toString(),
              imageUrl: element.get('imageUrl'),
              userName: element.get('userName'),
              orderDate: element.get('orderDate'),
            ),
          );
        }
      });
      return ordersList;
    } catch (e) {
      rethrow;
    }
  }
}
