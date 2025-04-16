import 'dart:async';

import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app/images_preview/custom_svg_img.dart';
import '../../app/utils/app_assets.dart';
import '../../app/utils/app_colors.dart';
import '../../app/utils/app_fonts.dart';
import '../../app/utils/validators.dart';
import '../../app/widgets/app_button.dart';
import '../../app/widgets/app_text.dart';
import '../../app/widgets/app_text_field.dart';
import '../../app/widgets/custom_pin_code_text_field.dart';
import '../../controllers/auth_controller.dart';
import '../Auth_screens/widget/custom_auth_appBar.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  Timer? _timer;
  int _secondsRemaining = 25;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _isResendEnabled = false;
    _secondsRemaining = 25;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _isResendEnabled = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    Provider.of<AuthController>(context, listen: false).otpCtn.dispose();
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          customAuthAppBar(title: "نسيت كلمة المرور"),
          Expanded(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Consumer<AuthController>(
                    builder: (BuildContext context, value, Widget? child) {
                  return Form(
                      key: value.newPassFormKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            2.height,
                            Center(
                              child: Image.asset(
                                AppAssets.appLogo,
                                width: 60.w,
                              ),
                            ),
                            2.height,
                            Center(
                              child: CustomText(
                                  text:
                                      'برجاء ادخال رمز التحقق المرسل لك\n على رقم الموبايل المسجل لدينا و كلمات المرور الجديدة'),
                            ),
                            2.height,

                            // Subtitle
                            Center(
                              child: Text(
                                'برجاء إدخال رمز التحقق المُرسل على رقم\n${value.phoneReisterController.text}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            // OTP Text Fields
                            3.height,
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: CustomPinCodeTextField(
                                controller: value.otpCtn,
                                textStyle: const TextStyle(
                                  color: AppColors.white,
                                ),
                                context: context,
                                validator: (value) => Validator.numbers(value),
                                onChanged: (val) {},
                                oncomplete: (String string) {},
                              ),
                            ),

                            CustomText(
                              text: 'كلمة المرور الجديدة',
                              fontSize: AppFonts.t4,
                            ),
                            AppTextField(
                              hintText: 'ادخل كلمة المرور الجديدة',
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
                              suffixIconOnTap: () =>
                                  value.togglePasswordVisibility(),
                              suffixIcon: value.isPasswordVisible
                                  ? Iconsax.eye
                                  : Iconsax.eye_slash,
                            ),
                            CustomText(
                              text: 'تآكيد كلمة المرور الجديدة',
                              fontSize: AppFonts.t4,
                            ),
                            AppTextField(
                              hintText: 'تاكيد كلمة المرور الجديدة',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  Iconsax.key,
                                  color: Colors.grey,
                                ),
                              ),
                              obscureText: !value.isConfirmPasswordVisible,
                              validator: (val) => Validator.confirmPassword(
                                  val, value.passwordController.text),
                              controller: value.confirmPasswordController,
                              suffixIconOnTap: () =>
                                  value.toggleConfirmPasswordVisibility(),
                              suffixIcon: value.isConfirmPasswordVisible
                                  ? Iconsax.eye
                                  : Iconsax.eye_slash,
                            ),
                            4.height,
                            AppButton('تآكيد', onTap: () {
                              if (value.forgetPassKey.currentState!
                                  .validate()) {
                                value.resetPassword();
                              }
                            }),
                            2.height,
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '$_secondsRemaining ثانية',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: _isResendEnabled
                                        ? () {
                                            _startTimer(); // تعيد تشغيل المؤقت
                                            value
                                                .forgetPassword(); // ترسل الكود
                                          }
                                        : null,
                                    child: Text(
                                      'لم يصلك الكود بعد؟ اضغط هنا',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _isResendEnabled
                                            ? AppColors.primary
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]));
                })),
          ),
        ],
      ),
    );
  }
}
