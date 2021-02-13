import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import '../Widgets/cart_item.dart';
import '../providers/Cart.dart';

class CartScreen extends StatelessWidget {
  static const routename = 'cartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                FlatButton(
                  onPressed:
                   cart.totalAmount<=0? null:
                      () async{
                    await Provider.of<Orders>(context, listen: false).addOrder(
                      cart.items.values.toList(),
                      cart.totalAmount,
                    );
                    cart.clearCart();
                  },
                  child: Text(
                    'Order Now',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, i) => CartItem(
              id: cart.items.values.toList()[i].id,
              productId: cart.items.keys.toList()[i],
              title: cart.items.values.toList()[i].title,
              price: cart.items.values.toList()[i].price,
              quantity: cart.items.values.toList()[i].quantity,
            ),
            itemCount: cart.items.length,
          ),
        )
      ]),
    );
  }
}
