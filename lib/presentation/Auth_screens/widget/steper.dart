import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_svg_img.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../app/utils/app_assets.dart';

class CustomStepper extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const CustomStepper(
      {super.key, required this.totalSteps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        bool isActive = index <= currentStep;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (index > 0) 1.5.width,
                Container(
                  width: 9.w,
                  height: 9.w,
                  decoration: BoxDecoration(),
                  child: Center(
                    child: index == 0
                        ? CustomSvgImage(
                            assetName: AppAssets.userIcon,
                            color: isActive ? AppColors.primary : Colors.grey,
                            width: 7.w,
                          )
                        : index == 1
                            ? Icon(
                                Icons.business_rounded,
                                color:
                                    isActive ? AppColors.primary : Colors.grey,
                                size: 7.w,
                              )
                            : Icon(
                                Icons.done,
                                color:
                                    isActive ? AppColors.primary : Colors.grey,
                                size: 7.w,
                              ),
                  ),
                ),
                1.5.width,
                if (index < totalSteps - 1)
                  Container(
                    // margin: EdgeInsets.only(bottom: 3.w),
                    width: 28.w,
                    height: 2,
                    color: isActive ? AppColors.primary : Colors.grey,
                  ),
              ],
            ),
            1.height,
            CustomText(
              text: index == 0
                  ? "المعلومات الشخصية"
                  : index == 1
                      ? "بيانات المنشأة"
                      : "",
              fontSize: AppFonts.t3,
              fontweight: FontWeight.bold,
              color: isActive ? AppColors.primary : Colors.grey,
            ),
          ],
        );
      }),
    );
  }
}
