import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/helpers/custom_routes.dart';
import 'package:shopy/providers/auth.dart';
import 'package:shopy/screens/orders_screen.dart';
import 'package:shopy/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              'Hello',
            ),
            // do not show back button
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);

              // ***** Apply CustomRoute to specific route only ***** //
              // Navigator.of(context).pushReplacement(CustomRoute(
              //   builder: (ctx) => OrdersScreen()
              // ));

            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Manage Products'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: (){
              // Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
