import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_details_screen.dart';
import '../models/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, prod, child) {
              return IconButton(
                onPressed: () {
                  prod.toggleFavorites(auth.token!,  auth.userId);
                },
                icon: Icon(
                  prod.isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: Colors.cyan,
                  //color: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addToCart(
                product.description,
                product.title,
                product.imageUrl,
                product.price,
              );
              // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              // ScaffoldMessenger.of(context).showMaterialBanner(
              //   MaterialBanner(
              //     backgroundColor: Colors.blueGrey,
              //     content: const Text(
              //       "Savatchaga qo'shildi!",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //     actions: [
              //       TextButton(
              //         onPressed: () {
              //           cart.removeSingleItem(product.id, isCartButton: true);
              //           ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              //         },
              //         child: const Text(
              //           "BEKOR QILISH",
              //         ),
              //       ),
              //     ],
              //   ),
              // );
              // Future.delayed(Duration(seconds: 2)).then(
              //   (value) =>
              //       ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              // );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  //padding: EdgeInsets.all(16),
                  content: Text("Savatchaga qo'shildi!"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "BEKOR QILISH",
                    onPressed: () {
                      cart.removeSingleItem(product.id, isCartButton: true);
                    },
                    textColor: Colors.white,
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
