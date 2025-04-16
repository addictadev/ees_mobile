import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../app/widgets/app_text.dart';

Widget CustomeAppBar({text}) {
  return Container(
    height: 18.h,
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
    child: Padding(
      padding: EdgeInsets.all(4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => NavigationManager.pop(),
            child: Container(
              decoration: getBoxDecoration(fillColor: AppColors.white),
              padding: EdgeInsets.all(1.5.w),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
          CustomText(
            text: text ?? '',
            fontSize: 18.sp,
            color: AppColors.white,
          ),
          SizedBox(width: 3.w),
        ],
      ),
    ),
  );
}
