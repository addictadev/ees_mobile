import 'dart:developer';

import 'package:ees/models/categoreisModel.dart';
import 'package:ees/models/get_all_brands_model.dart';
import 'package:ees/models/home_slider.dart';
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
  HomeSliderModel? sliderModel;
  bool isLoadingSlider = false;
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

/////get All home slider

  void getAllHomeSlider() async {
    if (sliderModel != null) {
      return;
    }
    try {
      isLoadingSlider = true;
      notifyListeners();
      final response =
          await DioHelper.get(EndPoints.getAllSliders, requiresAuth: true);
      if (response['success'] == true) {
        sliderModel = HomeSliderModel.fromJson(response);
        isLoadingSlider = false;
        notifyListeners();
      } else {
        isLoadingSlider = false;
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      isLoadingSlider = false;
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
  Future<void> getAllHomeProducts({
    bool refresh = false,
  }) async {
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
          if (selectedVendor != null) 'property_id': selectedVendor,
          if (_selectedSorting.isNotEmpty || _selectedSorting != '')
            'sort_by': _selectedSorting,
          if (_selectedBrandIds.isNotEmpty) "brand_id": _selectedBrandIds,
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

  bool _isInstallmentEnabled = false;
  String _selectedSorting = '';

  // Brand filters
  final Map<String, bool> _brandFilters = {
    'Siemens': false,
    'Egypt panel': false,
  };
  final Map<String, bool> _newestOffersFilters = {
    'اجدد العروض': false,
  };
  // Product filters
  final Map<String, bool> _productTypeFilters = {
    'كرتونة': false,
    'علبة': false,
    'قطعة': false,
  };

  bool _showWidthFilterOption = false;

  // Getters
  bool get isInstallmentEnabled => _isInstallmentEnabled;
  String get selectedSorting => _selectedSorting;
  Map<String, bool> get brandFilters => Map.unmodifiable(_brandFilters);
  Map<String, bool> get productTypeFilters =>
      Map.unmodifiable(_productTypeFilters);
  Map<String, bool> get newestOffersFilters =>
      Map.unmodifiable(_newestOffersFilters);
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

  final Set<String> _selectedBrandIds = {};

  Set<String> get selectedBrandIds => _selectedBrandIds;

  void updateBrandFilter(String brandId, bool isSelected) {
    if (isSelected) {
      _selectedBrandIds.add(brandId);
    } else {
      _selectedBrandIds.remove(brandId);
    }
    notifyListeners();
  }

  void updateProductTypeFilter(String type, bool value) {
    _productTypeFilters[type] = value;
    notifyListeners();
  }

  void updateNewestOffersFilter(String type, bool value) {
    _newestOffersFilters[type] = value;
    notifyListeners();
  }

  void toggleWidthFilterOption(bool value) {
    _showWidthFilterOption = value;
    notifyListeners();
  }

  // Reset all filters
  void resetFilters() {
    _isInstallmentEnabled = false;
    _selectedSorting = '';

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
    getAllHomeProducts(refresh: true);
    notifyListeners();
  }

  List<BrandModel> listOfBrands = [];
  bool isLoadingBrands = false;
  Future<void> getAllBrands() async {
    try {
      listOfBrands.clear();
      isLoadingBrands = true;
      notifyListeners();
      final response =
          await DioHelper.get(EndPoints.getAllBrands, requiresAuth: true);
      if (response['success'] == true) {
        isLoadingBrands = false;
        notifyListeners();
        GetAllBrandsModel data = GetAllBrandsModel.fromJson(response);
        listOfBrands.addAll(data.data ?? []);
        notifyListeners();
      } else {
        isLoadingBrands = false;
        notifyListeners();
      }
    } catch (e) {
      isLoadingBrands = false;
      notifyListeners();
      log(e.toString());
    }
  }
}
