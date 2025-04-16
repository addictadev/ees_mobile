import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductHeader(),
          Divider(color: Colors.grey[300], thickness: 1),
          SizedBox(height: 1.h),
          ProductAttributes(),
        ],
      ),
    );
  }
}

class ProductHeader extends StatelessWidget {
  const ProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2.w),
          child: Image.asset(
            AppAssets.product1, // Replace with actual image URL
            width: 20.w,
            height: 20.w,
            fit: BoxFit.contain,
          ),
        ),
        2.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "لمبات سترا ليد فليلوط كروي وورم مصري - 3 وات",
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "كراتونة X50",
                    style: GoogleFonts.cairo(
                      fontSize: 15.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "ج.م 5.25",
                    style: GoogleFonts.cairo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.5.h,
      children: [
        _AttributeItem(icon: Icons.category, label: "الشكل", value: "دائري"),
        _AttributeItem(
            icon: Icons.inventory, label: "أقصى كمية", value: "3 كراتونة X50"),
        _AttributeItem(
            icon: Icons.inventory, label: "أقل كمية", value: "كراتونة X50"),
        _AttributeItem(icon: Icons.format_paint, label: "اللون", value: "ابيض"),
        _AttributeItem(
            icon: Icons.business, label: "العلامة التجارية", value: "Siemens"),
      ],
    );
  }
}

class _AttributeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AttributeItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: Colors.grey[600]),
          SizedBox(width: 2.w),
          Text(
            "$label: $value",
            style: GoogleFonts.cairo(
                fontSize: 14.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class CompanyInfo extends StatelessWidget {
  const CompanyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CompanyHeader(),
          _CompanyDetails(),
          SizedBox(height: 2.h),
          Divider()
        ],
      ),
    );
  }
}

class _CompanyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2.w),
          child: Image.asset(
            AppAssets.logo, // Replace with actual image URL
            width: 20.w,
            height: 20.w,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          "الشركة المصرية للحلول الكهربائية",
          style: GoogleFonts.cairo(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _CompanyDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompanyDetailItem(
          icon: Icons.attach_money,
          label: "حد أدنى للطلبية",
          value: "5000 ج.م",
        ),
        SizedBox(height: 1.h),
        _CompanyDetailItem(
          icon: Icons.local_shipping,
          label: "التوصيل",
          value: "خلال 3 أيام",
        ),
      ],
    );
  }
}

class _CompanyDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CompanyDetailItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: Colors.grey[600]),
          SizedBox(width: 2.w),
          Text(
            "$label: $value",
            style: GoogleFonts.cairo(
                fontSize: 15.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AppButton(
      "أضف إلى العربة",
      width: 45.w,
    ));
  }
}
