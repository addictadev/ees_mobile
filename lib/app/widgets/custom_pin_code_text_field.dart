// ignore_for_file: must_be_immutable

import 'package:ees/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

class CustomPinCodeTextField extends StatelessWidget {
  CustomPinCodeTextField(
      {super.key,
      required this.context,
      required this.onChanged,
      this.alignment,
      this.controller,
      this.textStyle,
      this.hintStyle,
      this.validator,
      required this.oncomplete});

  final Alignment? alignment;

  final BuildContext context;

  final TextEditingController? controller;

  final TextStyle? textStyle;

  final TextStyle? hintStyle;

  Function(String) onChanged;
  Function(String) oncomplete;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: pinCodeTextFieldWidget,
          )
        : pinCodeTextFieldWidget;
  }

  Widget get pinCodeTextFieldWidget => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: PinCodeTextField(
          appContext: context,
          controller: controller,
          length: 6,
          keyboardType: TextInputType.number,
          textStyle: textStyle,
          hintStyle: hintStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          enableActiveFill: true,
          pinTheme: PinTheme(
            fieldHeight: 5.5.h,
            fieldWidth: 5.5.h,
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(2.w),
            inactiveColor: AppColors.grey,
            activeColor: AppColors.white,
            selectedFillColor: AppColors.primary,
            inactiveFillColor: AppColors.white,
            activeFillColor: AppColors.primary,
            selectedColor: Colors.transparent,
          ),
          onChanged: (value) => onChanged(value),
          onCompleted: (value) => oncomplete(value),
          validator: validator,
        ),
      );
}
