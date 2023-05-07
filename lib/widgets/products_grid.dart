import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatefulWidget {
  final bool showOnlyFavorites;
  const ProductsGrid(this.showOnlyFavorites, {super.key});

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  var _init = true;

  @override
  void initState() {
    //   Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context, listen: false).getProductsFromFirebase();
    // });             
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      Provider.of<Products>(context, listen: false).getProductsFromFirebase();
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        widget.showOnlyFavorites ? productsData.favorites : productsData.list;
    return products.isNotEmpty
        ? GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3 / 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20),
            itemCount: products.length,
            itemBuilder: ((context, index) {
              return ChangeNotifierProvider<Product>.value(
                value: products[index],
                child: const ProductItem(),
              );
            }),
          )
        : Center(
            child: Text("Mahsulotlar mavjud emas!"),
          );
  }
}
