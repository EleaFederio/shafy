import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/cart.dart';

class CartItemScreen extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;


  CartItemScreen(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30.0,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
      ),
      onDismissed: (direction){
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        child: Padding(
          padding: EdgeInsets.all(8.8),
          child: ListTile(
            leading: Chip(
              label: Text(
                '₱ ${price}',
              ),
              backgroundColor: Theme.of(context).primaryTextTheme.bodyText1.backgroundColor,
            ),
            title: Text(title),
            subtitle: Text('₱ ${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text(' ${quantity} X'),
          ),
        ),
      ),
    );
  }
}
