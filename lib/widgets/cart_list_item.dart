import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartListItem extends StatelessWidget {
  final String productID;
  final String imageUrl;
  final String title;
  final double price;
  final int quantity;

  const CartListItem({
    super.key,
    required this.productID,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
  });

  void _notifyUserAboutDelete(BuildContext context, Function() removeItem) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Ishonchinggiz komilmi?"),
          content: const Text("Savatchadan maxsulot o'chirilmoqda!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "BEKOR QILISH",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                removeItem();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              child: const Text(
                "O'CHIRISH",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Slidable(
      key: ValueKey(productID),
      endActionPane:
          ActionPane(extentRatio: 0.3, motion: ScrollMotion(), children: [
        ElevatedButton(
          onPressed: () => _notifyUserAboutDelete(
            context,
            () => cart.removeItem(productID),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              padding:
                  const EdgeInsets.symmetric(horizontal: 23, vertical: 26)),
          child: Text("O'CHIRISH"),
        ),
      ]),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          subtitle: Text(
            "UMUMIY: \$${(price * quantity).toStringAsFixed(2)}",
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => cart.removeSingleItem(productID),
                icon: const Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
                splashRadius: 20,
              ),
              //Chip(label: Text(quantity.toString())),
              Container(
                alignment: Alignment.center,
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade100),
                child: Text("$quantity"),
              ),
              IconButton(
                onPressed: () => cart.addToCart(
                  productID,
                  title,
                  imageUrl,
                  price,
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
