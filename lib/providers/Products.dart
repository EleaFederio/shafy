import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopy/models/http_exception.dart';
import 'package:shopy/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get favoriteItems{
    return _items.where((prod) => prod.isFavorite == true).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id){
    return _items.firstWhere((prod) => prod.id == id);
  }

  // ******************* for authentication *********************
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  //*************************************************************

  Future<void> fetchAndSetProducts() async {
    var url = Uri.https('shafy-dbe57-default-rtdb.firebaseio.com', '/products.json', {
      'auth' : authToken,
    });
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null){
        return;
      }
      // url has been override
      url = Uri.https('shafy-dbe57-default-rtdb.firebaseio.com', '/userFavorites/$userId/.json', {
        'auth' : authToken,
      });
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
            title: value['title'],
            description : value['description'],
            price : value['price'],
            imageUrl : value['imageUrl'],
            // ?? check if favoriteData[key] is null
            isFavorite : favoriteData == null ? false : favoriteData[key] ?? false,
        ));
        _items = loadedProducts;
        notifyListeners();
      });
    }catch(error){
      throw error;
    }
  }

  Future<void> addProduct(Product product){
    final url = Uri.https('shafy-dbe57-default-rtdb.firebaseio.com', '/products.json', {
      'auth' : authToken,
    });
    //return Future to check if product is added to web server
    // this will determine the value of _isLoading
    return http.post(url, body: json.encode({
      'title': product.title,
      'description' : product.description,
      'price' : product.price,
      'imageUrl' : product.imageUrl
    }),).then((response){
      final newProduct = Product(
          // ****** save local  ******* //
          // id: DateTime.now().toString(),
          // ****** save on server  ******* //
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct);
      notifyListeners();
    }).catchError((error){
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if(prodIndex >= 0){
      await http.patch(Uri.https('shafy-dbe57-default-rtdb.firebaseio.com', '/products/$id.json', {
        'auth' : authToken,
      }), body: json.encode({
        'title': newProduct.title,
        'description' : newProduct.description,
        'imageUrl' : newProduct.imageUrl,
        'price' : newProduct.price
      }));
      print(newProduct);
      _items[prodIndex] = newProduct;
      notifyListeners();
    }else{
      print('...');
    }
  }

  Future <void> deleteProduct(String id) async{
    final url = Uri.https('shafy-dbe57-default-rtdb.firebaseio.com', '/products/$id', {
      'auth' : authToken,
    });
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    // if delete fail product will revert/rollback
    final response = await http.delete(url);
    if(response.statusCode >= 400){
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Can't Delete Product");
    }
    existingProduct = null;
    _items.removeAt(existingProductIndex);
    notifyListeners();
  }

}