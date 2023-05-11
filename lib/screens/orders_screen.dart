import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/orders_item.dart';
import '/widgets/app_drawer.dart';
import '/providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future ordersFuture;

  Future _getOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).getOrdersFromFirebase();
  }

  @override
  void initState() {
    ordersFuture = _getOrdersFuture();
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   Future.delayed(Duration.zero).then((_) {
    //     Provider.of<Orders>(context, listen: false)
    //         .getOrdersFromFirebase()
    //         .then((value) {
    //       setState(() {
    //         _isLoading = false;
    //       });
    //     });
    //   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Buyurtmalar"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: ordersFuture,
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error == null) {
              return Consumer<Orders>(
                builder: (context, orders, child) => orders.items.isEmpty
                    ? const Center(
                        child: Text("Buyurtmalar mavjud emas!"),
                      )
                    : ListView.builder(
                        itemCount: orders.items.length,
                        itemBuilder: (context, index) {
                          final order = orders.items[index];
                          return OrderItem(
                            totalPrice: order.totalPrice,
                            date: order.date,
                            products: order.products,
                          );
                        },
                      ),
              );
            } else {
              return const Center(
                child: Text("Xatolik sodir bo'ldi."),
              );
            }
          }
        },
      ),
    );
  }
}
