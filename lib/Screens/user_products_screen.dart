import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/edit_product_screen.dart';
import 'package:shop_app/Widgets/app_drawer.dart';
import 'package:shop_app/Widgets/user_product_item.dart';
import '../providers/products_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const route = 'UserProductScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.route);
          })
        ],
        title: Text('Your Products'),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
         await Provider.of<Products>(context,listen: false).fetchProduct();
         print('refreshed');
        },
           child: Consumer<Products>(
            builder: (_, product, ch) =>

                ListView.builder(
                  itemCount: product.items.length,
                  itemBuilder: (ctx, i) => Column(
                    children: [UserProductItem(
                      id: product.items[i].id,
                      title: product.items[i].title,
                      imageUrl: product.items[i].imageUrl,
                    ),
                      Divider(),
                  ],
                  ),
                ),
        ),
         ),
    );
  }
}
