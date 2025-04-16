import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_asset_img.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../app/navigation_services/navigation_manager.dart';

Widget customAuthAppBar({required String title}) {
  return Container(
      height: 22.h,
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.sp),
          bottomRight: Radius.circular(15.sp),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          9.height,
          InkWell(
              onTap: () => NavigationManager.pop(),
              child: CustomImageAsset(
                assetName: AppAssets.backIcon,
                width: 12.w,
              )),
          1.height,
          CustomText(
            text: title,
            fontSize: AppFonts.h3,
            color: AppColors.white,
            fontweight: FontWeight.bold,
          ),
        ],
      ));
}
