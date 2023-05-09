import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_list_item.dart';
import '../providers/orders.dart';
import '../screens/orders_screen.dart';

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

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.items.isEmpty || _isLoading) ? null : () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false).addToOrders(
          widget.cart.items.values.toList(),
          widget.cart.totalprice,
        );
        setState(() {
          _isLoading = false;
        });
        widget.cart.clearItem();
        Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
      },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text(
              "BUYURTMA QILISH",
            ),
    );
  }
}
