import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Widgets/app_drawer.dart';
import 'package:shop_app/Widgets/order_item.dart';

import '../providers/orders.dart';

class OrderScreen extends StatefulWidget {
  static const routename = 'OrderScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;

  @override
  // void initState() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   Future.delayed(Duration.zero).then((_) async{
  //     await Provider.of<Orders>(context, listen: false).fetchOrders();
  //   });
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: Provider.of<Orders>(context, listen: false).fetchOrders(),
            builder: (context, Snapshot) {
              if (Snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Consumer<Orders>(
                    builder: (context, orderData, child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (context, i) => OrderItem(
                              orderData.orders[i],
                            )));
              }
            }));
  }
}
