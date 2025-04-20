import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../utils/app_colors.dart';

// ignore: must_be_immutable
class AppTextField extends StatefulWidget {
  AppTextField({
    this.labelText,
    this.hintText,
    this.suffixSize,
    this.lines,
    this.suffixColor,
    this.obscureText = false,
    this.suffixIconOnTap,
    this.prefixIcon,
    this.trailingIcon,
    this.contentPadding,
    this.controller,
    this.validator,
    this.onTap,
    this.textInputType,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.search = false,
    this.isFilled = false,
    this.onChanged,
    this.onSaved,
    this.borderColor,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.width,
    this.focusNode,
    this.id,
    this.inputFormatters,
    super.key,
  });
  String? labelText;
  String? hintText;
  int? lines;
  double? width;
  Widget? prefixIcon;
  Widget? trailingIcon;
  EdgeInsetsGeometry? contentPadding;
  TextEditingController? controller;
  String? Function(String?)? validator;
  Function()? suffixIconOnTap;
  bool obscureText;
  Function()? onTap;
  Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String?)? onFieldSubmitted;
  Function()? onEditingComplete;
  TextInputType? textInputType;
  bool enabled;
  bool readOnly;
  bool search;
  bool isFilled;
  IconData? suffixIcon;
  Color? suffixColor, borderColor;
  double? suffixSize;

  FocusNode? focusNode;
  int? id;
  List<TextInputFormatter>? inputFormatters = [];

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
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
      child: Container(
        width: widget.width ?? 100.w,
        padding: EdgeInsets.only(top: 3.w),
        child: TextFormField(
          obscureText: widget.obscureText,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          style: const TextStyle(color: AppColors.black),
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          textInputAction:
              widget.search ? TextInputAction.search : TextInputAction.next,
          readOnly: widget.readOnly,
          controller: widget.controller,
          validator: widget.validator,
          onTap: widget.onTap,
          enabled: widget.enabled,
          keyboardType: widget.textInputType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          minLines: widget.lines,
          maxLines: widget.lines ?? 1,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.start,
          onChanged: (value) {
            setState(() {}); // Refresh to show/hide suffix icon
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          onSaved: widget.onSaved,
          onFieldSubmitted: (value) {
            if (widget.onFieldSubmitted != null) {
              widget.onFieldSubmitted!(value);
            }
            FocusManager.instance.primaryFocus?.unfocus(); // Dismiss keyboard
          },
          onEditingComplete: widget.onEditingComplete,
          decoration: InputDecoration(
            errorMaxLines: 3,
            fillColor: widget.isFilled ? AppColors.grey : AppColors.white,
            filled: true,
            labelText: widget.labelText,
            labelStyle: const TextStyle(color: AppColors.grey),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 15.sp),
            contentPadding: widget.contentPadding,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(2.w)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.grey, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(2.w)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.primary, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(2.w)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.grey, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(2.w)),
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.trailingIcon ??
                IconButton(
                    onPressed: widget.suffixIconOnTap,
                    icon: Icon(
                      widget.suffixIcon,
                      color: widget.suffixColor,
                      size: widget.suffixSize,
                    )),
          ),
        ),
      ),
    );
  }
}
