import 'dart:developer';

import 'package:ees/models/categoreisModel.dart';
import 'package:flutter/material.dart';

import '../app/utils/network/dio_helper.dart';
import '../app/utils/network/end_points.dart';
import '../app/utils/show_toast.dart';
import '../models/vendorsModel.dart';

class HomeProvider extends ChangeNotifier {
  int? selectedCategory;
  int? selectedVendor;
  bool isLoadingCategories = false;
  bool isLoadingVendors = false;
  void setSelectedCategory(int index) {
    selectedCategory = index;
    selectedVendor = null;
    notifyListeners();
  }

  void setSelectedVendor(int index) {
    selectedVendor = index;
    selectedCategory = null;
    notifyListeners();
  }
/////get All Categories////

  CategoriesModel? categoriesModel;
  void getAllCategories() async {
    if (categoriesModel != null) {
      return;
    }
    try {
      isLoadingCategories = true;
      notifyListeners();
      final response =
          await DioHelper.get(EndPoints.getAllCategories, requiresAuth: true);
      if (response['success'] == true) {
        categoriesModel = CategoriesModel.fromJson(response);
        isLoadingCategories = false;
        notifyListeners();
      } else {
        isLoadingCategories = false;
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      isLoadingCategories = false;
      log(e.toString());
    } finally {
      isLoadingCategories = false;
      notifyListeners();
    }
  }

////get all vendors///////
  VendorsModel? vendorModel;
  void getAlVendors() async {
    if (vendorModel != null) {
      return;
    }
    try {
      isLoadingVendors = true;
      notifyListeners();
      final response =
          await DioHelper.get(EndPoints.getAllSuppliers, requiresAuth: true);
      if (response['success'] == true) {
        vendorModel = VendorsModel.fromJson(response);
        isLoadingVendors = false;
        notifyListeners();
      } else {
        isLoadingVendors = false;
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      isLoadingVendors = false;
      log(e.toString());
    } finally {
      isLoadingVendors = false;
      notifyListeners();
    }
  }
}
