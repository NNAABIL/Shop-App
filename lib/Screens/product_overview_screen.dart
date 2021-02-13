import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/cart_screen.dart';
import 'package:shop_app/providers/products_provider.dart';

import '../Widgets/app_drawer.dart';
import '../Widgets/productGrid.dart';
import '../Widgets/badge.dart';
import '../providers/Cart.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isLoading = false;
  // @override
  // void initState() {
  //   Provider.of<Products>(context).fetchProduct();
  //
  //
  //   Future.delayed(Duration.zero).then((value) {
  //     Provider.of<Products>(context).fetchProduct();
  //   });
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
        Provider.of<Products>(context,listen: false).fetchProduct();
        setState(() {
          _isLoading = false;
        });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop app'),
        actions: [
          PopupMenuButton(
            onSelected: (int selectedValue) {
              setState(() {
                if (selectedValue == 0) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Only Favorites',
                ),
                value: 0,
              ),
              PopupMenuItem(
                child: Text(
                  'Show All',
                ),
                value: 1,
              )
            ],
            icon: Icon(
              Icons.more_vert,
            ),
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routename);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading? Center(child: CircularProgressIndicator(),): ProductGridView(_showOnlyFavorites),
    );
  }
}
