import 'package:ees/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final Color? textColor;
  final String? tag;
  final VoidCallback? onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    this.color,
    this.onTap,
    this.textColor,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            color: color ?? AppColors.bluebgColor,
            margin: EdgeInsets.symmetric(vertical: 1.3.h, horizontal: 3.w),
            child: ListTile(
              leading: Icon(icon, color: textColor ?? AppColors.primary),
              title: Text(
                title,
                style: TextStyle(color: textColor ?? AppColors.primary),
              ),
              onTap: onTap,
            ),
          ),
        ),
        if (tag != null)
          Positioned(
            top: 2.h,
            left: 0,
            child: Container(
              margin: EdgeInsets.only(left: 3.w),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.w),
              decoration: BoxDecoration(
                color: AppColors.lightOrange,
                borderRadius: BorderRadius.circular(1.w),
              ),
              child: Text(
                tag!,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
