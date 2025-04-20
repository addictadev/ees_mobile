import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/presentation/Auth_screens/login_screen/login_screen.dart';
import 'package:ees/presentation/static_screens/contactUs_screen/contactUsScreen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import '../../../app/dependency_injection/get_it_injection.dart';
import '../../../app/utils/consts.dart';
import '../../../app/utils/local/shared_pref_serv.dart';
import '../../notification_screen/notification_screen.dart';
import '../../static_screens/termsAndCondition/termsAndConditions.dart';
import 'drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedPref = getIt<SharedPreferencesService>();

    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          8.height,
          Image.asset(AppAssets.appLogo, height: 8.h),
          5.height,
          if (sharedPref.getBool(ConstsClass.isAuthorized))
            DrawerItem(
                icon: Icons.person_2_outlined, title: "البيانات الشخصية"),
          if (sharedPref.getBool(ConstsClass.isAuthorized))
            DrawerItem(
              icon: Icons.notifications_none_outlined,
              title: "الإشعارات",
              onTap: () {
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
              NavigationManager.navigatTo(Contactusscreen());
            },
          ),
          DrawerItem(
            icon: Iconsax.document,
            title: "الشروط و الاحكام",
            onTap: () {
              NavigationManager.navigatTo(TermsAndConditionScreen());
            },
          ),
          Spacer(),
          if (IsLogin())
            DrawerItem(
              icon: Icons.delete_outline_outlined,
              title: "حذف الحساب",
              color: Colors.red.withOpacity(.2),
              textColor: Colors.red,
            ),
          DrawerItem(
            icon: Icons.logout,
            title: IsLogin() ? "تسجيل الخروج" : "تسجيل الدخول",
            color: Colors.red.withOpacity(.2),
            onTap: () {
              sharedPref.clear();
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

bool IsLogin() {
  final sharedPref = getIt<SharedPreferencesService>();
  return sharedPref.getBool(ConstsClass.isAuthorized);
}
