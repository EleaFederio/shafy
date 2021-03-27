import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/cart.dart';
import 'package:shopy/providers/orders.dart';
import 'package:shopy/screens/cart_item_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      'Total',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Chip(
                      label: Text(
                          '₱ ${cart.totalAmount}',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).primaryTextTheme.title.color,
                        ),
                      ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  FlatButton(
                      onPressed: (){
                        Provider.of<Orders>(context, listen: false).addOrder(
                            cart.items.values.toList(),
                            cart.totalAmount
                        );
                        cart.clear();
                      },
                      child: Text('Check Out'),
                    color: Theme.of(context).accentColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) => CartItemScreen(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].title
              ),
            ),
          ),
        ],
      ),
    );
  }
}
