import 'dart:developer';

import 'package:ees/models/orders_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../app/utils/network/dio_helper.dart';
import '../app/utils/network/end_points.dart';
import '../app/utils/show_toast.dart';

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

  /////cancel order//////
  Future<void> cancelOrder(var orderId) async {
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
        getAllOrders("pending");
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
