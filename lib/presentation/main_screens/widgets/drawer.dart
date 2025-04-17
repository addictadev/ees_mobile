import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/presentation/Auth_screens/login_screen/login_screen.dart';
import 'package:ees/presentation/static_screens/contactUs_screen/contactUsScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../notification_screen/notification_screen.dart';
import 'drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          8.height,
          Image.asset(AppAssets.appLogo, height: 8.h),
          5.height,
          DrawerItem(icon: Icons.person_2_outlined, title: "البيانات الشخصية"),
          DrawerItem(
            icon: Icons.notifications_none_outlined,
            title: "الإشعارات",
            onTap: () {
              NavigationManager.pop();
              NavigationManager.navigatTo(NotificationScreen());
            },
          ),
          // Divider(),
          DrawerItem(
            icon: Icons.wallet_giftcard,
            title: "ادفع بالآجل",
            textColor: AppColors.lightOrange,
            color: AppColors.brown,
            tag: "قريبًا",
          ),
          DrawerItem(
            icon: Icons.phone,
            title: "إتصل بنا",
            onTap: () {
              NavigationManager.pop();
              NavigationManager.navigatToAndFinish(Contactusscreen());
            },
          ),
          Spacer(),
          DrawerItem(
            icon: Icons.delete_outline_outlined,
            title: "حذف الحساب",
            color: Colors.red.withOpacity(.2),
            textColor: Colors.red,
          ),
          DrawerItem(
            icon: Icons.logout,
            title: "تسجيل الخروج",
            color: Colors.red.withOpacity(.2),
            onTap: () {
              NavigationManager.navigatToAndFinish(LoginScreen());
            },
            textColor: Colors.red,
          ),
          2.height
        ],
      ),
    );
  }
}
