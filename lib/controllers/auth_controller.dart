import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import '../app/dependency_injection/get_it_injection.dart';
import '../app/utils/consts.dart';
import '../app/utils/local/shared_pref_serv.dart';
import '../app/utils/network/dio_helper.dart';
import '../app/utils/network/end_points.dart';

class AuthController with ChangeNotifier implements ReassembleHandler {
  IconData loginVisibilityIcon = Icons.visibility_off_outlined;
  IconData clientRegister1VisibilityIcon = Icons.visibility_off_outlined;
  IconData oldIcon = Icons.visibility_off_outlined;
  IconData clientRegister2VisibilityIcon = Icons.visibility_off_outlined;
  bool loginVisibality = true;
  bool clientRegister1Visibality = true;
  bool olpassVisibality = true;
  bool clientRegister2Visibality = true;
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
  TextEditingController userNameController = TextEditingController();
  TextEditingController locationReisterController = TextEditingController();
  TextEditingController phoneReisterController = TextEditingController();
  double? lat;
  double? lng;
  final sharedPref = getIt<SharedPreferencesService>();

  XFile? profileImage;
  final bool _isLoadingRegister = false;
  bool _isLoadingLogin = false;
  final bool _isLoadingGetProfileData = false;
  bool get isLoadingRegister => _isLoadingRegister;
  bool get isLoadingLogin => _isLoadingLogin;
  bool get isLoadingGetProfileData => _isLoadingGetProfileData;

  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r'^01\d{9}$');

    phoneNumber = phoneNumber.replaceAll(RegExp(r'\s+|-'), '');

    return regex.hasMatch(phoneNumber);
  }

  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
      caseSensitive: false,
      multiLine: false,
    );

    return regex.hasMatch(email);
  }

  // Future<void> register() async {
  //   try {
  //     EasyLoading.show(
  //       maskType: EasyLoadingMaskType.black,
  //     );
  //     notifyListeners();
  //     final Map<String, dynamic> body = {
  //       "fullname": userNameController.text,
  //       "email": emailController.text,
  //       "password": passwordController.text,
  //       "location": locationReisterController.text,
  //       "latitude": lat.toString(),
  //       "longitude": lng.toString(),
  //       "phone": phoneReisterController.text
  //     };

  //     final formData = FormData.fromMap(body);
  //     if (profileImage != null) {
  //       final File compressedImage =
  //           await CompressionUtil.compressImage(profileImage!.path);

  //       formData.files.add(MapEntry(
  //         'image',
  //         await MultipartFile.fromFile(
  //           compressedImage.path,
  //           filename: 'compressedImage.jpg',
  //         ),
  //       ));
  //     }

  //     log('body: $body');
  //     final response = await DioHelper.post(EndPoints.register,
  //         data: formData, requiresAuth: false);

  //     if (response['status'] == true) {
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //       showCustomedToast(response['message'], ToastType.success);
  //       NavigationManager.navigatToAndFinish(const LoginScreen());
  //     } else {
  //       EasyLoading.dismiss();
  //       notifyListeners();

  //       showCustomedToast(response['message'], ToastType.error);
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     log(e.toString());
  //   } finally {
  //     EasyLoading.dismiss();
  //     _isLoadingRegister = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> login() async {
    try {
      EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
      );
      notifyListeners();
      final Map<String, dynamic> body = {
        "email": emailController.text,
        "password": passwordController.text
      };
      log('body: $body');
      final response = await DioHelper.post(EndPoints.login,
          data: body, requiresAuth: false);
      if (response['status'] == true) {
        EasyLoading.dismiss();
        notifyListeners();
        // showCustomedToast(response['message'], ToastType.success);
        sharedPref.setSecureString(
            ConstsClass.jwtTOKEN, response['data']['authorization']['token']);
        sharedPref.setString(ConstsClass.fullNameKey,
            response['data']['user'][0]['us_fullName'] ?? "");
        sharedPref.setInt(
            ConstsClass.userIdKey, response['data']['user'][0]['us_id'] ?? "");
        sharedPref.setString(ConstsClass.emailKey,
            response['data']['user'][0]['us_email'] ?? "");
        sharedPref.setString(ConstsClass.phoneKey,
            response['data']['user'][0]['addresses'][0]['usa_phone'] ?? "");
        sharedPref.setString(ConstsClass.addressKey,
            response['data']['user'][0]['addresses'][0]['usa_location'] ?? "");
        final selectedAddress =
            response['data']['user'][0]['addresses'].firstWhere(
          (element) => element['usa_isUsed'] == "1",
          orElse: () => response['data']['user'][0]['addresses'].first,
        );
        log('selectedAddress $selectedAddress');
        sharedPref.setString(ConstsClass.userAddressUsedId,
            selectedAddress['usa_id'].toString() ?? "");
        sharedPref.setString(ConstsClass.userLatitude,
            selectedAddress['usa_latitude'].toString() ?? "");
        sharedPref.setString(ConstsClass.userLongitude,
            selectedAddress['usa_longitude'].toString() ?? "");
        sharedPref.setString(ConstsClass.userImage,
            'https://${response['data']['path']}/${response['data']['user'][0]['us_image']}');
        sharedPref.setBool(ConstsClass.isAuthorized, true);

        // NavigationManager.navigatToAndFinish(const IndexedScreen());
        // NavigationManager.navigatToAndFinish(const SellectTypeScreen());
      } else {
        EasyLoading.dismiss();
        notifyListeners();

        // showCustomedToast(response['message'], ToastType.error);
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

  // Future<void> forgotPassword() async {
  //   try {
  //     EasyLoading.show(
  //       maskType: EasyLoadingMaskType.black,
  //     );
  //     notifyListeners();
  //     final Map<String, dynamic> body = {"email": emailController.text};
  //     final response = await DioHelper.post(EndPoints.forgotPassword,
  //         data: body, requiresAuth: false);
  //     if (response['status'] == true) {
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //       showCustomedToast('${response['message']} ${response['data']['otp']}',
  //           ToastType.success);
  //       NavigationManager.navigatTo(const OtpScreen());
  //     } else {
  //       showCustomedToast(response['message'], ToastType.error);
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     notifyListeners();
  //     log(e.toString());
  //   }
  // }

  // Future<void> verfiyOtpApi(var otp) async {
  //   try {
  //     EasyLoading.show(
  //       maskType: EasyLoadingMaskType.black,
  //     );
  //     notifyListeners();
  //     final Map<String, dynamic> body = {
  //       "email": emailController.text,
  //       "otp": otp
  //     };
  //     final response = await DioHelper.post(EndPoints.verfiyOtpApi,
  //         data: body, requiresAuth: false);
  //     if (response['status'] == true) {
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //       showCustomedToast(response['message'], ToastType.success);
  //       NavigationManager.navigatTo(ResetPasswordScreen(
  //         otp: otp,
  //       ));
  //     } else {
  //       showCustomedToast(response['message'], ToastType.error);
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     notifyListeners();
  //     log(e.toString());
  //   }
  // }

  // Future<void> resendOtpAgainApi() async {
  //   try {
  //     EasyLoading.show(
  //       maskType: EasyLoadingMaskType.black,
  //     );
  //     notifyListeners();
  //     final Map<String, dynamic> body = {
  //       "email": emailController.text,
  //     };
  //     final response = await DioHelper.post(EndPoints.resendOtpAgainApi,
  //         data: body, requiresAuth: false);
  //     if (response['status'] == true) {
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //       showCustomedToast('${response['message']} ${response['data']['otp']}',
  //           ToastType.success);
  //     } else {
  //       showCustomedToast(response['message'], ToastType.error);
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     notifyListeners();
  //     log(e.toString());
  //   }
  // }

  // Future<dynamic> resetPassword(var otp) async {
  //   try {
  //     EasyLoading.show(
  //       maskType: EasyLoadingMaskType.black,
  //     );
  //     notifyListeners();
  //     final Map<String, dynamic> body = {
  //       "email": emailController.text,
  //       "otp": otp,
  //       "password": passwordController.text
  //     };
  //     final response = await DioHelper.post(EndPoints.resetPassword,
  //         data: body, requiresAuth: false);
  //     if (response['status'] == true) {
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //       showCustomedToast(response['message'], ToastType.success);
  //       NavigationManager.navigatToAndFinish(const LoginScreen());
  //     } else {
  //       showCustomedToast(response['message'], ToastType.error);
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     notifyListeners();
  //     log(e.toString());
  //   }
  // }

  // UserProfileModel? userProfileModel;
  // Future<UserProfileModel?>? getUserProfileData() async {
  //   try {
  //     _isLoadingGetProfileData = true;
  //     notifyListeners();

  //     final response =
  //         await DioHelper.get(EndPoints.userProfile, requiresAuth: true);
  //     if (response['status'] == true) {
  //       _isLoadingGetProfileData = false;
  //       notifyListeners();
  //       userProfileModel = UserProfileModel.fromJson(response);
  //       sharedPref.setString(ConstsClass.userImage,
  //           'https://${response['data']['path']}/${response['data']['user'][0]['us_image']!.toString()}');
  //       notifyListeners();
  //     } else {
  //       _isLoadingGetProfileData = false;
  //       notifyListeners();
  //     }
  //     return userProfileModel;
  //   } catch (e) {
  //     _isLoadingGetProfileData = false;
  //     notifyListeners();
  //     log(e.toString());
  //   }
  //   return null;
  // }

  // Future<void> editUserProfile(File? image) async {
  //   try {
  //     EasyLoading.show(
  //       maskType: EasyLoadingMaskType.black,
  //     );
  //     notifyListeners();
  //     final Map<String, dynamic> body = {
  //       "fullname": userNameController.text,
  //       "email": emailController.text,
  //       "phone": phoneReisterController.text,
  //       "addressUsedId": sharedPref.getString(ConstsClass.userAddressUsedId),
  //     };
  //     final formData = FormData.fromMap(body);
  //     if (image != null) {
  //       final File compressedImage =
  //           await CompressionUtil.compressImage(image.path);

  //       formData.files.add(
  //         MapEntry(
  //           'image',
  //           await MultipartFile.fromFile(
  //             compressedImage.path,
  //             filename: 'compressedImage.jpg',
  //           ),
  //         ),
  //       );
  //     }
  //     log(body.toString());
  //     final response = await DioHelper.post(EndPoints.editUserProfile,
  //         data: formData, requiresAuth: true);
  //     if (response['status'] == true) {
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //       showCustomedToast(response['message'], ToastType.success);
  //       NavigationManager.navigatToAndFinish(const IndexedScreen());
  //       getUserProfileData();
  //     } else {
  //       showCustomedToast(response['message'], ToastType.error);
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     notifyListeners();
  //     log(e.toString());
  //   }
  // }

  // Future<void> logout() async {
  //   try {
  //     EasyLoading.show(
  //       maskType: EasyLoadingMaskType.black,
  //     );
  //     notifyListeners();
  //     final response = await DioHelper.post(
  //       EndPoints.logout,
  //       requiresAuth: true,
  //     );
  //     if (response['status'] == true) {
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //       sharedPref.clear();
  //       NavigationManager.navigatToAndFinish(const LoginScreen());
  //     } else {
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //       showCustomedToast(response['message'], ToastType.error);
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     notifyListeners();
  //     log(e.toString());
  //   }
  // }

  // Future<void> deleteAccount() async {
  //   try {
  //     EasyLoading.show(
  //       maskType: EasyLoadingMaskType.black,
  //     );
  //     notifyListeners();
  //     final response = await DioHelper.post(
  //       EndPoints.deleteAcount,
  //       requiresAuth: true,
  //     );
  //     if (response['status'] == true) {
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //       sharedPref.clear();
  //       NavigationManager.navigatToAndFinish(const LoginScreen());
  //     } else {
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //       showCustomedToast(response['message'], ToastType.error);
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     notifyListeners();
  //     log(e.toString());
  //   }
  // }

  // Future<void> checkLocation() async {
  //   try {
  //     // Check if location services are enabled
  //     final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       throw Exception("Location services are disabled. Please enable them.");
  //     }

  //     // Check and request location permissions
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         throw Exception("Location permissions are denied.");
  //       }
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       throw Exception(
  //           "Location permissions are permanently denied. Please enable them in device settings.");
  //     }

  //     // Get current location
  //     final Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);

  //     final double lat = position.latitude;
  //     final double lng = position.longitude;

  //     final Map<String, dynamic> body = {
  //       "latitude": lat.toString(),
  //       "longitude": lng.toString(),
  //     };

  //     // Make the API request
  //     final response = await DioHelper.post(
  //       EndPoints.checkLocation,
  //       data: body,
  //       requiresAuth: true,
  //     );

  //     if (response['status'] == true) {
  //       EasyLoading.dismiss();
  //       notifyListeners();

  //       if (response['data']['addNewLocation'] == true) {
  //         showCupertinoModalPopup(
  //           barrierDismissible: false,
  //           context: NavigationManager.getContext(),
  //           builder: (BuildContext context) {
  //             return Container(
  //               padding: EdgeInsets.all(3.w),
  //               decoration: const BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius:
  //                     BorderRadius.vertical(top: Radius.circular(16.0)),
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text(
  //                     isArabic() ? "تنبيه" : "Warning",
  //                     style: translator.activeLanguageCode == "ar"
  //                         ? GoogleFonts.almarai(
  //                             color: AppColors.orangeColor,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 18.sp,
  //                           )
  //                         : GoogleFonts.bellotaText(
  //                             color: AppColors.orangeColor,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 18.sp,
  //                           ),
  //                   ),
  //                   SizedBox(height: 2.w),
  //                   Text(
  //                     isArabic()
  //                         ? "هل تريد تحديث العنوان ؟"
  //                         : "Are you sure you want to update the location?",
  //                     textAlign: TextAlign.center,
  //                     style: translator.activeLanguageCode == "ar"
  //                         ? GoogleFonts.almarai(fontSize: 14.sp)
  //                         : GoogleFonts.bellotaText(fontSize: 14.sp),
  //                   ),
  //                   2.height,
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       AppButton(
  //                         width: 30.w,
  //                         hieght: 6.h,
  //                         isArabic() ? 'إلغاء' : 'Cancel'.tr(),
  //                         onTap: () {
  //                           Navigator.of(context)
  //                               .pop(); // Close the bottom sheet
  //                         },
  //                       ),
  //                       AppButton(
  //                         width: 30.w,
  //                         hieght: 6.h,
  //                         isArabic() ? 'تأكيد' : 'Confirm'.tr(),
  //                         bgColor: AppColors.orangeColor,
  //                         onTap: () {
  //                           // Navigator.of(context).pop();
  //                           Navigator.of(context).pop();
  //                           NavigationManager.navigatTo(
  //                               const AddAddressScreen());
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                   1.5.height
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       }
  //     } else {
  //       showCustomedToast(response['message'], ToastType.error);
  //       EasyLoading.dismiss();
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     notifyListeners();
  //     log(e.toString());
  //     showCustomedToast(
  //       e.toString(),
  //       ToastType.error,
  //     );
  //   }
  // }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    phoneReisterController.dispose();
    locationReisterController.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    log('Did hot-reload');
  }
}
