import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/Products.dart';
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
  // put value if this screen is used for edit
  var _initValues = {
    'title': '',
    'description': '',
    'price':  '',
    'imageUrl': ''
  };
  var _isInit = true;
  var _isLoading = false;


  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null){
        _editedProduct = Provider.of<Products>(context).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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
      // if(_imageUrlController.text.isEmpty || !_imageUrlController.text.startsWith('http') || !_imageUrlController.text.startsWith('https')
      //     || !_imageUrlController.text.endsWith('.jpeg') || !_imageUrlController.text.endsWith('.jpg') || !_imageUrlController.text.endsWith('.png')){
      //   return;
      // }
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
    // check if product id to be edit or to be save
    setState(() {
      _isLoading = true;
    });
    if(_editedProduct.id != null){
      print('Enter If');
      Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      print("if ${_isLoading}");
      Navigator.of(context).pop();
    }else{
      print('Enter Else');
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct).then((_) {
        setState(() {
          _isLoading = false;
        });
        print("else ${_isLoading}");
        Navigator.of(context).pop();
      });
    }
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
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
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
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite
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
                initialValue: _initValues['price'],
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
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite
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
                initialValue: _initValues['description'],
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
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite
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
                      // initialValue: _initValues['imageUrl'],
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
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite
                        );
                      },
                      validator: (value){
                        // return null means no error
                        if(value.isEmpty){
                          return 'Please Provide a product image URL';
                        }
                        if(!value.startsWith('http') || !value.startsWith('https')){
                          return 'Please enter a valid url';
                        }
                        print(value.endsWith('.jpg'));
                        if(!value.endsWith('.jpeg') && !value.endsWith('.jpg') && !value.endsWith('.png')){
                          return 'Please enter a valid image';
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
