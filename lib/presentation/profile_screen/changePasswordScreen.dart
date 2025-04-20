import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_asset_img.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/custom_app_bar.dart';
import 'package:ees/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app/utils/app_fonts.dart';
import '../../app/utils/validators.dart';
import '../../app/widgets/app_text.dart';
import '../../app/widgets/app_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthController>(
          builder: (BuildContext context, value, Widget? child) {
        return Form(
          key: value.changePassFormKey,
          child: Column(
            children: [
              CustomeAppBar(text: 'تغيير كلمة المرور'),
              1.height,
              CustomImageAsset(
                assetName: AppAssets.appLogo,
                width: 50.w,
              ),
              1.height,
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: ' كلمة المرور الحالية',
                        fontSize: AppFonts.t4,
                      ),
                      AppTextField(
                        hintText: 'ادخل كلمة المرور الحالية',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Iconsax.key,
                            color: Colors.grey,
                          ),
                        ),
                        obscureText: !value.isOldPasswordVisible,
                        validator: (value) => Validator.password(value),
                        controller: value.oldPasswordController,
                        suffixIconOnTap: () =>
                            value.togeleOldPasswordVisibility(),
                        suffixIcon: value.isOldPasswordVisible
                            ? Iconsax.eye
                            : Iconsax.eye_slash,
                      ),
                      CustomText(
                        text: 'كلمة المرور الجديدة',
                        fontSize: AppFonts.t4,
                      ),
                      AppTextField(
                        hintText: 'ادخل كلمة المرور الجديدة',
                        obscureText: !value.isPasswordVisible,
                        validator: (value) => Validator.password(value),
                        controller: value.passwordController,
                        suffixIconOnTap: () => value.togglePasswordVisibility(),
                        suffixIcon: value.isPasswordVisible
                            ? Iconsax.eye
                            : Iconsax.eye_slash,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Iconsax.key,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      CustomText(
                        text: 'تأكيد كلمة المرور الجديدة',
                        fontSize: AppFonts.t4,
                      ),
                      AppTextField(
                        hintText: 'ادخل كلمة المرور الجديدة',
                        obscureText: !value.isConfirmPasswordVisible,
                        validator: (val) => Validator.confirmPassword(
                            val, value.passwordController.text),
                        controller: value.confirmPasswordController,
                        suffixIconOnTap: () =>
                            value.toggleConfirmPasswordVisibility(),
                        suffixIcon: value.isConfirmPasswordVisible
                            ? Iconsax.eye
                            : Iconsax.eye_slash,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Iconsax.key,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      4.height,
                      AppButton('تغيير كلمة المرور', onTap: () {
                        if (value.changePassFormKey.currentState!.validate()) {
                          value.changePassword();
                        }
                      })
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
