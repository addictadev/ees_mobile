import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_svg_img.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:ees/presentation/main_screens/main_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void showCartBottomSheet(BuildContext context,
    {required miuOrder, required int cartCount, required cartTotal}) {
  showModalBottomSheet(
    context: context,
    isDismissible: true, // Prevent manual dismiss
    enableDrag: false,
    elevation: 0.7,
    backgroundColor: Colors.white, //
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),

    builder: (context) {
      // Automatically dismiss after 3 seconds
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
      return Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            1.height,
            CustomText(
                text: 'تم الاضافة للسلة',
                fontSize: 16.sp,
                fontweight: FontWeight.w700,
                color: AppColors.green),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('الحد الادنى للطلب ',
                              style: TextStyle(color: Colors.grey)),
                          Text('$miuOrder ',
                              style: TextStyle(color: AppColors.lightOrange)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('عدد المنتجات ',
                              style: TextStyle(color: Colors.grey)),
                          Text('$cartCount',
                              style: TextStyle(color: AppColors.lightOrange)),
                        ],
                      ),
                      SizedBox(width: 55.w, child: Divider()),
                      Row(
                        children: [
                          Text('إجمالي الطلب ',
                              style: TextStyle(color: Colors.grey)),
                          Text('$cartTotal ج.م',
                              style: TextStyle(
                                  color: AppColors.lightOrange,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      2.height
                    ],
                  ),
                ),
                3.width,
                InkWell(
                  onTap: () => NavigationManager.navigatToAndFinish(MainScreen(
                    currentIndex: 1,
                  )),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: getBoxDecoration(
                            withShadwos: false,
                            fillColor: AppColors.primary.withOpacity(.1)),
                        child: CustomSvgImage(
                            assetName: AppAssets.cartIcon,
                            width: 7.w,
                            color: AppColors.primary),
                      ),
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.primary,
                          child: Text('$cartCount',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
