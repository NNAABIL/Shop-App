import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/cart_screen.dart';
import 'package:shop_app/Screens/edit_product_screen.dart';
import 'package:shop_app/Screens/order_screen.dart';
import 'package:shop_app/Screens/user_products_screen.dart';
import 'package:shop_app/providers/Cart.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/orders.dart';

import './providers/products_provider.dart';
import './Screens/product_overview_screen.dart';
import './Screens/product_detail_screen.dart';
import 'Screens/auth_screen.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
            update: (context, auth, oldStatusProduct) => Products(
                auth.token,
                auth.userId,
                oldStatusProduct == null ? [] : oldStatusProduct.items)),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            update: (context, auth, oldStatusOrders) => Orders(
                auth.token,
                auth.userId,
                oldStatusOrders == null ? [] : oldStatusOrders.orders)),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routename: (context) => ProductDetailScreen(),
            CartScreen.routename: (context) => CartScreen(),
            OrderScreen.routename: (context) => OrderScreen(),
            UserProductScreen.route: (context) => UserProductScreen(),
            EditProductScreen.route: (context) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
