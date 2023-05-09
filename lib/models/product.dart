import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorites() async {
    var oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        'https://fir-app-e73d5-default-rtdb.firebaseio.com/$id.json');

    try {
      final response = await http.patch(
        url,
        body: jsonEncode(
          {
            'isFavorite': isFavorite,
          },
        ),
      );

      if (response.statusCode >= 400) {
        isFavorite = oldFavorite;
        notifyListeners();
      }
    } catch (e) {
      isFavorite = oldFavorite;
      notifyListeners();
    }
  }
}
