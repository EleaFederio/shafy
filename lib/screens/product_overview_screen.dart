import 'package:flutter/material.dart';
import 'package:shopy/widgets/products_grid.dart';

class ProductOverviewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gubat Online Store'),
      ),
      body: ProductsGrid(),
    );
  }
}


