import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/orders_item.dart';
import '/widgets/app_drawer.dart';
import '/providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Buyurtmalar"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orders.items.length,
        itemBuilder: ((context, index) {
          final order = orders.items[index];
          return OrderItem(
            totalPrice: order.totalPrice,
            date: order.date,
            products: order.products,
          );
        }),
      ),
    );
  }
}
