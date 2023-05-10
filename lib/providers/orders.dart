import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cart_item.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  Future<void> getOrdersFromFirebase() async {
    final url = Uri.parse(
        'https://fir-app-e73d5-default-rtdb.firebaseio.com/orders.json');

    try {
      final response = await http.get(url);
      if (jsonDecode(response.body) == null) {
        return;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      List<Order> loadedOrders = [];
      data.forEach(
        (orderid, order) {
          loadedOrders.add(
            Order(
              id: orderid,
              totalPrice: order['totalPrice'],
              date: DateTime.parse(order['date']),
              products: (order['products'] as List<dynamic>)
                  .map(
                    (product) => CartItem(
                      id: product['id'],
                      title: product['title'],
                      quantity: product['quantity'],
                      image: product['image'],
                      price: product['price'],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
      _items = loadedOrders;
      notifyListeners(); 
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addToOrders(List<CartItem> products, double totalPrice) async {
    final url = Uri.parse(
        'https://fir-app-e73d5-default-rtdb.firebaseio.com/orders.json');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'totlaPrice': totalPrice,
            'date': DateTime.now().toIso8601String(),
            'products': products
                .map(
                  (product) => {
                    'id': product.id,
                    'title': product.title,
                    'quantity': product.quantity,
                    'image': product.image,
                    'price': product.price,
                  },
                )
                .toList(),
          },
        ),
      );
      _items.insert(
        0,
        Order(
          id: jsonDecode(response.body)['name'],
          totalPrice: totalPrice,
          date: DateTime.now(),
          products: products,
        ),
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
