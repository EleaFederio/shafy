import 'dart:convert';
import 'package:flutter/material.dart';
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

  Future<void> fetchAndSetProducts() async {
    const url = "iron-stack-263405.firebaseio.com";
    try{
      final response = await http.get(Uri.https('iron-stack-263405.firebaseio.com', '/products.json'));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
            title: value['title'],
            description : value['description'],
            price : value['price'],
            imageUrl : value['imageUrl'],
            isFavorite : value['isFavorite']
        ));
        _items = loadedProducts;
        notifyListeners();
      });
    }catch(error){
      throw error;
    }
  }

  Future<void> addProduct(Product product){

    final url = Uri.https('iron-stack-263405.firebaseio.com', '/products.json');
    //return Future to check if product is added to web server
    // this will determine the value of _isLoading
    return http.post(url, body: json.encode({
      'title': product.title,
      'description' : product.description,
      'price' : product.price,
      'imageUrl' : product.imageUrl,
      'isFavorite' : product.isFavorite
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

  void updateProduct(String id, Product newProduct){
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if(prodIndex >= 0){
      _items[prodIndex] = newProduct;
      notifyListeners();
    }else{
      print('...');
    }
  }

  void deleteProduct(String id){
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

}