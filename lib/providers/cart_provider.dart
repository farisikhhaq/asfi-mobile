import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  final String? variant;
  int quantity;

  CartItem({
    required this.product,
    this.variant,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'variant': variant,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      variant: json['variant'] as String?,
      quantity: json['quantity'] as int,
    );
  }
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalAmount => _items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart_data');
    if (cartString != null) {
      try {
        final List decoded = jsonDecode(cartString);
        _items = decoded.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      } catch (e) {
        print('Error parsing persisted cart: $e');
      }
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = jsonEncode(_items.map((item) => item.toJson()).toList());
    await prefs.setString('cart_data', cartString);
  }

  void addToCart(Product product, {String? variant, int quantity = 1}) {
    final index = _items.indexWhere(
        (item) => item.product.id == product.id && item.variant == variant);

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, variant: variant, quantity: quantity));
    }
    notifyListeners();
    _saveCart();
  }

  void updateQuantity(int productId, String? variant, int quantity) {
    final index = _items.indexWhere(
        (item) => item.product.id == productId && item.variant == variant);

    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
      _saveCart();
    }
  }

  void removeItem(int productId, String? variant) {
    _items.removeWhere(
        (item) => item.product.id == productId && item.variant == variant);
    notifyListeners();
    _saveCart();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }
}
