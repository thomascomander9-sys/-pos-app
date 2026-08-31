import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Map<String, dynamic> product) {
    int index = _cartItems.indexWhere((item) => item['id'] == product['id']);
    if (index != -1) {
      _cartItems[index]['quantity'] += 1;
    } else {
      _cartItems.add({
        'id': product['id'],
        'name': product['name'],
        'price': product['price'],
        'quantity': 1,
      });
    }
    notifyListeners();
  }

  void removeFromCart(int id) {
    _cartItems.removeWhere((item) => item['id'] == id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get totalAmount {
    return _cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }
}
