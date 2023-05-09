import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_list_item.dart';
import '../providers/orders.dart';

class cartScreen extends StatelessWidget {
  const cartScreen({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Sizning savatchanggiz",
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(
                10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "UMUMIY:",
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$ ${cart.totalprice.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: ((context, index) {
                final cartItem = cart.items.values.toList()[index];
                return CartListItem(
                  productID: cart.items.keys.toList()[index],
                  imageUrl: cartItem.image,
                  title: cartItem.title,
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatelessWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await Provider.of<Orders>(context, listen: false).addToOrders(
          cart.items.values.toList(),
          cart.totalprice,
        );
        cart.clearItem();
      },
      child: const Text(
        "BUYURTMA QILISH",
      ),
    );
  }
}
