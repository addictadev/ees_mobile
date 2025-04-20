import 'dart:developer';

import 'package:ees/models/staticPage_model.dart';
import 'package:flutter/material.dart';

import '../app/utils/network/dio_helper.dart';
import '../app/utils/network/end_points.dart';
import '../app/utils/show_toast.dart';

class StaticProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  StaticModel? staticModel;

  void getStaticData() async {
    if (staticModel != null) {
      return;
    }
    try {
      isLoading = true;
      notifyListeners();
      final response =
          await DioHelper.get(EndPoints.getStaticPage, requiresAuth: true);
      if (response['success'] == true) {
        staticModel = StaticModel.fromJson(response);
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      isLoading = false;
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
