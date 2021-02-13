import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class CartItems {
  final String id;
  final String title;
  final double price;
  int quantity;

  CartItems({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  List<CartItems> _cart =[];
  Map<String, CartItems> _items = {};

  _dummyAdd(Product item){
    for (int i = 0; i< _cart.length;i++){
      if(_cart[i].id == item.id){
        _cart[i].quantity++;
      } else {
        _cart.add(CartItems(id: item.id, title: item.title, price: item.price, quantity: 1));
      }
    }
  }

  Map<String, CartItems> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, CartItems) {
      total += CartItems.quantity * CartItems.price;
    });
    return total;
  }

  addItems(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItems) => CartItems(
                id: existingCartItems.id,
                title: existingCartItems.title,
                price: existingCartItems.price,
                quantity: existingCartItems.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItems(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItems(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  clearCart() {
    _items = {};
    notifyListeners();
  }
}
