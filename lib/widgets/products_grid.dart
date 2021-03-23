import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy/providers/Products.dart';
import 'package:shopy/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider(
        create: (c) => products[index],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0
      ),
    );
  }
}