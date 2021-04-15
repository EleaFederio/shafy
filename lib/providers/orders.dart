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

  List<OrderItem> get orders{
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https('iron-stack-263405.firebaseio.com', '/orders.json');
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