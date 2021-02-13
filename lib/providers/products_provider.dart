import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_excep.dart';
import 'dart:convert';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  Products(this.authToken,this.userId ,this._items);

  // var _showFavoritesOnly = false;

  List<Product> get favoritesOnly {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  List<Product> get items {
    // if(_showFavoritesOnly){
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  //  showFavoritesOnly(){
  //  _showFavoritesOnly = true;
  //  notifyListeners();
  // }
  // showAll(){
  //   _showFavoritesOnly =false;
  //   notifyListeners();
  // }
  Future<Void> fetchProduct() async {
    var url =
        'https://shop-app-be248-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
     final response =  await http.get(url);
     final extractedData = json.decode(response.body) as Map<String , dynamic>;
     if(extractedData == null){
       return null;
     }
      url = 'https://shop-app-be248-default-rtdb.firebaseio.com/userFavorites/$userId/.json?auth=$authToken ';
     final favoriteResponse = await http.get(url);
     final favoriteDate = json.decode(favoriteResponse.body);
     List<Product> loadedProduct = [];
     extractedData.forEach((prodId, prodData){
       loadedProduct.add(Product(
         id: prodId,
         title: prodData['title'],
         description: prodData['description'],
         price: prodData['price'],
         imageUrl: prodData['imageUrl'],
         isFavorite:favoriteDate == null ? false : favoriteDate[prodId] ?? false,
       ));
       _items = loadedProduct;
       notifyListeners();
     });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product pro) async {
    final url =
        'https://shop-app-be248-default-rtdb.firebaseio.com/products.jsonauth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': pro.title,
            'description': pro.description,
            'imageUrl': pro.imageUrl,
            'price': pro.price,
          }));
      print(json.decode(response.body));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: pro.title,
        description: pro.description,
        price: pro.price,
        imageUrl: pro.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Product findById(String Id) {
    return _items.firstWhere((prod) => prod.id == Id);
  }

  updateProducts(String id, Product newProduct) async{
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final url =
          'https://shop-app-be248-default-rtdb.firebaseio.com/products/$id.jsonauth=$authToken';
     await http.patch(url,body: jsonEncode({
        'title' : newProduct.title,
        'price' : newProduct.price,
        'description'  : newProduct.description,
        'imageUrl' : newProduct.imageUrl,
      }));
      _items[index] = newProduct;
      notifyListeners();
    }
  }

 Future<void> deletePRoducts(String id) async {
    final url =
        'https://shop-app-be248-default-rtdb.firebaseio.com/products/$id.jsonauth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
   final response =  await http.delete(url);
    print(response.statusCode);
    notifyListeners();
      if(response.statusCode >= 400){
        _items.insert(existingProductIndex, existingProduct);
          throw HttpExceptions('Could not delete this product');
      }
      existingProduct = null;



  }
}
