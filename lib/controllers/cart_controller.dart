import 'dart:developer';

import 'package:ees/app/utils/network/dio_helper.dart';
import 'package:ees/app/utils/network/end_points.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  Future<void> addToCart(var productId, var variantId, var propertyId) async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();

      final response = await DioHelper.post(EndPoints.addToCart,
          data: {
            "product_id": productId,
            "variant_id": variantId,
            "property_id": propertyId
          },
          requiresAuth: true);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast(response['message'], ToastType.success);
      } else {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      log(e.toString());
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  ////get cart items/////
  ///
  bool isLoadingGetCart = false;
  bool hasErrorGetCart = false;
  CartModel? cartModel;
  Future<void> getCartItems() async {
    try {
      isLoadingGetCart = true;
      hasErrorGetCart = false;
      notifyListeners();
      final response =
          await DioHelper.get(EndPoints.getCart, requiresAuth: true);
      if (response['success'] == true) {
        cartModel = CartModel.fromJson(response);
        isLoadingGetCart = false;
        hasErrorGetCart = false;
        notifyListeners();
      } else {
        isLoadingGetCart = false;
        hasErrorGetCart = true;
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      hasErrorGetCart = true;
      log(e.toString());
      EasyLoading.dismiss();
      notifyListeners();
    }
  }
}
