import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

void showRatingDialog(BuildContext context) {
  double rating = 4.0;
  TextEditingController commentController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: EdgeInsets.all(3.w),
          backgroundColor: AppColors.white,
          content: SizedBox(
            width: 90.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.w, right: 2.w),
                      child: Icon(
                        Icons.close,
                        size: 6.w,
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 30,
                  allowHalfRating: true,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: AppColors.primary),
                  onRatingUpdate: (val) {
                    setState(() => rating = val);
                  },
                ),
                SizedBox(height: 2.h),
                Text(
                  'قيّم تجربتك مع المورد!',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: AppFonts.t2),
                ),
                SizedBox(height: 1.h),
                const Text(
                  'تقييمك يساعدنا لتحسين التجربة أكثر وتقديمك\n أفضل خدمة.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.5.h),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text('ملاحظات الطلبية',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      )),
                ),
                AppTextField(
                  controller: commentController,
                  lines: 3,
                  borderColor: AppColors.blueColor,
                  hintText: 'اكتب ملاحظاتك الطلبية الخاصة بك',
                ),
                const SizedBox(height: 15),
                AppButton(
                  'تأكيد التقييم',
                  onTap: () {
                    Navigator.pop(context);
                    showThanksDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showThanksDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        width: 300,
        height: 150,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'شكرًا لتقييمك!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary),
              ),
              SizedBox(height: 1.h),
              Text(
                'شكرًا لك لمشاركتك لنا تجربتك معنا.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ),
      ],
    ),
  );
}

void showCancelOrderDialog(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.w, right: 2.w),
                    child: Icon(
                      Icons.close,
                      size: 6.w,
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Icon(Iconsax.info_circle, color: AppColors.red, size: 15.w),
              SizedBox(height: 1.5.h),
              const Text(
                'هل أنت متأكد من إلغاء الطلب؟',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'عند تأكيد الإلغاء، لن تتمكن من التراجع عن هذه العملية',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: CustomText(text: 'إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                      ),
                      child: CustomText(text: 'تأكيد', color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
