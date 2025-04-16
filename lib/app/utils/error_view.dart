import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'app_colors.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback onReload;
  final Widget? icon;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const ErrorView({
    super.key,
    required this.onReload,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bluebgColor,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ??
              Icon(
                Icons.error_outline,
                color: AppColors.primary,
                size: 48,
              ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "حدث خطأ في تحميل البيانات ، يرجى المحاولة مرة أخرى".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            onPressed: () {
              onReload();
            },
            child: Text(
              'اعادة المحاولة'.tr(),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
