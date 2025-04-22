import 'dart:math';

import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_cashed_network_image.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/utils/consts.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:ees/app/widgets/custom_app_bar.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:ees/presentation/profile_screen/changePasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../app/dependency_injection/get_it_injection.dart';
import '../../app/utils/local/shared_pref_serv.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final sharedPref = getIt<SharedPreferencesService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              spreadRadius: 1,
            )
          ],
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(4.w), topEnd: Radius.circular(4.w)),
        ),
        padding: EdgeInsets.only(top: 4.w, left: 4.w, right: 4.w, bottom: 5.w),
        height: 10.h,
        child: AppButton(
          'تغيير كلمة المرور',
          onTap: () => NavigationManager.navigatTo(ChangePasswordScreen()),
          hieght: 5.h,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomeAppBar(text: 'البيانات الشخصية'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  1.height,
                  Center(
                    child: Container(
                      decoration: getBoxDecoration(
                          radus: 2.w, fillColor: AppColors.primary),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.w),
                        child: CustomCachedImage(
                          imageUrl:
                              sharedPref.getString(ConstsClass.shopLogoKey),
                          fit: BoxFit.cover,
                          // width: 20.w,
                          // height: 20.w,
                        ),
                      ),
                    ),
                  ),
                  CustomText(
                      color: AppColors.primary,
                      text: 'الاسم',
                      fontSize: AppFonts.t2),
                  AppTextField(
                    hintText: 'ادخل الاسم',
                    readOnly: true,
                    controller: TextEditingController(
                        text: sharedPref.getString(ConstsClass.fullNameKey)),
                  ),
                  CustomText(
                      color: AppColors.primary,
                      text: 'اسم المنشأة',
                      fontSize: AppFonts.t2),
                  AppTextField(
                    hintText: 'ادخل اسم المنشأة',
                    readOnly: true,
                    controller: TextEditingController(
                        text: sharedPref.getString(ConstsClass.shopNameKey)),
                  ),
                  CustomText(
                      color: AppColors.primary,
                      text: 'العنوان',
                      fontSize: AppFonts.t2),
                  AppTextField(
                    hintText: 'ادخل العنوان',
                    readOnly: true,
                    controller: TextEditingController(
                        text: sharedPref.getString(ConstsClass.shopAddressKey)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                color: AppColors.primary,
                                text: 'نوع المنشأة',
                                fontSize: AppFonts.t2),
                            AppTextField(
                              hintText: 'ادخل نوع المنشأة',
                              readOnly: true,
                              controller: TextEditingController(
                                  text: sharedPref
                                      .getString(ConstsClass.shopTypeKey)),
                            ),
                          ],
                        ),
                      ),
                      2.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                color: AppColors.primary,
                                text: 'المدينة',
                                fontSize: AppFonts.t2),
                            AppTextField(
                              hintText: 'ادخل مدينة المنشأة',
                              readOnly: true,
                              controller: TextEditingController(
                                  text: sharedPref
                                      .getString(ConstsClass.shopCityKey)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CustomText(
                      color: AppColors.primary,
                      text: 'اسم المندوب',
                      fontSize: AppFonts.t2),
                  AppTextField(
                    hintText: 'ادخل اسم المندوب',
                    readOnly: true,
                    controller: TextEditingController(
                        text: sharedPref
                            .getString(ConstsClass.shopDelegateNameKey)),
                  ),
                  2.height,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
