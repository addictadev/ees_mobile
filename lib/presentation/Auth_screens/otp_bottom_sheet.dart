import 'dart:async';

import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/app/utils/validators.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:ees/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app/widgets/custom_pin_code_text_field.dart';

class VerificationBottomSheet extends StatefulWidget {
  const VerificationBottomSheet({super.key});

  @override
  State<VerificationBottomSheet> createState() =>
      _VerificationBottomSheetState();
}

class _VerificationBottomSheetState extends State<VerificationBottomSheet> {
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
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
        builder: (BuildContext context, value, Widget? child) {
      return Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.only(bottom: 3.w),
              width: 30.w,
              decoration: getBoxDecoration(fillColor: Colors.grey),
            ),
            // Title
            Text(
              'التحقق من رقم التليفون للتسجيل',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Subtitle
            Text(
              'برجاء إدخال رمز التحقق المُرسل على رقم\n${value.phoneReisterController.text}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            // OTP Text Fields
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
                oncomplete: (String string) {
                  value.verfiyOtpApi();
                },
              ),
            ),
            SizedBox(height: 16),
            AppButton(
              "تاكيد",
              onTap: () {
                if (value.otpCtn.text.isEmpty) {
                  showCustomedToast('برجاءإدخال رمز التحقق', ToastType.error);
                } else {
                  value.verfiyOtpApi();
                }
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_secondsRemaining ثانية',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            GestureDetector(
              onTap: _isResendEnabled
                  ? () {
                      _startTimer();
                      value.resendOtp();
                    }
                  : null,
              child: Text(
                'لم يصلك الكود بعد؟ اضغط هنا',
                style: TextStyle(
                  fontSize: 14,
                  color: _isResendEnabled ? AppColors.primary : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      );
    });
  }
}
