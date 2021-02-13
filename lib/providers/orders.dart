import 'dart:convert';

import 'package:shop_app/providers/Cart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrderItems {
  final String id;
  final double amount;
  final List<CartItems> products;
  final DateTime dateTime;

  OrderItems({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItems> _oredrs = [];
 final String authToken;
 final String userId;

  Orders(this.authToken,this.userId ,this._oredrs);
  List<OrderItems> get orders {
    return [..._oredrs];
  }

  Future<void> fetchOrders() async {
    final url =
        'https://shop-app-be248-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    print(json.decode(response.body));
    final List<OrderItems> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItems(
        id: orderId,
        amount: orderData['amount'],
        products: orderData['product']
            .map(
              (item) => CartItems(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                quantity: item['quantity'],
              ),
            )
            .toList(),
        dateTime: DateTime.parse(orderData['dateTime']),
      ));
    });
    _oredrs = loadedOrders;
    notifyListeners();
  }

  void addOrder(List<CartItems> cartProduct, double total) async {
    final url =
        'https://shop-app-be248-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': DateTime.now().toIso8601String(),
          'product': cartProduct
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity
                  })
              .toList()
        }));
    _oredrs.insert(
        0,
        OrderItems(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProduct,
          dateTime: DateTime.now(),
        ));
    notifyListeners();
  }
}
