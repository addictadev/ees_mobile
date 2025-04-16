import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_asset_img.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../app/widgets/app_text.dart';

Widget HomeAppBar({bool isHome = true, text}) {
  return Container(
    height: isHome ? 23.h : 18.h,
    width: 100.w,
    margin: EdgeInsets.only(bottom: 1.h),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(4.w),
        bottomRight: Radius.circular(4.w),
      ),
    ),
    padding: EdgeInsets.only(top: 9.h),
    child: Column(
      children: [
        CustomText(
          text: text ?? 'الشركة المصرية للحلول الكهربائية',
          fontSize: 18.sp,
          color: AppColors.white,
        ),
        1.5.height,
        if (isHome)
          CustomImageAsset(
            assetName: AppAssets.appLogo,
            width: 42.w,
          )
      ],
    ),
  );
}
