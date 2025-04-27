import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/presentation/main_screens/main_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

void showOrderSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.shopping_cart, size: 60, color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              'طلبيتك تمت بنجاح',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'طلبك قيد المراجعة اذهب إلى فواتيري\nلمتابعة حالة الطلبات',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              'الرئيسية',
              borderColor: AppColors.primary,
              bgColor: Colors.white,
              titleColor: AppColors.primary,
              hasBorder: true,
              hieght: 5.5.h,
              onTap: () {
                NavigationManager.navigatToAndFinish(
                    MainScreen()); // Navigate to home
              },
            ),
            SizedBox(height: 1.5.h),
            AppButton(
              'فواتيري',
              hieght: 5.5.h,
              onTap: () {
                NavigationManager.navigatToAndFinish(MainScreen(
                  currentIndex: 2,
                )); // Navigate to home
              },
            ),
          ],
        ),
      ),
    ),
  );
}
