import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import 'app_text.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final List<T> items;
  final T? value;
  final void Function(T?) onChanged;
  final String Function(T)? itemToString;
  final String? Function(T?)? validator;
  final bool isFilled;
  final bool enabled;
  final bool readOnly;
  final Color? borderColor;
  final Color? fillColor;
  final double? width;
  final EdgeInsetsGeometry? contentPadding;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.labelText,
    this.hintText,
    this.itemToString,
    this.validator,
    this.isFilled = false,
    this.enabled = true,
    this.readOnly = false,
    this.borderColor,
    this.fillColor,
    this.width,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: AppColors.primary,
          cursorColor: AppColors.primary,
          selectionHandleColor: AppColors.primary,
        ),
      ),
      child: Column(
        children: [
          if (labelText != null)
            Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  text: labelText!,
                  fontSize: AppFonts.t4,
                )),
          Container(
            width: width ?? 100.w,
            padding: EdgeInsets.only(top: 3.w),
            child: DropdownButtonFormField<T>(
              value: value,
              onChanged: readOnly ? null : onChanged,
              validator: validator,
              style: TextStyle(
                  color: AppColors.black,
                  fontSize: 15.sp,
                  fontFamily: GoogleFonts.cairo().fontFamily),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                // labelText: labelText,
                labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                    fontFamily: GoogleFonts.cairo().fontFamily),
                hintText: hintText,
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                    fontFamily: GoogleFonts.cairo().fontFamily),
                contentPadding: contentPadding ??
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                filled: true,
                fillColor:
                    isFilled ? AppColors.grey : (fillColor ?? AppColors.white),
                enabled: enabled,
                enabledBorder:
                    buildOutlineInputBorder(borderColor ?? AppColors.grey),
                disabledBorder:
                    buildOutlineInputBorder(borderColor ?? AppColors.grey),
                focusedBorder: buildOutlineInputBorder(AppColors.primary),
                errorBorder: buildOutlineInputBorder(AppColors.red),
                focusedErrorBorder: buildOutlineInputBorder(AppColors.red),
              ),
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemToString?.call(item) ?? item.toString()),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: BorderRadius.circular(2.w),
    );
  }
}
