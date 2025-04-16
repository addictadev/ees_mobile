import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_svg_img.dart';
import 'package:ees/app/navigation_services/navigation_manager.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:ees/controllers/auth_controller.dart';
import 'package:ees/presentation/Auth_screens/signUp_screen/signUp_screen.dart';
import 'package:ees/presentation/forget_pass_screen/forgetPassScreen.dart';
import 'package:ees/presentation/main_screens/main_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app/utils/validators.dart';
import '../../../app/widgets/app_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Consumer<AuthController>(
              builder: (BuildContext context, value, Widget? child) {
            return Form(
              key: value.loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.height,
                  Center(
                    child: Image.asset(
                      AppAssets.appLogo,
                      width: 80.w,
                    ),
                  ),
                  2.height,
                  Center(
                    child: CustomText(
                        text: 'أهلًا بك!', fontSize: AppFonts.t1, isBold: true),
                  ),
                  1.height,
                  Center(
                    child: CustomText(
                        text:
                            'دلوقتي تقدر تشوف الاف المنتجات وتعمل\n طلبيتك بسهولة'),
                  ),
                  4.height,
                  CustomText(
                    text: 'رقم الموبايل',
                    fontSize: AppFonts.t4,
                  ),
                  AppTextField(
                    hintText: 'ادخل رقم الموبايل',
                    validator: (p0) => Validator.phoneValidator(p0),
                    controller: value.phoneReisterController,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CustomSvgImage(
                        assetName: AppAssets.phoneIcon,
                        width: 1.w,
                        height: 1.w,
                      ),
                    ),
                  ),
                  1.height,
                  CustomText(
                    text: 'كلمة المرور',
                    fontSize: AppFonts.t4,
                  ),
                  AppTextField(
                    hintText: 'ادخل كلمة المرور',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Iconsax.key,
                        color: Colors.grey,
                      ),
                    ),
                    obscureText: !value.isPasswordVisible,
                    validator: (value) => Validator.password(value),
                    controller: value.passwordController,
                    suffixIconOnTap: () => value.togglePasswordVisibility(),
                    suffixIcon: value.isPasswordVisible
                        ? Iconsax.eye
                        : Iconsax.eye_slash,
                  ),
                  2.height,
                  Row(children: [
                    CustomText(
                      text: 'نسيت كلمة المرور ؟',
                    ),
                    1.width,
                    InkWell(
                      onTap: () => NavigationManager.navigatTo(
                        ForgetPassScreen(),
                      ),
                      child: CustomText(
                        text: 'استعادة كلمة المرور',
                        color: AppColors.primary,
                        isBold: true,
                        fontweight: FontWeight.w700,
                      ),
                    ),
                  ]),
                  3.height,
                  AppButton('تسجيل الدخول', onTap: () {
                    if (value.loginFormKey.currentState!.validate()) {
                      value.login();
                    }
                  }),
                  2.height,
                  Center(
                    child: CustomText(
                        text: 'ليس لديك حساب؟',
                        fontSize: AppFonts.t4,
                        isBold: true),
                  ),
                  2.height,
                  AppButton(
                    bgColor: AppColors.white,
                    borderColor: AppColors.primary,
                    hasBorder: true,
                    titleColor: AppColors.primary,
                    'انشاء حساب جديد',
                    onTap: () => NavigationManager.navigatTo(SignupScreen()),
                  ),
                  2.height,
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.login,
                          color: AppColors.primary,
                        ),
                        2.width,
                        CustomText(
                            onTap: () =>
                                NavigationManager.navigatTo(MainScreen()),
                            text: 'تسجيل دخول كزائر',
                            fontSize: AppFonts.t4,
                            color: AppColors.primary,
                            fontweight: FontWeight.bold),
                      ],
                    ),
                  )
                ],
              ),
            );
          })),
    );
  }
}
