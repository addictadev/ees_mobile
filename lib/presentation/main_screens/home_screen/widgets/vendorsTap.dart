import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_cashed_network_image.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../app/utils/app_colors.dart';
import '../../../../controllers/home_controller.dart';

class VendorList extends StatelessWidget {
  const VendorList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final vendors = provider.vendorModel?.data;

    if (provider.isLoadingVendors) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              text: "الموردين",
              padding: EdgeInsets.only(bottom: 1.5.h),
              fontweight: FontWeight.bold,
              color: AppColors.primary),
          Container(
            margin: EdgeInsets.only(bottom: 1.5.h),
            height: 5.5.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 35.w,
                  margin: EdgeInsets.only(left: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  padding: EdgeInsets.all(2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 3.h,
                        width: 3.h,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      ),
                      1.width,
                      Expanded(
                        child: Container(
                          height: 1.5.h,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    if (vendors == null || vendors.isEmpty) {
      return const SizedBox();
    }

    // Actual Vendor List
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
            text: "الموردين",
            padding: EdgeInsets.only(bottom: 1.5.h),
            fontweight: FontWeight.bold,
            color: AppColors.primary),
        Container(
          margin: EdgeInsets.only(bottom: 1.5.h),
          height: 5.5.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              final isSelected = provider.selectedVendor == vendor.id;

              return GestureDetector(
                onTap: () {
                  provider.setSelectedVendor(vendor.id!);
                  provider.currentPage = 1;
                  provider.getAllHomeProducts(refresh: true);
                },
                child: Container(
                  width: 35.w,
                  margin: EdgeInsets.only(left: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : Colors.transparent,
                      width: 0.25.w,
                    ),
                  ),
                  padding: EdgeInsets.all(2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3.w),
                        child: CustomCachedImage(
                          imageUrl: vendor.logo ?? "",
                          height: 3.h,
                          width: 3.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      1.width,
                      Expanded(
                        child: Text(
                          vendor.name ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color:
                                isSelected ? AppColors.primary : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
