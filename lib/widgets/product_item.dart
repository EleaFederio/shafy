import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/cart.dart';
import 'package:shopy/providers/product.dart';
import 'package:shopy/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Product product = Provider.of<Product>(context, listen: true);
    final cart = Provider.of<Cart>(context, listen: false);

    return Consumer<Product>(
      builder: (context, product, _) => ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: GridTile(
          //Wrap Image with gesture detector to make it tapable
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: IconButton(
              icon: Icon(product.isFavorite? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: (){
                product.toogleFavoriteStatus();
              },
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: (){
                cart.addItem(
                    product.id,
                    product.price,
                    product.title
                );
              },
            ),
            backgroundColor: Colors.black54,
          ),
        ),
      ),
    );
  }
}
