import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/config/myColor.dart';
import 'package:shopy/helpers/custom_routes.dart';
import 'package:shopy/providers/Products.dart';
import 'package:shopy/providers/auth.dart';
import 'package:shopy/providers/cart.dart';
import 'package:shopy/providers/orders.dart';
import 'package:shopy/screens/auth_screen.dart';
import 'package:shopy/screens/cart_screen.dart';
import 'package:shopy/screens/edit_product_screen.dart';
import 'package:shopy/screens/orders_screen.dart';
import 'package:shopy/screens/product_detail_screen.dart';
import 'package:shopy/screens/product_overview_screen.dart';
import 'package:shopy/screens/splash_screen.dart';
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
          create: (context) => Auth(),
        ),
        // ChangeNotifierProxyProvider will give the provider you set in the Multiprovider
        // To make it Accessable to other models
        ChangeNotifierProxyProvider<Auth, Products>(
            // This Provider will rebuild
            // This get the token value from token class providers/auth.dart
            update: (context, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items
            ),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrder) => Orders(
            auth.token,
            previousOrder == null ? [] : previousOrder.orders,
            auth.userId
          ),
        )
      ],

      //  Wrap Material App to with Consumer to check where user is sign in or not
      //  Depend on the auth data if what home parameter will receive in this Main Widget
      child: Consumer<Auth>(
        builder: (context, authData, _) =>
            MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: MaterialColor(0xFF3d3e3c, color),
                accentColor: Color(0xFFcde6fd),
                fontFamily: 'Lato',
                visualDensity: VisualDensity.adaptivePlatformDensity,
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                  }
                )
              ),
              // home: ProductOverviewScreen(),
              home: authData.isAuth ? ProductOverviewScreen() : FutureBuilder(
                future: authData.tryAutoLogin(),
                builder: (context, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ?
                SplashScreen()
                :
                AuthScreen(),
              ),
              routes: {
                ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
                CartScreen.routeName: (context) => CartScreen(),
                OrdersScreen.routeName: (context) => OrdersScreen(),
                UserProductsScreen.routeName: (context) => UserProductsScreen(),
                EditProductScreen.routeName: (context) => EditProductScreen(),
                AuthScreen.routeName: (context) => AuthScreen()
              },
            ),
      )
    );
  }
}
