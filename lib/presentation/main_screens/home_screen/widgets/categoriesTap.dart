import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/widgets/app_text.dart';
import 'package:ees/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../app/utils/app_colors.dart';

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final categories = provider.categoriesModel!.data; // From backend

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomText(
            text: 'الاقسام',
            padding: EdgeInsets.only(bottom: 1.5.h, top: 1.5.h),
            fontweight: FontWeight.bold,
            color: AppColors.primary),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Local "All" tab
              _buildCategoryTab(context, "الكل", null, 0, provider),
              ...List.generate(categories!.length, (index) {
                final category = categories[index];
                return _buildCategoryTab(
                  context,
                  category.name ?? "",
                  category.id,
                  index + 1,
                  provider,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTab(
    BuildContext context,
    String title,
    dynamic categoryId,
    int index,
    HomeProvider provider,
  ) {
    return GestureDetector(
      onTap: () {
        provider.setSelectedCategory(index);
        // provider.fetchProductsByCategory(categoryId); // fetch by category
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
        margin: EdgeInsets.only(left: 3.w, bottom: 1.5.h),
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
            color: provider.selectedCategory == index
                ? AppColors.primary
                : Colors.transparent,
            width: 0.25.w,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: provider.selectedCategory == index
                ? AppColors.primary
                : Colors.black87,
            fontWeight: provider.selectedCategory == index
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
