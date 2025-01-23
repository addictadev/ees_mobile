// ignore_for_file: non_constant_identifier_names

import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget CustomText(
        {Key? key,
        String? text,
        Color? color,
        underLine,
        void Function()? onTap,
        bool isBold = false,
        double? fontSize,
        TextAlign? textAlign,
        FontWeight? fontweight,
        String? fontFamily,
        padding,
        TextOverflow? overflow,
        int? maxLines}) =>
    onTap == null
        ? Padding(
            padding: padding ?? const EdgeInsets.all(0),
            child: Text(
              text ?? '',
              textAlign: textAlign ?? TextAlign.center,
              style: TextStyle(
                decoration: underLine == true
                    ? TextDecoration.underline
                    : TextDecoration.none,
                color: color ?? AppColors.black,
                fontSize: fontSize ?? AppFonts.t4,
                fontWeight: fontweight ?? FontWeight.normal,
              ),
              overflow: overflow,
              maxLines: maxLines,
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: padding ?? const EdgeInsets.all(0),
              child: Text(
                text!,
                textAlign: textAlign ?? TextAlign.center,
                style: TextStyle(
                    decoration: underLine == true
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    color: color ?? AppColors.black,
                    fontSize: fontSize ?? AppFonts.t3,
                    fontWeight: fontweight ?? FontWeight.normal,
                    fontFamily: isBold == true ? 'MontserratBold' : fontFamily),
                overflow: overflow,
                maxLines: maxLines,
              ),
            ),
          );
