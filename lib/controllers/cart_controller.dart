import 'dart:developer';

import 'package:ees/app/utils/network/dio_helper.dart';
import 'package:ees/app/utils/network/end_points.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/models/cart_model.dart';
import 'package:ees/presentation/main_screens/cart_screen/widgets/cart_popup.dart';
import 'package:ees/presentation/main_screens/cart_screen/widgets/makeOrderPopUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../app/navigation_services/navigation_manager.dart';
import '../presentation/main_screens/cart_screen/widgets/cartBottomSheet.dart';
import '../presentation/main_screens/main_nav_screen.dart';

class CartProvider with ChangeNotifier {
  TextEditingController noteController = TextEditingController();
  TextEditingController copounCtn = TextEditingController();
  Future addToCart(var productId, var variantId, var propertyId) async {
    try {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      notifyListeners();

      final response = await DioHelper.post(
        EndPoints.addToCart,
        data: {
          "product_id": productId,
          "variant_id": variantId,
          "property_id": propertyId,
        },
        requiresAuth: true,
      );

      EasyLoading.dismiss();
      notifyListeners();

      // التأكد من أن الاستجابة تحتوي على البيانات المطلوبة
      if (response != null && response['success'] == true) {
        getCartItems().then((value) {
          showCartBottomSheet(NavigationManager.navigatorKey.currentContext!,
              cartCount: cartModel!.data!.items!.length,
              miuOrder: cartModel!.data!.items!.last.variant!.minQuantity ?? 0,
              cartTotal: cartModel!.data!.totalAfterDiscount);
        });
      } else {
        if (response['message'].toString().contains('الحالية')) {
        } else {
          showCustomedToast(response?['message'] ?? 'حدث خطأ', ToastType.error);
        }
      }

      return response; // التأكد من إرجاع الاستجابة
    } catch (e) {
      EasyLoading.dismiss();
      notifyListeners();
      return e.toString(); // التأكد من إرجاع null في حالة الخطأ
    }
  }

  ///force Add to cart
  void forceAddToCart(var productId, var variantId, var propertyId) async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final response = await DioHelper.post(EndPoints.forceAddToCart,
          data: {
            "product_id": productId,
            "variant_id": variantId,
            "property_id": propertyId
          },
          requiresAuth: true);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        NavigationManager.pop();
        getCartItems().then((value) {
          showCartBottomSheet(NavigationManager.navigatorKey.currentContext!,
              cartCount: cartModel!.data!.items!.length,
              miuOrder: cartModel!.data!.items!.last.variant!.minQuantity ?? 0,
              cartTotal: cartModel!.data!.totalAfterDiscount);
        });
      } else {
        EasyLoading.dismiss();
        notifyListeners();

        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
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
          data: {"product_id": cartId}, requiresAuth: true);
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
      if (response['status'] == true) {
        showCustomedToast(response['message'], ToastType.success);
        notifyListeners();
        copounCtn.clear();
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
        getCartItems();
        showOrderSuccessDialog(NavigationManager.navigatorKey.currentContext!);

        notifyListeners();
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
