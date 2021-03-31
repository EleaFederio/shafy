import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/orders.dart';
import 'package:shopy/screens/order_item.dart';
import 'package:shopy/widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {

    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, index) => OrderItemScreen(orderData.orders[index]),
      ),
    );
  }
}