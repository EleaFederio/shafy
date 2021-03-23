import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/Products.dart';
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
  @override
  Widget build(BuildContext context) {
    var _showOnlyFavoritesData = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Gubat Online Store'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){
              setState((){
                switch(selectedValue){
                  case FilterOptions.All:
                    _showOnlyFavoritesData = false;
                    break;
                  case FilterOptions.Favorites:
                    _showOnlyFavoritesData = true;
                    break;
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


