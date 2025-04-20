import 'dart:developer';
import 'dart:io';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/presentation/Auth_screens/login_screen/login_screen.dart';
import 'package:ees/presentation/main_screens/main_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../app/dependency_injection/get_it_injection.dart';
import '../app/utils/consts.dart';
import '../app/utils/local/shared_pref_serv.dart';
import '../app/utils/network/dio_helper.dart';
import '../app/utils/network/end_points.dart';
import '../models/cityModels.dart';
import '../presentation/Auth_screens/otp_bottom_sheet.dart';
import '../presentation/forget_pass_screen/resendPassScreen.dart';
import 'package:dio/dio.dart';

class AuthController with ChangeNotifier implements ReassembleHandler {
  IconData loginVisibilityIcon = Icons.visibility_off_outlined;
  IconData clientRegister1VisibilityIcon = Icons.visibility_off_outlined;
  IconData oldIcon = Icons.visibility_off_outlined;
  IconData clientRegister2VisibilityIcon = Icons.visibility_off_outlined;
  bool loginVisibality = true;
  bool clientRegister1Visibality = true;
  bool olpassVisibality = true;
  bool clientRegister2Visibality = true;
  int currentStep = 0;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  void changeStep(int index) {
    currentStep = index;
    notifyListeners();
  }

  void loginChangeVisibility() {
    loginVisibality = !loginVisibality;
    loginVisibilityIcon = loginVisibality
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
    notifyListeners();
  }

  void registerVisibility() {
    clientRegister1Visibality = !clientRegister1Visibality;
    clientRegister1VisibilityIcon = clientRegister1Visibality
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
    notifyListeners();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController locationReisterController = TextEditingController();
  TextEditingController phoneReisterController = TextEditingController();
  TextEditingController delegate_nameController = TextEditingController();
  TextEditingController otpCtn = TextEditingController();

  double? lat;
  double? lng;
  String? cityId;
  String? cityName;
  String? shopType;
  final sharedPref = getIt<SharedPreferencesService>();

  bool _isLoadingRegister = false;
  bool _isLoadingLogin = false;
  final bool _isLoadingGetProfileData = false;
  bool get isLoadingRegister => _isLoadingRegister;
  bool get isLoadingLogin => _isLoadingLogin;
  bool get isLoadingGetProfileData => _isLoadingGetProfileData;
  final _picker = ImagePicker();
  File? selectedImage;

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        notifyListeners();
      } else {
        showCustomedToast('Image pick canceled', ToastType.error);
      }
    } catch (e) {
      log('Error picking image: $e');
      showCustomedToast('Error selecting image', ToastType.error);
    }
  }

  Future register() async {
    try {
      otpCtn.text = "";
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();

      final formData = FormData();

      formData.fields.addAll([
        MapEntry('name', userNameController.text),
        MapEntry('phone_number', phoneReisterController.text),
        MapEntry('password', passwordController.text),
        MapEntry('password_confirmation', passwordController.text),
        MapEntry('property_name', shopNameController.text),
        MapEntry('address', locationReisterController.text),
        MapEntry('property_type', shopType ?? ''),
        MapEntry('delegate_name', delegate_nameController.text),
        MapEntry('lat', '0.0'),
        MapEntry('lng', '0.0'),
        MapEntry('city_id', cityId.toString()),
      ]);

      if (selectedImage != null) {
        formData.files.add(
          MapEntry(
            "logo",
            await MultipartFile.fromFile(
              selectedImage!.path,
              filename: selectedImage!.path.split('/').last,
            ),
          ),
        );
      }
      final response = await DioHelper.post(EndPoints.register,
          data: formData, requiresAuth: false);

      if (response['success'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast("otp is >>>>>> " + response['data']['otp'].toString(),
            ToastType.success);
        showModalBottomSheet(
          context: NavigationManager.getContext(),
          isScrollControlled: true,
          // showDragHandle: true,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => VerificationBottomSheet(),
        );
      } else {
        EasyLoading.dismiss();
        notifyListeners();

        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      EasyLoading.dismiss();
      log(e.toString());
    } finally {
      EasyLoading.dismiss();
      _isLoadingRegister = false;
      notifyListeners();
    }
  }

  CityModel? cityModel;
/////get All Citys////
  void getAllCitys() async {
    if (cityModel != null) {
      return;
    }
    try {
      notifyListeners();
      final response =
          await DioHelper.get(EndPoints.citys, requiresAuth: false);
      if (response['success'] == true) {
        cityModel = CityModel.fromJson(response);
        notifyListeners();
      } else {
        notifyListeners();
        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> login() async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final Map<String, dynamic> body = {
        "phone_number": phoneReisterController.text,
        "password": passwordController.text
      };
      log('body: $body');
      final response = await DioHelper.post(EndPoints.login,
          data: body, requiresAuth: false);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        // showCustomedToast(response['message'], ToastType.success);
        sharedPref.setSecureString(
            ConstsClass.jwtTOKEN, response['data']['token']);
        sharedPref.setString(
            ConstsClass.fullNameKey, response['data']['user']['name'] ?? "");
        sharedPref.setString(ConstsClass.shopNameKey,
            response['data']['user']['properties'][0]['name'] ?? "");
        sharedPref.setString(ConstsClass.shopDelegateNameKey,
            response['data']['user']['properties'][0]['delegate_name'] ?? "");
        sharedPref.setString(ConstsClass.shopAddressKey,
            response['data']['user']['properties'][0]['address'] ?? "");
        sharedPref.setString(ConstsClass.shopTypeKey,
            response['data']['user']['properties'][0]['property_type'] ?? "");
        sharedPref.setString(ConstsClass.shopCityKey,
            response['data']['user']['properties'][0]['city'] ?? "");
        sharedPref.setString(ConstsClass.shopLogoKey,
            response['data']['user']['properties'][0]['logo'] ?? "");

        sharedPref.setInt(
            ConstsClass.userIdKey, response['data']['user']['id'] ?? "");

        sharedPref.setBool(ConstsClass.isAuthorized, true);

        NavigationManager.navigatToAndFinish(const MainScreen());
      } else {
        EasyLoading.dismiss();
        notifyListeners();

        showCustomedToast(response['message'], ToastType.error);
      }
    } catch (e) {
      EasyLoading.dismiss();
      log(e.toString());
    } finally {
      EasyLoading.dismiss();
      _isLoadingLogin = false;
      notifyListeners();
    }
  }

  Future<void> verfiyOtpApi() async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final formData = FormData();

      formData.fields.addAll([
        MapEntry('otp', otpCtn.text),
        MapEntry('phone_number', phoneReisterController.text),
      ]);

      if (selectedImage != null) {
        formData.files.add(
          MapEntry(
            "logo",
            await MultipartFile.fromFile(
              selectedImage!.path,
              filename: selectedImage!.path.split('/').last,
            ),
          ),
        );
      }
      final response = await DioHelper.post(EndPoints.verfiyOtpApi,
          data: formData, requiresAuth: false);
      if (response['success'] == true) {
        otpCtn.clear();
        currentStep = 0;
        phoneReisterController.clear();
        passwordController.clear();
        cityName = null;
        cityId = null;
        shopNameController.clear();
        locationReisterController.clear();
        delegate_nameController.clear();
        shopType = null;
        EasyLoading.dismiss();
        showCustomedToast(response['message'], ToastType.success);
        NavigationManager.navigatToAndFinish(LoginScreen());
        notifyListeners();
      } else {
        showCustomedToast(response['message'], ToastType.error);
        EasyLoading.dismiss();
        notifyListeners();
      }
    } catch (e) {
      EasyLoading.dismiss();
      notifyListeners();
      log(e.toString());
    }
  }

  Future<void> forgetPassword() async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final Map<String, dynamic> body = {
        "phone_number": phoneReisterController.text,
      };
      final response = await DioHelper.post(EndPoints.forgotPassword,
          data: body, requiresAuth: false);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast(response['message'], ToastType.success);
        NavigationManager.navigatTo(NewPasswordScreen());
      } else {
        showCustomedToast(response['message'], ToastType.error);
        EasyLoading.dismiss();
        notifyListeners();
      }
    } catch (e) {
      EasyLoading.dismiss();
      notifyListeners();
      log(e.toString());
    }
  }
////resend otp/////

  Future<void> resendOtp() async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final Map<String, dynamic> body = {
        "phone_number": phoneReisterController.text,
      };
      final response = await DioHelper.post(EndPoints.resendOtpAgainApi,
          data: body, requiresAuth: false);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast(response['message'], ToastType.success);
      } else {
        showCustomedToast(response['message'], ToastType.error);
        EasyLoading.dismiss();
        notifyListeners();
      }
    } catch (e) {
      EasyLoading.dismiss();
      notifyListeners();
      log(e.toString());
    }
  }

  ///////reset password/////
  Future<void> resetPassword() async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final Map<String, dynamic> body = {
        "otp": otpCtn.text,
        "phone_number": phoneReisterController.text,
        "password": passwordController.text,
        "password_confirmation": passwordController.text,
      };
      final response = await DioHelper.post(EndPoints.resetPassword,
          data: body, requiresAuth: false);
      if (response['success'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        showCustomedToast(response['message'], ToastType.success);
        NavigationManager.navigatTo(LoginScreen());
      } else {
        showCustomedToast(response['message'], ToastType.error);
        EasyLoading.dismiss();
        notifyListeners();
      }
    } catch (e) {
      EasyLoading.dismiss();
      notifyListeners();
      log(e.toString());
    }
  }

  @override
  void reassemble() {}
}
