import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopy/providers/orders.dart' as ordz;

class OrderItemScreen extends StatefulWidget {

  // this will be done it there is a conflict in a class Names
  final ordz.OrderItem order;
  OrderItemScreen(this.order);

  @override
  _OrderItemScreenState createState() => _OrderItemScreenState();
}

class _OrderItemScreenState extends State<OrderItemScreen> {

  var _expander = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('₱ ${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expander ? Icons.expand_less : Icons.expand_more),
              onPressed: (){
                setState(() {
                  _expander = !_expander;
                });
              },
            ),
          ),
          if(_expander) Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4.0),
            height: min(
              widget.order.products.length * 20/0 + 10.0,
              100
            ),
            child: ListView(
              children: widget.order.products.map((prod) =>
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      prod.title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                        '${prod.quantity} X ₱${prod.price}',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                  ],
                )
              ).toList(),
            ),
          ),
          FlatButton(
            color: Theme.of(context).errorColor,
            onPressed: (){},
            child: Text(
              'Cancel Order',
              style: TextStyle(
                color: Colors.white
              ),
            ),
          )
        ],
      ),
    );
  }
}
