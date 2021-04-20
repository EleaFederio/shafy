import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/Products.dart';
import 'package:shopy/screens/edit_product_screen.dart';
import 'package:shopy/widgets/app_drawer.dart';
import 'package:shopy/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products';

  @override
  Widget build(BuildContext context) {
    // disable this to prevent infinite loop when using FutureBuilder
    // final productsData = Provider.of<Products>(context);

    Future<void> _refreshProducts(BuildContext context) async{
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        // check if it is loading or not
        // then display Refresh Indicator with Consumer that rebuild the selected part when the fetching to firebase is done
        builder: (context, snapShot) => snapShot.connectionState == ConnectionState.waiting ?
        Center(
          child: CircularProgressIndicator(),
        ) :
        RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          // Consumer to enable Padding to only rebuild not the entire screen
          child: Consumer<Products>(
            // the widget should be =>/return
            builder: (context, productsData, _) => Padding(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, index) => Column(
                  children: [
                    UserProductItem(
                        productsData.items[index].id,
                        productsData.items[index].title,
                        productsData.items[index].imageUrl
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
