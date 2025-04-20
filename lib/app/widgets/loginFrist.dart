import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_asset_img.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/presentation/Auth_screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget LoginFristWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CustomImageAsset(
        assetName: AppAssets.appLogo,
        width: 65.w,
      ),
      1.height,
      CustomText(text: 'قم بستجيل الدخول اولا ..', fontSize: AppFonts.t1),
      2.height,
      AppButton(
        'تسجيل الدخول',
        width: 50.w,
        onTap: () {
          NavigationManager.navigatToAndFinish(LoginScreen());
        },
      )
    ],
  );
}
