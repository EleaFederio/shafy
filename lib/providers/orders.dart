import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shopy/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  // final String imageUrl;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];
  final String authToken;


  Orders(this.authToken, this._orders);

  List<OrderItem> get orders{
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https('shafy-dbe57-default-rtdb.firebaseio.com', '/orders.json?auth=$authToken');
    final response = await http.get(url);
  //  ****************************************  //
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // avoid loop without order
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        products: (orderData['products'] as List<dynamic>).map((item) => CartItem(
          id: item['id'],
          title: item['title'],
          price: item['price'],
          quantity: item['quantity']
        )).toList(),
        dateTime: DateTime.parse(orderData['dateTime']),
      ));
    });
    // reverse the orders arrangement
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
   }

  void addOrder(List<CartItem> cartProducts, double total) async {
    print('+++++++++++++++++++++++++++++++++');
    print(authToken);
    final url = Uri.https('shafy-dbe57-default-rtdb.firebaseio.com', '/orders.json?auth=$authToken');
    final timeStamp = DateTime.now();
    final response = await http.post(url, body: json.encode({
      'amount': total,
      'products': cartProducts.map((cardProduct) => {
        'id' : cardProduct.id,
        'title' : cardProduct.title,
        'quantity' : cardProduct.quantity,
        'price' : cardProduct.price
      }).toList(),
      'dateTime': timeStamp.toIso8601String()
    }));
    _orders.insert(0, OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp
    ));
  }

}