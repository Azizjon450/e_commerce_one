import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int itemsCount() {
    return _items.length;
  }

  double get totalprice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addToCart(
    String productID,
    String title,
    String image,
    double price,
  ) {
    if (_items.containsKey(productID)) {
      //sonini oshirib qo'y
      _items.update(
        productID,
        (currentProduct) => CartItem(
            id: currentProduct.id,
            title: currentProduct.title,
            quantity: currentProduct.quantity + 1,
            image: currentProduct.image,
            price: currentProduct.price),
      );
    } else {
      //yangi maxsulot qushilmoqda
      _items.putIfAbsent(
        productID,
        () => CartItem(
          id: UniqueKey().toString(),
          title: title,
          quantity: 1,
          image: image,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productID, {bool isCartButton = false}) {
    if (!_items.containsKey(productID)) {
      return;
    }
    if (_items[productID]!.quantity > 1) {
      _items.update(
        productID,
        (currentProduct) => CartItem(
          id: currentProduct.id,
          title: currentProduct.title,
          quantity: currentProduct.quantity - 1,
          image: currentProduct.image,
          price: currentProduct.price,
        ),
      );
    } else if (isCartButton) {
      _items.remove(productID);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clearItem() {
    _items.clear();
    notifyListeners();
  }
}
