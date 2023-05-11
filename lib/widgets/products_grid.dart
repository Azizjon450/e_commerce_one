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
  late Future _productsFuture;

  Future _getProductsFuture() {
    return Provider.of<Products>(context, listen: false)
        .getProductsFromFirebase();
  }

  @override
  void initState() {
    _productsFuture = _getProductsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _productsFuture,
      builder: (context, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (dataSnapshot.error == null) {
            return Consumer<Products>(
              builder: (ctx, products, child) {
                final prodS = widget.showOnlyFavorites
                    ? products.favorites
                    : products.list;

                return prodS.isNotEmpty
                    ? GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 3 / 2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20),
                        itemCount: prodS.length,
                        itemBuilder: ((context, index) {
                          return ChangeNotifierProvider<Product>.value(
                            value: prodS[index],
                            child: const ProductItem(),
                          );
                        }),
                      )
                    : const Center(
                        child: Text("Mahsulotlar mavjud emas!"),
                      );
              },
            );
          } else {
            return const Center(
              child: Text("Xataolik sodir bo'ldi."),
            );
          }
        }
      },
    );
  }
}
