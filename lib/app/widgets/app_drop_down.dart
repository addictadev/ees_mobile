// ignore_for_file: prefer_const_constructors, file_names

import 'package:ees/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: non_constant_identifier_names
Widget WidgetCustomDropdownFormField({
  Widget? labelContent,
  List<DropdownMenuItem<dynamic>>? items,
  dynamic value,
  void Function(dynamic)? onChanged,
  double? width,
  String? labelText,
  String? hintText,
  double? height,
  EdgeInsetsGeometry? contentPadding,
  Function? validation,
  Color? fillColor,
  Color? borderColor,
  double? radius,
}) {
  return Container(
    height: height,
    width: width ?? 100.w,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius ?? 3.w),
      color: fillColor ?? AppColors.white,
      border: Border.all(color: borderColor ?? AppColors.grey, width: .25.w),
    ),
    margin: EdgeInsets.symmetric(
      vertical: 2.w,
    ),
    padding: EdgeInsets.all(5),
    child: DropdownButtonFormField(
      value: value,
      items: items,
      icon: Icon(
        Icons.keyboard_arrow_down,
        size: 20,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 3.w),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              vertical: 2.w,
            ),
        alignLabelWithHint: true,
        labelText: labelText ?? '',
        hintText: hintText ?? '',
        hintStyle: TextStyle(color: AppColors.grey),
        focusColor: AppColors.primary,
        disabledBorder: InputBorder.none,
        hoverColor: AppColors.grey,
        enabled: true,
        fillColor: fillColor ?? AppColors.white,
      ),
    ),
  );
}
