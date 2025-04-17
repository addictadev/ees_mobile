import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app/images_preview/custom_svg_img.dart';
import '../../app/utils/app_assets.dart';
import '../../app/utils/app_fonts.dart';
import '../../app/utils/validators.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_text.dart';
import '../../app/widgets/app_text_field.dart';
import '../../controllers/auth_controller.dart';
import '../Auth_screens/widget/custom_auth_appBar.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final GlobalKey<FormState> forgetPassKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          customAuthAppBar(title: "نسيت كلمة المرور"),
          Expanded(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Consumer<AuthController>(
                    builder: (BuildContext context, value, Widget? child) {
                  return Form(
                      key: forgetPassKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            2.height,
                            Center(
                              child: Image.asset(
                                AppAssets.appLogo,
                                width: 60.w,
                              ),
                            ),
                            2.height,
                            Center(
                              child: CustomText(
                                  text:
                                      'ادخل رقم الجوال المسجل لدينا\n لاستعادة كلمة المرور الخاصه بك'),
                            ),
                            4.height,
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
                            4.height,
                            AppButton('تآكيد', onTap: () {
                              if (forgetPassKey.currentState!.validate()) {
                                value.forgetPassword();
                              }
                            }),
                          ]));
                })),
          ),
        ],
      ),
    );
  }
}
