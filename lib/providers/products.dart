import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _list = [
    // Product(
    //   id: "p1",
    //   title: "MackBook PRO",
    //   description:
    //       "What is the info of MacBook Pro?\nApple MacBook Pro is a macOS laptop with a 13.30-inch display that has a resolution of 2560x1600 pixels. It is powered by a Core i5 processor and it comes with 12GB of RAM. The Apple MacBook Pro packs 512GB of SSD storage. Chip Apple M2 chip 8-core CPU with 4 performance cores and 4 efficiency cores 10-core GPU 16-core Neural Engine 100GB/s memory bandwidth Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem IpsumLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
    //   price: 1299,
    //   imageUrl:
    //       "https://images.unsplash.com/photo-1637329428580-8fddec26fa67?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
    // ),
    // Product(
    //   id: "p2",
    //   title: "iPhone 13 Pro",
    //   description: "Ajoyib iPhone",
    //   price: 1399,
    //   imageUrl:
    //       "https://images.unsplash.com/photo-1633053699034-459674171bec?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80",
    // ),
    // Product(
    //   id: "p3",
    //   title: "Apple Watch",
    //   description: "Ajoyib Apple watch",
    //   price: 599,
    //   imageUrl:
    //       "https://images.unsplash.com/photo-1579586337278-3befd40fd17a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1172&q=80",
    // ),
    // Product(
    //   id: "p4",
    //   title: "iPad",
    //   description: "Ajoyib iPad",
    //   price: 899,
    //   imageUrl:
    //       "https://images.unsplash.com/photo-1546868871-0f936769675e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=464&q=80",
    // ),
  ];

  List<Product> get list {
    return [..._list];
  }

  List<Product> get favorites {
    return _list.where((product) => product.isFavorite).toList();
  }

  Future<void> getProductsFromFirebase() async {
    final url = Uri.parse(
        'https://fir-app-e73d5-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);
      print(jsonDecode(response.body));
      if (jsonDecode(response.body) != null) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        data.forEach(
          (productId, productData) {
            loadedProducts.insert(
              0,
              Product(
                id: productId,
                title: productData['title'],
                description: productData['description'],
                price: productData['price'],
                imageUrl: productData['imageUrl'],
                isFavorite: productData['isFavorite'],
              ),
            );
          },
        );
        _list = loadedProducts;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://fir-app-e73d5-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          },
        ),
      );

      final name = (jsonDecode(response.body) as Map<String, dynamic>)['name'];
      final newProduct = Product(
        id: name,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      //_list.insert(0, newProduct);
      _list.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final productIndex =
        _list.indexWhere((product) => product.id == updatedProduct.id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://fir-app-e73d5-default-rtdb.firebaseio.com/products/${updatedProduct.id}.json');
      try {
        await http.patch(
          url,
          body: jsonEncode(
            {
              'title': updatedProduct.title,
              'description': updatedProduct.description,
              'price': updatedProduct.price,
              'imageUrl': updatedProduct.imageUrl,
            },
          ),
        );
        _list[productIndex] = updatedProduct;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://fir-app-e73d5-default-rtdb.firebaseio.com/products/$id.json');

    try {

      var deletingProduct = _list.firstWhere((product) => product.id == id);
      final productIndex = _list.indexWhere((product) => product.id == id);

      
      _list.removeWhere((product) => product.id == id);
      notifyListeners();

      final response = await http.delete(url);

      if(response.statusCode >= 400){
        _list.insert(productIndex, deletingProduct);
        notifyListeners();
        throw Exception();
        
      }
      print(response.statusCode);
    } catch (e) {
      rethrow;
    }
  }

  Product findById(String productID) {
    return list.firstWhere((product) => product.id == productID);
  }
}
