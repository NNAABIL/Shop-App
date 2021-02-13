import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'product_item.dart';
class ProductGridView extends StatelessWidget {
final bool showFaves ;
ProductGridView(this.showFaves);
  @override
  Widget build(BuildContext context) {
   final productsData =  Provider.of<Products>(context );
   final products = showFaves ? productsData.favoritesOnly : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (context, i) =>  ChangeNotifierProvider.value(
        value: products[i],
        // create: (c)=>products[i] ,
        child: ProductItem(
          // products[i].id,
          // products[i].title,
          // products[i].imageUrl,
        ),
      ),
      itemCount: products.length,
    );
  }
}