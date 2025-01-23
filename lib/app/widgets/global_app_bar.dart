import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../navigation_services/navigation_manager.dart';
import '../utils/app_colors.dart';
import 'app_text.dart';

PreferredSizeWidget sharedAppBar(BuildContext context, String title,
    {GestureTapCallback? callback,
    bool centerTitle = true,
    bool backIcon = true,
    double? fontSize = 22,
    Widget? actionIcons,
    double? heighOfAppbar,
    Color? backgroundColor = AppColors.white,
    PreferredSizeWidget? bottom}) {
  return PreferredSize(
    preferredSize: Size(MediaQuery.of(context).size.width,
        bottom != null ? heighOfAppbar! : 60),
    child: Container(
      height: bottom != null ? heighOfAppbar : 120,
      width: double.infinity,
      padding: EdgeInsets.only(top: 0.w),
      child: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: centerTitle == true ? true : false,
        title: CustomText(
          text:title,
          color: AppColors.primary,
          fontSize: fontSize!,
          fontweight: FontWeight.w800,
          isBold: true,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: actionIcons ?? const SizedBox(),
          )
        ],
        bottom: bottom,
        leading: backIcon == false
            ? null
            : GestureDetector(
                onTap: callback ?? () => {NavigationManager.pop()},
                child: SizedBox(
                    width: 22,
                    height: 22,
                    child: ClipRRect(
                        child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppColors.primary,
                      size: 6.5.w,
                    ))),
              ),
      ),
    ),
  );
}
