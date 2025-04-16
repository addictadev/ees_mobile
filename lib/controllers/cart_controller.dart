import 'package:flutter/material.dart';
import '../presentation/main_screens/cart_screen/widgets/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [
    CartItem(name: "لمبات سنترا", price: 5.25, quantity: 200, cartonSize: 100),
    CartItem(name: "لمبات ليد", price: 5.25, quantity: 100, cartonSize: 50),
    CartItem(name: "لمبات ورم ليد", price: 5.25, quantity: 60, cartonSize: 30),
  ];

  List<CartItem> get cartItems => _cartItems;

  double get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
}
