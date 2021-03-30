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
    final cart = Provider.of<Cart>(context, listen: false);

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
      confirmDismiss: (direction){
        return showDialog(
          context: context,
          builder: (_context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: <Widget>[
              FlatButton(
              child: Text('No'),
                onPressed: (){
                  // showDialog will return a bool value that can be true or false
                  //in here we set value to flase
                  Navigator.of(_context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: (){
                  Navigator.of(_context).pop(true);
                },
              ),
            ],
          )
        );
        // return Future.value(true);
      },
      onDismissed: (direction){
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        child: Padding(
          padding: EdgeInsets.all(8.8),
          child: ListTile(
            // tileColor: Colors.orange,
            leading: Chip(
              label: Text(
                '₱ ${price}',
              ),
              backgroundColor: Theme.of(context).primaryTextTheme.bodyText1.backgroundColor,
            ),
            title: Text(title),
            subtitle: Text('₱ ${(price * quantity).toStringAsFixed(2)}'),
            trailing: Container(
              height: 60,
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Quantity'),
                  Container(
                    height: 30,
                    width: 100,
                    // color: Theme.of(context).accentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 20,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            child: Icon(
                              Icons.arrow_left,
                            ),
                            onPressed: (){},
                          ),
                        ),
                        Container(
                          width: 30.0,
                          // margin: EdgeInsets.symmetric(horizontal: .0),
                          alignment: Alignment.center,
                          child: Text(
                            '${quantity}',
                            style: TextStyle(
                              fontSize: 15.0
                            ),
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 20,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 3.0),
                            child: Icon(
                              Icons.arrow_right,
                            ),
                            onPressed: () => cart.addQuantity(id),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
