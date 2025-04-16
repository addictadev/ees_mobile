import 'dart:developer';

import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_svg_img.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:ees/app/widgets/custom_drop_down.dart';
import 'package:ees/controllers/auth_controller.dart';
import 'package:ees/models/cityModels.dart';
import 'package:ees/presentation/Auth_screens/widget/custom_auth_appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/utils/validators.dart';
import '../../../app/widgets/app_button.dart';
import '../widget/steper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AuthController>(context, listen: false).getAllCitys();
    });
  }

  Future showImageOptions(AuthController controller) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CupertinoActionSheet(
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              'Cancel'.tr(),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            CupertinoActionSheetAction(
              child: Text("Take a Photo".tr(),
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                controller.pickImage(
                  ImageSource.camera,
                );
              },
            ),
            CupertinoActionSheetAction(
              child: Text("Upload Photo".tr(),
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                controller.pickImage(
                  ImageSource.gallery,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
        builder: (BuildContext context, value, Widget? child) {
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customAuthAppBar(title: "تسجيل مستخدم جديد"),
            Padding(
              padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 5.w),
              child: CustomStepper(
                totalSteps: 3,
                currentStep: value.currentStep,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    if (value.currentStep == 0)
                      Form(
                        key: value.registerFristFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            4.height,
                            CustomText(
                              text: 'الاسم',
                              fontSize: AppFonts.t4,
                            ),
                            AppTextField(
                              hintText: 'ادخل اسمك ثلاثي',
                              controller: value.userNameController,
                              validator: (p0) => Validator.name(p0),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomSvgImage(
                                  assetName: AppAssets.userIcon,
                                  width: 1.w,
                                  height: 1.w,
                                ),
                              ),
                            ),
                            1.5.height,
                            CustomText(
                              text: 'رقم الموبايل',
                              fontSize: AppFonts.t4,
                            ),
                            AppTextField(
                              hintText: 'ادخل رقم الموبايل',
                              validator: (p0) => Validator.phoneValidator(p0),
                              controller: value.phoneReisterController,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomSvgImage(
                                  assetName: AppAssets.phoneIcon,
                                  width: 1.w,
                                  height: 1.w,
                                ),
                              ),
                            ),
                            1.height,
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.darkOrange,
                                  size: 5.w,
                                ),
                                CustomText(
                                    text:
                                        'من فضلك ادخل رقم الموبايل المسجل لدينا',
                                    fontSize: AppFonts.t5,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 1.w),
                                    color: AppColors.darkOrange)
                              ],
                            ),
                            1.5.height,
                            CustomText(
                              text: 'كلمة المرور',
                              fontSize: AppFonts.t4,
                            ),
                            AppTextField(
                              hintText: 'ادخل كلمة المرور',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  Iconsax.key,
                                  color: Colors.grey,
                                ),
                              ),
                              obscureText: !value.isPasswordVisible,
                              validator: (value) => Validator.password(value),
                              controller: value.passwordController,
                              suffixIconOnTap: () =>
                                  value.togglePasswordVisibility(),
                              suffixIcon: value.isPasswordVisible
                                  ? Iconsax.eye
                                  : Iconsax.eye_slash,
                            ),
                            5.height,
                          ],
                        ),
                      ),
                    if (value.currentStep == 1)
                      Form(
                        key: value.registerSecondFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            4.height,
                            CustomText(
                                text: 'لوجو المنشأة', fontSize: AppFonts.t4),
                            AppTextField(
                              readOnly: true,
                              validator: (p0) => Validator.name(p0),
                              controller: TextEditingController(
                                  text: value.selectedImage?.path.toString()),
                              prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Icon(
                                    Iconsax.document_upload,
                                    color: Colors.grey,
                                  )),
                              hintText: 'ادخل لوجو المنشأة',
                              isFilled: true,
                              onTap: () => showImageOptions(value),
                            ),
                            1.5.height,
                            CustomText(
                              text: 'اسم المنشأة',
                              fontSize: AppFonts.t4,
                            ),
                            AppTextField(
                              hintText: 'ادخل اسم المنشأة',
                              validator: (p0) => Validator.name(p0),
                              controller: value.shopNameController,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomSvgImage(
                                  assetName: AppAssets.userIcon,
                                  width: 1.w,
                                  height: 1.w,
                                ),
                              ),
                            ),
                            1.5.height,
                            Row(
                              children: [
                                Expanded(
                                  child: CustomDropdown(
                                    items: ['محل', 'مخزن'],
                                    onChanged: (val) {
                                      value.shopType = val;
                                    },
                                    value: value.shopType,
                                    validator: (p0) => Validator.name(p0),
                                    hintText: 'اختر نوع المنشأة',
                                    labelText: 'نوع المنشأة',
                                  ),
                                ),
                                3.width,
                                Expanded(
                                  child: CustomDropdown<Data>(
                                    items: value
                                        .cityModel!.data!, // نوعها List<City>
                                    onChanged: (Data? selectedCity) {
                                      if (selectedCity != null) {
                                        log('Selected City ID: ${selectedCity.id}');
                                        setState(() {
                                          value.cityId = selectedCity.id
                                              .toString(); // خزّن الـ id
                                        });
                                      }
                                    },
                                    value: value.cityId == null ||
                                            value.cityId!.isEmpty
                                        ? null
                                        : value.cityModel!.data!.firstWhere(
                                            (city) =>
                                                city.id.toString() ==
                                                value.cityId,
                                          ),
                                    itemToString: (city) => city.name!,
                                    validator: (val) =>
                                        Validator.name(val?.name),
                                    hintText: 'اختر المدينة',
                                    labelText: 'المدينة',
                                  ),
                                ),
                              ],
                            ),
                            1.5.height,
                            // CustomText(
                            //   text: 'موقع المنشأة علي الخريطة',
                            //   fontSize: AppFonts.t4,
                            // ),
                            // 1.5.height,
                            // InkWell(
                            //   onTap: () {
                            //     NavigationManager.navigatTo(
                            //         SelectLocationScreen());
                            //   },
                            //   child: CustomImageAsset(
                            //     assetName: AppAssets.location,
                            //     width: 100.w,
                            //   ),
                            // ),
                            // 1.5.height,
                            CustomText(
                              text: 'العنوان',
                              fontSize: AppFonts.t4,
                            ),
                            AppTextField(
                              hintText: 'ادخل العنوان بالتقريب',
                              controller: value.locationReisterController,
                              validator: (p0) => Validator.name(p0),
                            ),
                            1.5.height,
                            CustomText(
                              text: 'اسم المندوب',
                              fontSize: AppFonts.t4,
                            ),
                            AppTextField(
                              hintText: 'ادخل اسم المندوب',
                              validator: (p0) => Validator.name(p0),
                              controller: value.delegate_nameController,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomSvgImage(
                                  assetName: AppAssets.userIcon,
                                  width: 1.w,
                                  height: 1.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    1.5.height,
                    Row(
                      children: [
                        if (value.currentStep != 0)
                          Expanded(
                            child: AppButton(
                              'السابق',
                              WithBackIcon: true,
                              onTap: () {
                                value.currentStep--;
                                value.changeStep(value.currentStep);
                              },
                              buttonIcon: Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        if (value.currentStep != 0) 2.width,
                        Expanded(
                          child: AppButton(
                            'متابعة',
                            onTap: () {
                              if (value.currentStep == 0 &&
                                  value.registerFristFormKey.currentState!
                                      .validate()) {
                                value.currentStep++;

                                value.changeStep(1);
                              } else if (value.currentStep == 1 &&
                                  value.registerSecondFormKey.currentState!
                                      .validate()) {
                                value.register();
                              }
                            },
                            buttonIcon: Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    1.5.height,
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                              text: 'لديك حساب مسجل؟',
                              fontSize: AppFonts.t4,
                              isBold: true),
                          1.width,
                          CustomText(
                              text: 'سجل الدخول الان',
                              fontSize: AppFonts.t4,
                              color: AppColors.btnColor,
                              isBold: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
