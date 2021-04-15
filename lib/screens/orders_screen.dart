import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/orders.dart';
import 'package:shopy/screens/order_item.dart';
import 'package:shopy/widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, dataSnapshot) {
          if(dataSnapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            if(dataSnapshot.error != null){
              return Center(
                child: Text('An Error Occurred!'),
              );
            }else{
              return Consumer<Orders>(builder: (context, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (context, index) => OrderItemScreen(orderData.orders[index]),
              ),);
            }
          }
        },
      )
    );
  }
}
