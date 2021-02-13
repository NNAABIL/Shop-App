import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    this.id,
    this.productId,
    this.title,
    this.price,
    this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: (context),
            builder: (context) => AlertDialog(
                  title: Text('Are you sure !'),
                  content: Text('Remove item ?'),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('No')),
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Yes')),
                  ],
                ));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle:
                Text('total : \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
