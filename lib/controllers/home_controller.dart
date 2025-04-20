import 'dart:developer';

import 'package:ees/models/categoreisModel.dart';
import 'package:ees/models/products_home_data_model.dart';
import 'package:flutter/material.dart';

import '../app/utils/network/dio_helper.dart';
import '../app/utils/network/end_points.dart';
import '../app/utils/show_toast.dart';
import '../models/vendorsModel.dart';

class HomeProvider extends ChangeNotifier {
  int? selectedCategory = 0;
  int? selectedVendor;
  bool isLoadingCategories = false;
  bool isLoadingVendors = false;
  bool isLoadingProducts = false;
  ProductsHomeDataModel? productsModel;
  int currentPage = 1;
  bool hasMorePages = true;

  void setSelectedCategory(int index) {
    selectedCategory = index;
    selectedVendor = null;
    notifyListeners();
  }

  void setSelectedVendor(int id) {
    selectedVendor = id;
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

  TextEditingController searchController = TextEditingController();
  TextEditingController searchHome = TextEditingController();

  /////get all products with pagination///////
  Future<void> getAllHomeProducts({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      hasMorePages = true;
      productsModel = null;
    }

    if (!hasMorePages && !refresh || isLoadingProducts) {
      return;
    }

    try {
      isLoadingProducts = true;
      notifyListeners();

      log("Loading products page: $currentPage");

      final response = await DioHelper.get(
        EndPoints.getAllHomeProducts,
        queryParameters: {
          'page': currentPage,
          if (searchController.text.isNotEmpty) 'search': searchController.text,
          if (selectedCategory != null && selectedCategory != 0)
            'category_id': selectedCategory,
          if (selectedVendor != null) 'property_id': selectedVendor
        },
        requiresAuth: true,
      );

      if (response['status'] == true) {
        final newProducts = ProductsHomeDataModel.fromJson(response);

        if (productsModel == null) {
          productsModel = newProducts;
        } else {
          productsModel!.data?.addAll(newProducts.data ?? []);
          productsModel!.pagination = newProducts.pagination;
        }

        if (newProducts.pagination != null) {
          hasMorePages = newProducts.pagination?.currentPage !=
              newProducts.pagination?.lastPage;

          log("Pagination: Current=${newProducts.pagination?.currentPage}, Last=${newProducts.pagination?.lastPage}, HasMore=$hasMorePages");

          if (hasMorePages) {
            currentPage++;
          }
        } else {
          hasMorePages = false;
        }

        isLoadingProducts = false;
        notifyListeners();
      } else {
        isLoadingProducts = false;
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      isLoadingProducts = false;
      log("Error loading products: ${e.toString()}");
      notifyListeners();
    }
  }
    bool _isInstallmentEnabled = true;
  String _selectedSorting = '';
  
  // Brand filters
  final Map<String, bool> _brandFilters = {
    'Siemens': false,
    'Egypt panel': false,
  };
  
  // Product filters
  final Map<String, bool> _productTypeFilters = {
    'خزانة': false,
    'علبة': false,
    'قطعة': false,
  };

  bool _showWidthFilterOption = false;
  
  // Getters
  bool get isInstallmentEnabled => _isInstallmentEnabled;
  String get selectedSorting => _selectedSorting;
  Map<String, bool> get brandFilters => Map.unmodifiable(_brandFilters);
  Map<String, bool> get productTypeFilters => Map.unmodifiable(_productTypeFilters);
  bool get showWidthFilterOption => _showWidthFilterOption;
  
  // List of sorting options
  final List<String> sortOptions = ['الأكثر مبيعا', 'الأحدث', 'أقل سعر'];
  
  // Methods to update state
  void toggleInstallmentPayment(bool value) {
    _isInstallmentEnabled = value;
    notifyListeners();
  }
  
  void updateSorting(String option) {
    _selectedSorting = option;
    notifyListeners();
  }
  
  void updateBrandFilter(String brand, bool value) {
    _brandFilters[brand] = value;
    notifyListeners();
  }
  
  void updateProductTypeFilter(String type, bool value) {
    _productTypeFilters[type] = value;
    notifyListeners();
  }
  
  void toggleWidthFilterOption(bool value) {
    _showWidthFilterOption = value;
    notifyListeners();
  }
  
  // Reset all filters
  void resetFilters() {
    _isInstallmentEnabled = true;
    _selectedSorting = 'الأكثر مبيعا';
    
    for (var key in _brandFilters.keys) {
      _brandFilters[key] = false;
    }
    
    for (var key in _productTypeFilters.keys) {
      _productTypeFilters[key] = false;
    }
    
    _showWidthFilterOption = false;
    notifyListeners();
  }
  
  // Apply filters
  void applyFilters() {
    // This would typically make an API call or update a parent state
    // For this example, we'll just notify listeners
    notifyListeners();
  }
}
