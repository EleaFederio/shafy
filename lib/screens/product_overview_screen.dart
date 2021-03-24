import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/Products.dart';
import 'package:shopy/providers/cart.dart';
import 'package:shopy/widgets/badge.dart';
import 'package:shopy/widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All
}

class ProductOverviewScreen extends StatefulWidget {

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavoritesData = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gubat Online Store'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
                child: ch,
                value: cartData.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){},
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){
              setState(() {
                if(selectedValue == FilterOptions.Favorites){
                  _showOnlyFavoritesData = true;
                } else{
                  _showOnlyFavoritesData = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favorites'), value: FilterOptions.Favorites,),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All,)
            ],
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavoritesData),
    );
  }
}


