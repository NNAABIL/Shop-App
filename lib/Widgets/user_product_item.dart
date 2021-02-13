import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/edit_product_screen.dart';
import 'package:shop_app/providers/products_provider.dart';
class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem({@required this.id,@required this.title, @required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(icon: Icon(Icons.edit), onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.route,arguments: id);
          }),
          IconButton(icon: Icon(Icons.delete,color: Theme.of(context).errorColor,),
              onPressed: () async{
            try {
              await Provider.of<Products>(context, listen: false)
                  .deletePRoducts(id);
            }catch(e) {
              scaffold.removeCurrentSnackBar();
              scaffold.showSnackBar(SnackBar(content: Text('Deleting failed')));
            }
          }),
        ],),
      ),
    );
  }
}
