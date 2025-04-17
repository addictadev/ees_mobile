import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class MinimumOrderWidget extends StatelessWidget {
  const MinimumOrderWidget({
    super.key,
    required this.currentAmount,
    required this.minimumOrder,
  });
  final double currentAmount;
  final double minimumOrder;

  @override
  Widget build(BuildContext context) {
    final double progress = (currentAmount / minimumOrder).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: getBoxDecoration(
          fillColor: AppColors.bluebgColor, withShadwos: false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${minimumOrder.toStringAsFixed(0)} ${'EGP'.tr()} / ',
                style: TextStyle(color: Colors.black, fontSize: 14.sp),
              ),
              Text(
                '${currentAmount.toStringAsFixed(0)} ${'EGP'.tr()}',
                style: TextStyle(color: Colors.black45, fontSize: 14.sp),
              ),
              2.width,
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: LinearProgressIndicator(
                    value: progress,
                    borderRadius: BorderRadius.circular(12.w),
                    backgroundColor: Colors.red.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        progress == 1 ? Colors.green : Colors.red),
                    minHeight: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          progress == 1
              ? const SizedBox()
              : Text(
                  "كمل فاتورتك للحد الأدني للطلب",
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
          2.height,
        ],
      ),
    );
  }
}
