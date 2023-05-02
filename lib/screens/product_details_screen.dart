import 'package:e_commerse_one/providers/cart.dart';
import 'package:e_commerse_one/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)!.settings.arguments;
    final product = Provider.of<Products>(context, listen: false)
        .findById(productID as String);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  product.description,
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Container(
          height: 80,
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Narxi:",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Consumer<Cart>(
                builder: (ctx, cart, child) {
                  final isProductAdded = cart.items.containsKey(productID);
                  if (isProductAdded) {
                    return ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pushNamed(
                        cartScreen.routeName,
                      ),
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.black,
                        size: 15,
                      ),
                      label: const Text(
                        "Savatchaga borish",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        backgroundColor: Colors.grey.shade200,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () => cart.addToCart(
                        productID,
                        product.title,
                        product.imageUrl,
                        product.price,
                      ),
                      child: Text("Savatchaga qo'shish"),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        backgroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
