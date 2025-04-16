import 'package:ees/app/extensions/sized_box_extension.dart';
import 'package:ees/app/images_preview/custom_svg_img.dart';
import 'package:ees/app/utils/app_assets.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:ees/app/utils/app_fonts.dart';
import 'package:ees/app/utils/show_toast.dart';
import 'package:ees/app/widgets/app_button.dart';
import 'package:ees/app/widgets/app_text_field.dart';
import 'package:ees/app/widgets/style.dart';
import 'package:ees/controllers/home_controller.dart';
import 'package:ees/presentation/main_screens/home_screen/widgets/products_home_grids.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'widgets/categoriesTap.dart';
import 'widgets/homeAppBar.dart';
import 'widgets/vendorsTap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HomeProvider>(context, listen: false).getAllCategories();
      Provider.of<HomeProvider>(context, listen: false).getAlVendors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBg,
      body: Consumer<HomeProvider>(
          builder: (BuildContext context, value, Widget? child) {
        return Column(
          children: [
            HomeAppBar(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: SearchAmdFilterWidget(),
            ),
            2.height,
            Expanded(
              child: value.isLoadingCategories || value.isLoadingVendors
                  ? loadingIndicator
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 3.w,
                          right: 3.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SliderWidget(),
                            const CategoryTabs(),
                            VendorList(),
                            const ProductGrid(),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}

Widget SearchAmdFilterWidget() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      AppTextField(
        width: 75.w,
        hintText: 'ابحث عن منتجات أو علامة تجارية',
        borderColor: AppColors.white,
        prefixIcon: Padding(
          padding: EdgeInsets.all(2.w),
          child: CustomSvgImage(assetName: AppAssets.searchIcon),
        ),
      ),
      Container(
        height: 7.h,
        width: 7.h,
        margin: EdgeInsets.only(top: 3.w),
        decoration: getBoxDecoration(),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: CustomSvgImage(
            assetName: AppAssets.filterIcon,
            height: 2.w,
          ),
        ),
      )
    ],
  );
}

// Home Screen
// Slider Widget
class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 17.h,
      width: 100.w,
      child: PageView(
        children: [
          _buildSliderItem(),
          _buildSliderItem(),
          _buildSliderItem(),
        ],
      ),
    );
  }

  Widget _buildSliderItem() {
    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.w),
        color: Colors.blue.shade100,
      ),
      child: Stack(
        children: [
          Positioned(
            right: 3.w,
            top: 1.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "خصومات",
                  style: TextStyle(
                      fontSize: AppFonts.h2, fontWeight: FontWeight.bold),
                ),
                Text(
                  "تصل إلى %50",
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.5.h),
                AppButton(
                  'اطلب الآن',
                  borderNum: 3.w,
                  hieght: 4.5.h,
                  fontSize: 14.sp,
                  bgColor: AppColors.primary,
                  width: 22.w,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Category Tabs

// Product Grid


// Category Provider
