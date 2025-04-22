import 'dart:developer';

import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/models/orders_model.dart';
import 'package:ees/presentation/main_screens/main_nav_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../app/utils/network/dio_helper.dart';
import '../app/utils/network/end_points.dart';
import '../app/utils/show_toast.dart';
import '../presentation/main_screens/my_orders_screen/widgets/ordersDialog.dart';

class OrdersController with ChangeNotifier {
  bool isLoadingAllOrders = false;
  bool hasError = false;
  OrdersModel? ordersModel;
  // String orderStatus = 'pending';
  void getAllOrders(orderStatus) async {
    try {
      isLoadingAllOrders = true;
      hasError = false;
      ordersModel = null;
      notifyListeners();
      final response = await DioHelper.get(EndPoints.getOrders,
          requiresAuth: true, queryParameters: {'status': orderStatus});
      if (response['status'] == true) {
        ordersModel = OrdersModel.fromJson(response);
        isLoadingAllOrders = false;
        hasError = false;
        notifyListeners();
      } else {
        isLoadingAllOrders = false;
        hasError = true;
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      hasError = true;
      log(e.toString());
      EasyLoading.dismiss();
      notifyListeners();
    }
  }

  Future<void> cancelOrderItem(var orderId) async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final response = await DioHelper.post(
          EndPoints.cancelOrderItem + "$orderId/cancel",
          data: {"order_id": orderId},
          requiresAuth: true);
      if (response['status'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast(response['message'], ToastType.success);
        NavigationManager.navigatToAndFinish(MainScreen(currentIndex: 2));
      } else {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      EasyLoading.dismiss();
      log(e.toString());
      notifyListeners();
    }
  }

  /////cancel order//////
  Future<void> cancelOrder(var orderId, {bool fromDetails = false}) async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final response = await DioHelper.post(
          EndPoints.cancelOrder + "$orderId/cancel",
          data: {"order_id": orderId},
          requiresAuth: true);
      if (response['status'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast(response['message'], ToastType.success);
        fromDetails == true
            ? NavigationManager.navigatToAndFinish(MainScreen(currentIndex: 2))
            : getAllOrders("pending");
      } else {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      EasyLoading.dismiss();
      log(e.toString());
      notifyListeners();
    }
  }

  //// acceptEdit////
  Future<void> acceptEdit({var orderId, quantity}) async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final response = await DioHelper.post(
          EndPoints.acceptOrderEdit + "$orderId",
          data: {"order_id": orderId, 'quantity': quantity},
          requiresAuth: true);
      if (response['status'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast(response['message'], ToastType.success);
        NavigationManager.navigatToAndFinish(MainScreen(
          currentIndex: 2,
        ));
      } else {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      EasyLoading.dismiss();
      log(e.toString());
      notifyListeners();
    }
  }

  ///rate Vendor ///
  Future<void> rateVendor({var orderId, rating, prepertyId, comment}) async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final response = await DioHelper.post(EndPoints.rateVendor,
          data: {
            "order_id": orderId,
            'rate': rating,
            'property_id': prepertyId,
            'comment': comment
          },
          requiresAuth: true);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        NavigationManager.pop();
        getAllOrders("finished");
        showThanksDialog(NavigationManager.navigatorKey.currentContext!);

        showCustomedToast(response['message'], ToastType.success);
      } else {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      EasyLoading.dismiss();
      log(e.toString());
      notifyListeners();
    }
  }
}
