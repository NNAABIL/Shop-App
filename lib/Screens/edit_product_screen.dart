import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const route = 'EditProductScreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _focusNodePrice = FocusNode();
  final _focusNodeDescription = FocusNode();
  final _imageController = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    title: '',
    description: '',
    id: null,
    imageUrl: '',
    price: 0,
  );
  String _title;
  String _price;
  String _description;

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false).findById(productId);
        _title = _editedProduct.title;
        _price = _editedProduct.price.toString();
        _description = _editedProduct.description;
        _imageController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNodeDescription.dispose();
    _focusNodePrice.dispose();
    _imageController.dispose();
    super.dispose();
  }

 Future<void> _saveForm() async {
    if (!_globalKey.currentState.validate()) {
      return;
    }
    _globalKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
     await Provider.of<Products>(context, listen: false)
          .updateProducts(_editedProduct.id, _editedProduct);
    } else {
    try {
      await Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct);
    }catch(error) {
      await showDialog(
          context: context,
          builder: (ctx) =>
              AlertDialog(
                title: Text('An error happened'),
                content: Text('Something went wrong'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('okay'))
                ],
              ));
    }
    // finally{
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Navigator.of(context).pop();
    // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _globalKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _title,
                      validator: (value) {
                        if (value.isEmpty) {
                          return ' Please provide a value.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_focusNodePrice);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: value,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _price,
                      validator: (value) {
                        if (value.isEmpty) {
                          return ' Please provide a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter price greater than zero';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _focusNodePrice,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_focusNodeDescription);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value),
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _description,
                      validator: (value) {
                        if (value.isEmpty) {
                          return ' Please provide a Description.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _focusNodeDescription,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: value,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 10, right: 10),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageController.text.isEmpty
                                ? Text(
                                    'Enter image url',
                                  )
                                : FittedBox(
                                    child: Image.network(_imageController.text),
                                    fit: BoxFit.cover,
                                  )),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return ' Please provide a image url.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please Enter a valid url';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please Enter a valid url';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Image URL'),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageController,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value,
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
