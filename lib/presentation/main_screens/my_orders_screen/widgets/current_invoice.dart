import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InvoiceTab extends StatelessWidget {
  final String type;
  const InvoiceTab({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTag("تاريخ الطلب: 11/7/2024", Icons.calendar_today),
              _buildTag("تاريخ تحديث الطلب: 11/7/2024", Icons.calendar_today),
            ],
          ),
          SizedBox(height: 1.h),
          _buildTag("الرقم التعريفي : 23232#", Icons.document_scanner),
          3.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppAssets.appLogo, width: 20.w),
              2.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الشركة المصرية لحلول الكهرباء',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('عدد المنتجات: 3',
                        style: TextStyle(
                          fontSize: 15.sp,
                        )),
                    SizedBox(height: 5),
                    Text('إجمالي التكلفة: 6,250 ج.م',
                        style: TextStyle(
                            fontSize: 15.sp, color: AppColors.primary)),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          if (type == 'current') ...[
            Text('الطلبية قيد المراجعة من المورد',
                style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.lightOrange,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 5),
            Text('وسيتم الرد خلال أيام عمل', style: TextStyle(fontSize: 14.sp)),
          ],
          if (type == 'confirmed')
            Container(
              padding: EdgeInsets.all(3.w),
              margin: EdgeInsets.only(top: 3.w),
              decoration: getBoxDecoration(
                  fillColor: AppColors.lightOrange.withOpacity(.1),
                  withShadwos: false),
              child: Row(
                children: [
                  Icon(
                    Icons.location_city_outlined,
                    color: AppColors.lightOrange,
                  ),
                  2.width,
                  Expanded(
                    child: CustomText(
                        text: 'اقرب فرع لاستلام  الطلبيه : المعادي شارع 9',
                        color: AppColors.lightOrange,
                        textAlign: TextAlign.start,
                        fontweight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          2.height,
          Row(
            children: [
              if (type == 'current')
                Expanded(
                  child: AppButton(
                    'تعديل الطلب',
                    onTap: () {},
                    bgColor: AppColors.white,
                    hasBorder: true,
                    borderColor: AppColors.primary,
                    titleColor: AppColors.primary,
                  ),
                ),
              if (type == 'current') SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  'تفاصيل الفاتورة',
                  onTap: () {},
                  bgColor: AppColors.white,
                  hasBorder: true,
                  borderColor: AppColors.primary,
                  titleColor: AppColors.primary,
                ),
              ),
            ],
          ),
          if (type == 'previous') SizedBox(width: 10),
          if (type == 'previous')
            AppButton(
              'تقييم المورد',
              onTap: () {},
              margin: EdgeInsets.symmetric(vertical: 3.w),
            ),
        ],
      ),
    );
  }
}

Widget _buildTag(String text, IconData icon) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(1.5.w),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
      ],
    ),
  );
}
