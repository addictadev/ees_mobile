import 'dart:developer';

import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/models/staticPage_model.dart';
import 'package:ees/presentation/main_screens/main_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
  //Contact Us//

  void contactUs() async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final response = await DioHelper.post(EndPoints.contactUs,
          data: {
            "name": nameController.text,
            "phone_number": phoneController.text,
            "message": messageController.text
          },
          requiresAuth: true);
      if (response['success'] == true) {
        EasyLoading.dismiss();

        nameController.clear();
        emailController.clear();
        phoneController.clear();
        messageController.clear();
        notifyListeners();

        showCustomedToast(response['message'], ToastType.success);
        NavigationManager.navigatToAndFinish(MainScreen());
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
