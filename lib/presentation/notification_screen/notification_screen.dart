import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomeAppBar(text: 'الاشعارات'),
          Expanded(
              child: Center(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.noNotifications,
                width: 45.w,
              ),
              2.height,
              CustomText(
                  text: 'لا توجد إشعارات حتي الان',
                  fontweight: FontWeight.w600,
                  fontSize: AppFonts.t1,
                  padding: EdgeInsets.only(bottom: 1.h)),
              CustomText(
                  text:
                      'هنا ستظهر لك الإشعارات من التطبيق في حين\n وجود إشعارات جديدة',
                  color: Colors.grey,
                  padding: EdgeInsets.only(bottom: 8.h)),
            ],
          )))
        ],
      ),
    );
  }
}
