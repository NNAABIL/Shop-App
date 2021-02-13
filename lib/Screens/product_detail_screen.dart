
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routename = 'Product Detail';

  @override
  Widget build(BuildContext context) {
    final productId =
    ModalRoute
        .of(context)
        .settings
        .arguments as String; // the id !
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
              width: double.infinity,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 10,),
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  loadedProduct.description, style: TextStyle(fontSize: 20),
                  textAlign:TextAlign.center,),)
          ],
        ),
      ),
    );
  }
}
