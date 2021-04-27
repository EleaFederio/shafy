import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/auth.dart';
import 'package:shopy/providers/cart.dart';
import 'package:shopy/providers/product.dart';
import 'package:shopy/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Product product = Provider.of<Product>(context, listen: true);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

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
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                // AssertImage, NetworkImage  etc are ImageProvider not Image widget
                placeholder: AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          footer: GridTileBar(
            leading: IconButton(
              icon: Icon(product.isFavorite? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: (){
                // to access userId - create getter to auth.dart
                product.toogleFavoriteStatus(authData.token, authData.userId);
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
              //  Info puo-up
              //  ScaffoldMessenger will be use instead of SnackBar if using Flutter 2
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.title} successfully added to cart'),
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: (){
                        cart.removedSingleItem(product.id);
                        print('${product.title} successfully removed to cart');
                      },
                    ),
                  )
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
