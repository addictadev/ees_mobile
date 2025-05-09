import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/app_colors.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  const AppButton(this.title,
      {super.key,
      this.onTap,
      this.margin,
      this.buttonIcon,
      this.borderNum,
      this.titleColor = Colors.white,
      this.hieght,
      this.width,
      this.fontSize,
      this.hasBorder = false,
      this.WithBackIcon = false,
      this.borderRadius,
      this.titleWidget,
      this.borderColor = AppColors.btnColor,
      this.bgColor = AppColors.btnColor,
      this.isButtonDisabled = false,
      this.border});
  final Function? onTap;
  final String? title;
  final Widget? titleWidget;
  final Widget? buttonIcon;
  final Color? titleColor;
  final double? width, hieght, fontSize, borderNum;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final bool isButtonDisabled;
  final bool hasBorder;
  final Color borderColor;
  final EdgeInsetsGeometry? margin;
  final Color bgColor;
  final bool? WithBackIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      width: width ?? 100.w,
      height: hieght ?? 6.5.h,
      child: TextButton.icon(
        onPressed: isButtonDisabled ? null : onTap as void Function()?,
        style: TextButton.styleFrom(
          disabledBackgroundColor: bgColor,
          backgroundColor: isButtonDisabled
              ? const Color.fromRGBO(236, 236, 236, 1)
              : bgColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderNum ?? 1.w),
              side: BorderSide(
                  color: borderColor,
                  width: hasBorder ? 1.5 : 0,
                  style: hasBorder ? BorderStyle.solid : BorderStyle.none)),
        ),
        icon: const SizedBox(),
        label: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (WithBackIcon ?? false) buttonIcon ?? const SizedBox(),
            if (buttonIcon != null && WithBackIcon == false)
              SizedBox(
                width: 5.w,
              ),
            Center(
              child: CustomText(
                text: title!,
                textAlign: TextAlign.center,
                color: titleColor,
                fontweight: FontWeight.w500,
                fontSize: fontSize ?? 16.sp,
              ),
            ),
            WithBackIcon == true
                ? SizedBox(
                    width: 5.w,
                  )
                : const SizedBox(),
            if (WithBackIcon == false) buttonIcon ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
