import 'package:flutter/material.dart';
import 'package:shopy/providers/product.dart';

class EditProductScreen extends StatefulWidget {

  static const routeName = '/edit-products-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =  Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: ''
  );


  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl(){
  //  Check if there is focus on url formField
    if(!_imageUrlFocusNode.hasFocus){
      if(_imageUrlController.text.isEmpty || !_imageUrlController.text.startsWith('http') || !_imageUrlController.text.startsWith('https')
          || !_imageUrlController.text.endsWith('.jpeg') || !_imageUrlController.text.endsWith('.jpg') || !_imageUrlController.text.endsWith('.png')){
        return;
      }
      setState(() {

      });
    }
  }

  void _saveForm(){
    final isValid = _form.currentState.validate();
    if(!isValid){
      return;
    }
    _form.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.price.toString());
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter Product Title...',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  //Target price FocusNode
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(
                    title: value,
                    price:  _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: null
                  );
                },
                validator: (value){
                  // return null means no error
                  if(value.isEmpty){
                    return 'Please Provide a product title';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter Price Here...',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value){
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price:  double.parse(value),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: null
                  );
                },
                validator: (value){
                  // return null means no error
                  if(value.isEmpty){
                    return 'Please Provide a product price';
                  }
                  if(double.tryParse(value) == null){
                    return 'Please Provide a valid price';
                  }
                  if(double.parse(value) <= 0){
                    return 'Please Provide a price greater than 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Description'
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocusNode,
                onSaved: (value){
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price:  _editedProduct.price,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      id: null
                  );
                },
                validator: (value){
                  // return null means no error
                  if(value.isEmpty){
                    return 'Please Provide a product description';
                  }
                  if(value.length < 10){
                    return 'At least 10 characters';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100.0,
                    height: 100.0,
                    margin: EdgeInsets.only(top: 8.0, right: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: Colors.grey
                      )
                    ),
                    child: _imageUrlController.text.isEmpty?
                        Text('Enter A URL') :
                        FittedBox(
                          child: Image.network(
                            _imageUrlController.text,
                          ),
                          fit: BoxFit.cover,
                        )
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_){
                        _saveForm();
                      },
                      onSaved: (value){
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price:  _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: value,
                            id: null
                        );
                      },
                      validator: (value){
                        // return null means no error
                        if(value.isEmpty){
                          return 'Please Provide a product inage URL';
                        }
                        if(!value.startsWith('http') || !value.startsWith('https')){
                          return 'Please enter a valid url';
                        }
                        if(!value.endsWith('.jpeg') || !value.endsWith('.jpg') || !value.endsWith('.png')){
                          return 'Please enter a valid url';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
