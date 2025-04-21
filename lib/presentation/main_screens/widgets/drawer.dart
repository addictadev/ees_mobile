import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/controllers/auth_controller.dart';
import 'package:ees/presentation/Auth_screens/login_screen/login_screen.dart';
import 'package:ees/presentation/profile_screen/myProfileScreen.dart';
import 'package:ees/presentation/static_screens/contactUs_screen/contactUsScreen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app/dependency_injection/get_it_injection.dart';
import '../../../app/utils/consts.dart';
import '../../../app/utils/local/shared_pref_serv.dart';
import '../../../app/widgets/app_text.dart';
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
                onTap: () => NavigationManager.navigatTo(ProfileScreen()),
                icon: Icons.person_2_outlined,
                title: "البيانات الشخصية"),
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
            title: "الشروط والاحكام",
            onTap: () {
              NavigationManager.navigatTo(TermsAndConditionScreen(
                isTerms: true,
              ));
            },
          ),
          DrawerItem(
            icon: Iconsax.security,
            title: "سياسة الخصوصية",
            onTap: () {
              NavigationManager.navigatTo(TermsAndConditionScreen(
                isTerms: false,
              ));
            },
          ),
          Spacer(),
          if (IsLogin())
            DrawerItem(
              icon: Icons.delete_outline_outlined,
              title: "حذف الحساب",
              color: Colors.red.withOpacity(.2),
              textColor: Colors.red,
              onTap: () => showDeleteAccountDialog(context, () {
                Provider.of<AuthController>(context, listen: false)
                    .deleteAccount();
              }),
            ),
          DrawerItem(
            icon: Icons.logout,
            title: IsLogin() ? "تسجيل الخروج" : "تسجيل الدخول",
            color: Colors.red.withOpacity(.2),
            onTap: () {
              if (IsLogin()) {
                Provider.of<AuthController>(context, listen: false).logout();
              } else {
                sharedPref.clear();
                NavigationManager.navigatToAndFinish(LoginScreen());
              }
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

void showDeleteAccountDialog(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.w, right: 2.w),
                    child: Icon(
                      Icons.close,
                      size: 6.w,
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Icon(Iconsax.warning_2, color: AppColors.red, size: 15.w),
              SizedBox(height: 1.5.h),
              const Text(
                'هل أنت متأكد من حذف الحساب؟',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'بمجرد تأكيد الحذف، لن تتمكن من استعادة حسابك أو بياناتك.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: CustomText(text: 'إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                      ),
                      child: CustomText(text: 'حذف', color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
