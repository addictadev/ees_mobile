import 'dart:developer';

import 'package:ees/app/utils/network/dio_helper.dart';
import 'package:ees/app/utils/network/end_points.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../app/navigation_services/navigation_manager.dart';
import '../presentation/main_screens/main_nav_screen.dart';

class CartProvider with ChangeNotifier {
  TextEditingController noteController = TextEditingController();
  TextEditingController copounCtn = TextEditingController();
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
        NavigationManager.navigatToAndFinish(MainScreen(
          currentIndex: 1,
        ));
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

  ///increment cart item
  Future<void> incrementCartItem(var cartId) async {
    try {
      // EasyLoading.show(
      //   maskType: EasyLoadingMaskType.black,
      // );
      notifyListeners();
      final response = await DioHelper.post(EndPoints.incrementCartItem,
          data: {"cart_id": cartId}, requiresAuth: true);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        getCartItems();
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

  ///decrement cart item
  Future<void> decrementCartItem(var cartId) async {
    try {
      // EasyLoading.show(
      //   maskType: EasyLoadingMaskType.black,
      // );
      notifyListeners();
      final response = await DioHelper.post(EndPoints.decrementCartItem,
          data: {"cart_id": cartId}, requiresAuth: true);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        getCartItems();
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

///////delete cart item/////
  Future<void> deleteCartItem(var cartId) async {
    try {
      // EasyLoading.show(
      //   maskType: EasyLoadingMaskType.black,
      // );
      notifyListeners();
      final response = await DioHelper.post(EndPoints.deleteCartItem,
          data: {"cart_id": cartId}, requiresAuth: true);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        getCartItems();
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

  Future<void> applyCopun() async {
    try {
      if (copounCtn.text.isEmpty) {
        showCustomedToast("ادخل كود الخصم", ToastType.error);
        return;
      }
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final response = await DioHelper.post(EndPoints.applyCoupon,
          data: {"code": copounCtn.text}, requiresAuth: true);
      if (response['success'] == true) {
        showCustomedToast(response['message'], ToastType.success);
        notifyListeners();
        getCartItems();
        EasyLoading.dismiss();
      } else {
        notifyListeners();
        EasyLoading.dismiss();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      log(e.toString());
      EasyLoading.dismiss();

      notifyListeners();
    }
  }

  Future<void> createOrder(
    var propertyId,
  ) async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final response = await DioHelper.post(EndPoints.createOrder,
          data: {
            "property_id": propertyId,
            if (noteController.text.isNotEmpty) "note": noteController.text
          },
          requiresAuth: true);
      if (response['status'] == true) {
        noteController.clear();
        copounCtn.clear();
        EasyLoading.dismiss();
        showCustomedToast(response['message'], ToastType.success);
        notifyListeners();
        NavigationManager.navigatToAndFinish(MainScreen(
          currentIndex: 2,
        ));
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
}
