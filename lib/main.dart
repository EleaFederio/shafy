import 'package:flutter/material.dart';
import 'package:shopy/config/myColor.dart';
import 'package:shopy/screens/product_detail_screen.dart';
import 'package:shopy/screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor customColor = MaterialColor(0xFFBC0A0F, color);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF3d3e3c, color),
        accentColor: Color(0xFFcde6fd),
        fontFamily: 'Lato',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (context) => ProductDetailScreen()
      },
    );
  }
}
