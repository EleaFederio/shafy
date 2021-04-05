import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/config/myColor.dart';
import 'package:shopy/providers/Products.dart';
import 'package:shopy/providers/cart.dart';
import 'package:shopy/providers/orders.dart';
import 'package:shopy/screens/cart_screen.dart';
import 'package:shopy/screens/edit_product_screen.dart';
import 'package:shopy/screens/orders_screen.dart';
import 'package:shopy/screens/product_detail_screen.dart';
import 'package:shopy/screens/product_overview_screen.dart';
import 'package:shopy/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor customColor = MaterialColor(0xFFBC0A0F, color);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: MaterialColor(0xFF3d3e3c, color),
            accentColor: Color(0xFFcde6fd),
            fontFamily: 'Lato',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: ProductOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen()
          },
        ),
    );
  }
}
