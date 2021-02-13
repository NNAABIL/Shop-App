import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/order_screen.dart';
import 'package:shop_app/Screens/user_products_screen.dart';
import 'package:shop_app/providers/auth.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('hello Friend !'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('shop'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('orders'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(OrderScreen.routename);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Product'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(UserProductScreen.route);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: (){
              Navigator.pop(context);
              Provider.of<Auth>(context,listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
